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

    var alert: AlertState<BuildsAction>?
}

enum BuildsAction: Equatable {
    case load
    case loadMore

    case loadResponse(Result<BuildListAllResponseModel, Client.Failure>)
    case loadMoreResponse(Result<BuildListAllResponseModel, Client.Failure>)

    case gearTapped
    case buildSelected(BuildListAllResponseItemModel)
    case alertDismissed
}

class BuildsEnvironment {
    let client: Client

    init(client: Client) {
        self.client = client
    }
}

let buildsReducer: Reducer<BuildsState, BuildsAction, BuildsEnvironment> = Reducer.combine(
    Reducer { state, action, environment in

        switch action {

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

        case .gearTapped:

            return .none

        case .buildSelected:

            return .none

        case .alertDismissed:
            state.alert = .none

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
                                .bold()
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
                        } else {
                            Text(branch)
                                .font(.subheadline)
                        }
                    }

                    model.triggeredWorkflow.flatMap(Text.init)
                        .font(.subheadline)

                    Spacer().frame(height: 12)

                    HStack {
                        HStack {
                            Image(systemName: "calendar")

                            model.startedOnWorkerAt.flatMap(Formatter.iso8601.date(from:))
                                .flatMap(Formatter.yMdHms.string(from:))
                                .flatMap(Text.init)
                                .font(.footnote)
                        }

                        Spacer()

                        if let duration = model.duration {
                            HStack {
                                Image(systemName: "clock")

                                Formatter.hhmmss.string(from: duration)
                                    .flatMap(Text.init)
                                    .font(.footnote)
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
                            ItemView(model: model)
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(8)
                                .padding([.leading, .trailing])
                                .padding([.top, .bottom], 6)
                                .onTapGesture {
                                    viewStore.send(.buildSelected(model))
                                }
                                .onAppear {
                                    if offset == viewStore.models.count - 1 {
                                        viewStore.send(.loadMore)
                                    }
                                }
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
