//
//  LoadAppsView.swift
//  Cimon
//
//  Created by Yu Tawata on 2020/08/06.
//

import SwiftUI
import ComposableArchitecture
import Mocha
import Common
import Domain
import BitriseAPI
import Core

struct LoadAppsState: Equatable {
    var token: String
    var models: [AppResponseItemModel]
    var paging: PagingResponseModel?

    var alert: AlertState<LoadAppsAction>?
}

enum LoadAppsAction: Equatable {
    case load
    case loadMore

    case loadResponse(Result<AppListResponseModel, Client.Failure>)
    case loadMoreResponse(Result<AppListResponseModel, Client.Failure>)

    case save(String)
    case saveResponse(Result<String, TokenError>)

    case alertDismissed
}

class LoadAppsEnvironment {
    let client: Client

    init(client: Client) {
        self.client = client
    }
}

let loadAppsReducer: Reducer<LoadAppsState, LoadAppsAction, LoadAppsEnvironment> = Reducer.combine(
    Reducer { state, action, environment in

        switch action {

        case .load:
            return environment.client.publisher(for: Endpoint.Application.GetListOfApps(sortBy: .lastBuildAt, next: .none, limit: .none))
                .catchToEffect()
                .map(LoadAppsAction.loadResponse)
                .receive(on: DispatchQueue.main)
                .eraseToEffect()

        case .loadMore:
            return environment.client.publisher(for: Endpoint.Application.GetListOfApps(sortBy: .lastBuildAt, next: state.paging?.next, limit: .none))
                .catchToEffect()
                .map(LoadAppsAction.loadMoreResponse)
                .receive(on: DispatchQueue.main)
                .eraseToEffect()

        case .loadResponse(.success(let response)):
            state.models = response.data ?? []
            state.paging = response.paging
            state.alert = .none

            if state.paging?.next != .none {
                return .init(value: .loadMore)
            } else {
                return .none
            }

        case .loadResponse(.failure(let error)):
            state.alert = .init(title: "Error", message: error.localizedDescription)

            return .none

        case .loadMoreResponse(.success(let response)):
            state.models = response.data ?? []
            state.paging = response.paging
            state.alert = .none

            if state.paging?.next != .none {
                return .init(value: .loadMore)
            } else {
                return .none
            }

        case .loadMoreResponse(.failure(let error)):
            state.alert = .init(title: "Error", message: error.localizedDescription)

            return .none

        case .save(let value):
            if !value.isEmpty {
                return .init(value: .saveResponse(.success(value)))
            } else {
                return .init(value: .saveResponse(.failure(.empty)))
            }

        case .saveResponse(.success):
            state.alert = .none

            return .none

        case .saveResponse(.failure(let error)):
            state.alert = .init(title: "Error", message: "The access token is empty.", dismissButton: .default("OK"))

            return .none

        case .alertDismissed:
            state.alert = .none

            return .none

        }

    }
)

struct LoadAppsView: View {

    let store: Store<LoadAppsState, LoadAppsAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView {
                ForEach(Array(viewStore.models.enumerated()), id: \.offset) { _, model in
                    model.title.flatMap(Text.init)
                }
            }
            .onAppear {
                viewStore.send(.load)
            }
        }
        .alert(store.scope(state: \.alert), dismiss: .alertDismissed)
    }

}
