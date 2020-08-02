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
    var buildArtifactsState: BuildArtifactsState?

    var alert: AlertState<BuildAction>?
    var isToBuildLogNavigationActive = false
    var isToBuildArtifactNavigationActive = false
}

enum BuildAction: Equatable {
    case buildLog(BuildLogAction)
    case buildArtifacts(BuildArtifactsAction)

    case rebuildTapped
    case rebuild
    case rebuildResponse(Result<BuildRequestUpdateResponseModel, Client.Failure>)

    case setToBuildLogNavigation(isActive: Bool)
    case setToBuildArtifactNavigation(isActive: Bool)
    case setToBuildLogNavigationIsActiveDelayCompleted
    case setToBuildArtifactNavigationIsActiveDelayCompleted
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
    buildArtifactsReducer.optional.pullback(
        state: \.buildArtifactsState,
        action: /BuildAction.buildArtifacts,
        environment: { BuildArtifactsEnvironment(client: $0.client) }
    ),
    Reducer { state, action, environment in

        switch action {

        case .buildLog:

            return .none

        case .buildArtifacts:

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

        case .setToBuildLogNavigation(true):
            state.isToBuildLogNavigationActive = true
            return Effect(value: .setToBuildLogNavigationIsActiveDelayCompleted)
                .delay(for: 1, scheduler: DispatchQueue.main)
                .eraseToEffect()

        case .setToBuildLogNavigation(false):
            state.isToBuildLogNavigationActive = false
            state.buildLogState = .none

            return .none

        case .setToBuildArtifactNavigation(true):
            state.isToBuildArtifactNavigationActive = true
            return Effect(value: .setToBuildArtifactNavigationIsActiveDelayCompleted)
                .delay(for: 1, scheduler: DispatchQueue.main)
                .eraseToEffect()

        case .setToBuildArtifactNavigation(false):
            state.isToBuildArtifactNavigationActive = false
            state.buildArtifactsState = .none

            return .none

        case .setToBuildLogNavigationIsActiveDelayCompleted:
            state.buildLogState = .init(model: state.model, log: .none, alert: .none)

            return .none

        case .setToBuildArtifactNavigationIsActiveDelayCompleted:
            state.buildArtifactsState = .init(model: state.model, models: [], alert: .none)

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
                        .foregroundColor(Color(.secondaryLabel))
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
                        .foregroundColor(Color(.secondaryLabel))
                }
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(8)
            .padding()
        }
    }

    let store: Store<BuildState, BuildAction>

    @State
    private var isRebuildPresented = false

    @ViewBuilder
    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView {
                OverviewView(model: viewStore.model)

                VStack {
                    NavigationLink(
                        destination: IfLetStore(
                            self.store.scope(
                                state: { $0.buildLogState },
                                action: BuildAction.buildLog
                            ),
                            then: BuildLogView.init(store:)
                        ),
                        isActive: viewStore.binding(
                            get: { $0.isToBuildLogNavigationActive },
                            send: BuildAction.setToBuildLogNavigation(isActive:)
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
                        destination: IfLetStore(
                            self.store.scope(
                                state: { $0.buildArtifactsState },
                                action: BuildAction.buildArtifacts
                            ),
                            then: BuildArtifactsView.init(store:)
                        ),
                        isActive: viewStore.binding(
                            get: { $0.isToBuildArtifactNavigationActive },
                            send: BuildAction.setToBuildArtifactNavigation(isActive:)
                        ),
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
        }
        .alert(store.scope(state: \.alert), dismiss: .alertDismissed)
    }

}
