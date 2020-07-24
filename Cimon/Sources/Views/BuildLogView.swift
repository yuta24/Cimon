//
//  BuildLogView.swift
//  Cimon
//
//  Created by Yu Tawata on 2020/07/20.
//

import SwiftUI
import Combine
import ComposableArchitecture
import Domain
import Mocha
import BitriseAPI
import Core

struct BuildLogState: Equatable {
    var model: BuildListAllResponseItemModel
    var log: BuildLogInfoResponseModel?

    var alert: AlertState<BuildLogAction>?
}

enum BuildLogAction: Equatable {
    case load

    case loadResponse(Result<BuildLogInfoResponseModel, Client.Failure>)

    case alertDismissed
}

class BuildLogEnvironment {
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

let buildLogReducer: Reducer<BuildLogState, BuildLogAction, BuildLogEnvironment> = Reducer.combine(
    Reducer { state, action, environment in

        switch action {

        case .load:
            return environment.client.publisher(for: Endpoint.BuildLogRequest(appSlug: state.model.repository!.slug!, buildSlug: state.model.slug!))
                .catchToEffect()
                .map(BuildLogAction.loadResponse)
                .receive(on: DispatchQueue.main)
                .eraseToEffect()

        case .loadResponse(let result):
            switch result {
            case .success(let response):
                state.log = response
                state.alert = .none
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

struct BuildLogView: View {

    let store: Store<BuildLogState, BuildLogAction>

    @ViewBuilder
    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView([.horizontal, .vertical]) {
                if let log = viewStore.log?.logChunks {
                    VStack(alignment: .leading) {
                        ForEach(Array(log.enumerated()), id: \.offset) { _, element in
                            Text(element.chunk)
                                .font(Font.footnote.monospacedDigit())
                                .padding([.leading, .trailing])
                        }
                    }
                }
            }
            .onAppear {
                viewStore.send(.load)
            }
            .navigationTitle("Logs")
        }
    }

}
