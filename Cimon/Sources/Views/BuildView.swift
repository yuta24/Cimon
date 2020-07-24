//
//  BuildView.swift
//  Cimon
//
//  Created by Yu Tawata on 2020/07/10.
//

import SwiftUI
import Combine
import ComposableArchitecture
import Domain
import Mocha
import BitriseAPI
import Core

struct BuildState: Equatable {
    var model: BuildListAllResponseItemModel
    var buildLogState: BuildLogState?

    var alert: AlertState<BuildAction>?
    var isNavigationActive = false
}

enum BuildAction: Equatable {
    case buildLog(BuildLogAction)

    case setNavigation(isActive: Bool)
    case setNavigationIsActiveDelayCompleted

    case rebuildTapped
    case rebuild
    case rebuildResponse(Result<BuildRequestUpdateResponseModel, Client.Failure>)

    case alertDismissed
}

class BuildEnvironment {
    let session: URLSession
    let client: Client

    init(
        session: URLSession,
        client: Client
    ) {
        self.session = session
        self.client = client
    }
}

let buildReducer: Reducer<BuildState, BuildAction, BuildEnvironment> = Reducer.combine(
    buildLogReducer.optional.pullback(
        state: \.buildLogState,
        action: /BuildAction.buildLog,
        environment: { BuildLogEnvironment(session: $0.session, client: $0.client) }
    ),
    Reducer { state, action, environment in

        switch action {

        case .buildLog:

            return .none

        case .setNavigation(true):
            state.isNavigationActive = true
            return Effect(value: .setNavigationIsActiveDelayCompleted)
                .delay(for: 1, scheduler: DispatchQueue.main)
                .eraseToEffect()

        case .setNavigation(false):
            state.isNavigationActive = false
            state.buildLogState = .none

            return .none

        case .setNavigationIsActiveDelayCompleted:
            state.buildLogState = .init(model: state.model, log: .none, alert: .none)

            return .none

        case .rebuildTapped:
            state.alert = .init(
                title: "Run rebuild?",
                primaryButton: .default("OK", send: .rebuild),
                secondaryButton: .cancel(send: .alertDismissed)
            )

            return .none

        case .rebuild:

            return environment.client.publisher(for: Endpoint.BuildRequestRequest(appSlug: state.model.repository!.slug!, buildRequestSlug: state.model.slug!, isApproved: true))
                .catchToEffect()
                .map(BuildAction.rebuildResponse)
                .receive(on: DispatchQueue.main)
                .eraseToEffect()

        case .rebuildResponse(let result):
            switch result {
            case .success(let response):
                break
            case .failure(let error):
                state.alert = .init(title: "Error", message: error.localizedDescription)
            }

            return .none

        case .alertDismissed:
            state.alert = .none

            return .none

        }

    }
)

struct BuildView: View {

    struct OverviewView: View {

        var model: BuildListAllResponseItemModel

        @State
        private var showCommitMessageAll = false

        var body: some View {
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    if let slug = model.repository?.repoSlug {
                        Text("\(slug)")
                            .font(.title2)
                            .bold()
                    }

                    Divider()

                    VStack(alignment: .leading) {
                        Text("Commit Message")
                            .bold()
                        model.commitMessage.flatMap(Text.init)
                            .font(.subheadline)
                            .lineLimit(showCommitMessageAll ? .none : 2)
                    }

                    if !showCommitMessageAll {
                        HStack {
                            Spacer()

                            Button(action: { showCommitMessageAll = true }, label: { Text("Show") })
                        }
                    }

                    if let pullRequestViewUrl = model.pullRequestViewUrl {
                        Divider()

                        VStack(alignment: .leading) {
                            Text("Pull Request")
                                .bold()
                            Link(pullRequestViewUrl, destination: URL(string: pullRequestViewUrl)!)
                                .font(.subheadline)
                        }
                    }
                }

                Divider()

                HStack {
                    Text("Duration")
                        .font(.subheadline)
                        .foregroundColor(Color(.secondaryLabel))

                    Spacer()

                    model.duration.flatMap(Formatter.hhmmss.string(from:))
                        .flatMap(Text.init)
                        .font(.subheadline)
                }

                HStack {
                    Text("Triggered at")
                        .font(.subheadline)
                        .foregroundColor(Color(.secondaryLabel))

                    Spacer()

                    model.triggeredAt
                        .flatMap(Formatter.iso8601.date(from:))
                        .flatMap(Formatter.yMdHms.string(from:))
                        .flatMap(Text.init)
                        .font(.subheadline)
                }
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(8)
            .padding()
        }
    }

    let store: Store<BuildState, BuildAction>

    @Environment(\.presentationMode)
    private var presentationMode: Binding<PresentationMode>
    @State
    private var isRebuildPresented = false

    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                ScrollView {

                    OverviewView(model: viewStore.model)

                    VStack {
                        NavigationLink(
                            destination: IfLetStore(
                                self.store.scope(state: { $0.buildLogState }, action: BuildAction.buildLog),
                                then: BuildLogView.init(store:)
                            ),
                            isActive: viewStore.binding(
                                get: { $0.isNavigationActive },
                                send: BuildAction.setNavigation(isActive:)
                            ),
                            label: {
                                HStack {
                                    Text("Logs")
                                    Spacer()
                                }
                            }
                        )

                        Divider()

                        NavigationLink(
                            destination: Text("full lists"),
                            label: {
                                HStack {
                                    Text("Apps & Artifacts")
                                    Spacer()
                                }
                            }
                        )
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
                    .padding()

                    if !(viewStore.model.ext.status?.isInprogress ?? false) {
                        VStack {
                            Button(
                                action: { viewStore.send(.rebuildTapped) },
                                label: {
                                HStack {
                                    Spacer()
                                    Text("Rebuild")
                                        .foregroundColor(Color(.label))
                                        .bold()
                                    Spacer()
                                }
                            })
                        }
                        .padding()
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                            .stroke(lineWidth: 2)
                            .foregroundColor(Color(.label))
                        )
                        .padding()
                    }
                }
                .navigationTitle("Build #\(viewStore.model.buildNumber ?? 0)")
                .navigationBarItems(
                    leading: Button(
                        action: { presentationMode.wrappedValue.dismiss() },
                        label: { Image(systemName: "xmark") }
                    )
                )
            }
            .alert(store.scope(state: \.alert), dismiss: .alertDismissed)
        }
    }

}
