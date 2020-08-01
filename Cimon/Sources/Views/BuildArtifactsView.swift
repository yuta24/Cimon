//
//  BuildArtifactsView.swift
//  Cimon
//
//  Created by Yu Tawata on 2020/07/31.
//

import SwiftUI
import Combine
import ComposableArchitecture
import Domain
import Mocha
import BitriseAPI
import Core

struct BuildArtifactsState: Equatable {
    var model: BuildListAllResponseItemModel
    var models: [ArtifactListElementResponseModel]

    var alert: AlertState<BuildArtifactsAction>?
}

enum BuildArtifactsAction: Equatable {
    case load

    case loadResponse(Result<ArtifactListResponseModel, Client.Failure>)

    case alertDismissed
}

class BuildArtifactsEnvironment {
    let client: Client

    init(client: Client) {
        self.client = client
    }
}

let buildArtifactsReducer: Reducer<BuildArtifactsState, BuildArtifactsAction, BuildArtifactsEnvironment> = Reducer.combine(
    Reducer { state, action, environment in

        switch action {

        case .load:
            return environment.client.publisher(for: Endpoint.BuildArtifact.GetListOfAllBuildArtifacts(appSlug: state.model.repository!.slug!, buildSlug: state.model.slug!, next: .none, limit: 30))
                .catchToEffect()
                .map(BuildArtifactsAction.loadResponse)
                .receive(on: DispatchQueue.main)
                .eraseToEffect()

        case .loadResponse(let result):
            switch result {
            case .success(let response):
                state.models = response.data ?? []
                state.alert = .none
            case .failure(let error):
                debugPrint(error)
                state.alert = .init(title: "Error", message: error.localizedDescription)
            }

            return .none

        case .alertDismissed:
            state.alert = .none

            return .none

        }

    }
)

struct BuildArtifactsView: View {

    let store: Store<BuildArtifactsState, BuildArtifactsAction>

    @ViewBuilder
    var body: some View {
        WithViewStore(store) { viewStore in
            List {
                ForEach(Array(viewStore.models.enumerated()), id: \.offset) { _, model in
                    VStack(alignment: .leading) {
                        model.title.flatMap(Text.init)
                            .font(.subheadline)
                    }
                }
            }
            .onAppear {
                viewStore.send(.load)
            }
            .navigationTitle("Apps & Artifacts")
        }
        .alert(store.scope(state: \.alert), dismiss: .alertDismissed)
    }

}
