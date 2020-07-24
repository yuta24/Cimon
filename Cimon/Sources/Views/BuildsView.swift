//
//  BuildsView.swift
//  Cimon
//
//  Created by Yu Tawata on 2020/07/07.
//

import SwiftUI
import Combine
import ComposableArchitecture
import FetchImage
import Mocha
import Domain
import BitriseAPI
import Core

struct BuildsState: Equatable {
    var models: [BuildListAllResponseItemModel]
    var paging: PagingResponseModel?

    var selection: Identified<Int, BuildState?>?
    var alert: AlertState<BuildsAction>?
}

enum BuildsAction: Equatable {
    case build(BuildAction)

    case load
    case loadMore

    case loadResponse(Result<BuildListAllResponseModel, Client.Failure>)
    case loadMoreResponse(Result<BuildListAllResponseModel, Client.Failure>)

    case setNavigation(selection: Int?)
    case setNavigationSelectionDelayCompleted
    case alertDismissed
    case gearTapped
}

class BuildsEnvironment {
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

let buildsReducer: Reducer<BuildsState, BuildsAction, BuildsEnvironment> = Reducer.combine(
    buildReducer.optional
        .pullback(state: \Identified.value, action: .self, environment: { $0 })
        .optional
        .pullback(
            state: \.selection,
            action: /BuildsAction.build,
            environment: { BuildEnvironment(session: $0.session, client: $0.client) }
        ),
    Reducer { state, action, environment in

        struct CancelId: Hashable {}

        switch action {

        case .build:

            return .none

        case .load:
            return environment.client.publisher(for: Endpoint.BuildsRequest(ownerSlug: .none, isOnHold: .none, status: .none, next: .none, limit: 25))
                .catchToEffect()
                .map(BuildsAction.loadResponse)
                .receive(on: DispatchQueue.main)
                .eraseToEffect()

        case .loadMore:
            return environment.client.publisher(for: Endpoint.BuildsRequest(ownerSlug: .none, isOnHold: .none, status: .none, next: state.paging?.next, limit: 25))
                .catchToEffect()
                .map(BuildsAction.loadMoreResponse)
                .receive(on: DispatchQueue.main)
                .eraseToEffect()

        case .loadResponse(let result):
            switch result {
            case .success(let response):
                state.models = response.data ?? []
                state.paging = response.paging
                state.alert = .none
            case .failure(let error):
                state.alert = .init(title: "Error", message: error.localizedDescription)
            }

            return .none

        case .loadMoreResponse(let result):
            switch result {
            case .success(let response):
                state.models.append(contentsOf: response.data ?? [])
                state.paging = response.paging
                state.alert = .none
            case .failure(let error):
                state.alert = .init(title: "Error", message: error.localizedDescription)
            }

            return .none

        case .setNavigation(.some(let index)):
            state.selection = Identified(nil, id: index)

            return Effect(value: .setNavigationSelectionDelayCompleted)
                .delay(for: 1, scheduler: DispatchQueue.main)
                .eraseToEffect()
                .cancellable(id: CancelId())

        case .setNavigation(.none):
            state.selection = nil

            return .cancel(id: CancelId())

        case .setNavigationSelectionDelayCompleted:
            guard let index = state.selection?.id else {
                return .none
            }
            state.selection?.value = .init(model: state.models[index], buildLogState: .none, alert: .none, isNavigationActive: false)

            return .none

        case .alertDismissed:
            state.alert = .none

            return .none

        case .gearTapped:

            return .none

        }
    }
)

struct BuildsView: View {

    struct ItemView: View {
        let model: BuildListAllResponseItemModel

        var body: some View {
            HStack(spacing: 0) {
                (model.ext.status?.color).flatMap(Color.init)
                    .flatMap { Rectangle().foregroundColor($0).frame(width: 8) }

                VStack(alignment: .leading) {
                    HStack {
                        if let owner = model.repository?.repoOwner, let slug = model.repository?.repoSlug {
                            Text("\(owner)/\(slug)")
                                .font(.headline)
                                .foregroundColor(Color(.label))
                        }

                        Spacer()

                        model.buildNumber.flatMap { Text("#\($0)") }
                            .font(.subheadline)
                            .foregroundColor(Color(.secondaryLabel))
                    }

                    Divider()

                    if let branch = model.branch {
                        if let target = model.pullRequestTargetBranch {
                            Text("\(branch) > \(target)")
                                .font(.subheadline)
                                .foregroundColor(Color(.label))
                        } else {
                            Text(branch)
                                .font(.subheadline)
                                .foregroundColor(Color(.label))
                        }
                    }

                    model.triggeredWorkflow.flatMap(Text.init)
                        .font(.subheadline)
                        .foregroundColor(Color(.label))

                    Spacer()
                        .frame(height: 12)

                    HStack {
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(Color(.label))

                            model.startedOnWorkerAt.flatMap(Formatter.iso8601.date(from:))
                                .flatMap(Formatter.yMdHms.string(from:))
                                .flatMap(Text.init)
                                .font(.footnote)
                                .foregroundColor(Color(.label))
                        }

                        Spacer()

                        if let duration = model.duration {
                            HStack {
                                Image(systemName: "clock")
                                    .foregroundColor(Color(.label))

                                Formatter.hhmmss.string(from: duration)
                                    .flatMap(Text.init)
                                    .font(.footnote)
                                    .foregroundColor(Color(.label))
                            }
                        }
                    }
                }
                .padding()
            }
        }
    }

    let store: Store<BuildsState, BuildsAction>

    @ViewBuilder
    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                ScrollView {
                    LazyVStack {
                        ForEach(Array(viewStore.models.enumerated()), id: \.offset) { offset, model in
                            NavigationLink(
                                destination: IfLetStore(
                                    store.scope(state: { $0.selection?.value }, action: BuildsAction.build),
                                    then: BuildView.init(store:)
                                ),
                                tag: offset,
                                selection: viewStore.binding(
                                    get: { $0.selection?.id },
                                    send: BuildsAction.setNavigation(selection:)
                                ),
                                label: {
                                    ItemView(model: model)
                                        .background(Color(.secondarySystemBackground))
                                        .cornerRadius(8)
                                        .padding([.leading, .trailing])
                                        .padding([.top, .bottom], 6)
                                        .onAppear {
                                            if offset == viewStore.models.count - 1 {
                                                viewStore.send(.loadMore)
                                            }
                                        }
                                })
                        }
                    }
                }
                .onAppear {
                    viewStore.send(.load)
                }
                .navigationTitle("Builds")
                .navigationBarItems(
                    leading: Button(
                        action: { viewStore.send(.gearTapped) },
                        label: { Image(systemName: "gear") }
                    ),
                    trailing: Button(
                        action: { viewStore.send(.load) },
                        label: { Image(systemName: "arrow.2.circlepath") }
                    )
                )
            }
        }
    }

}
