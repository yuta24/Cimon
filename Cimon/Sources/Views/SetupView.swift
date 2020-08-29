//
//  SetupView.swift
//  Cimon
//
//  Created by Yu Tawata on 2020/07/11.
//

import SwiftUI
import Combine
import ComposableArchitecture
import Domain
import Mocha
import BitriseAPI
import Core

struct SetupState: Equatable {
    var token = ""
    var ci: ContinuousIntegration = .bitrise

    var alert: AlertState<SetupAction>?
    var isNavigationActive = false
}

enum TokenError: Error, Equatable {
    case empty
}

enum SetupAction: Equatable {
    case save
    case saveResponse(Result<String, TokenError>)
    case picked(ContinuousIntegration)

    case tokenChanged(String)

    case alertDismissed
}

class SetupEnvironment {
    let bitriseTokenStore: BitriseTokenStore
    let bitriseClient: Client

    init(bitriseTokenStore: BitriseTokenStore, bitriseClient: Client) {
        self.bitriseTokenStore = bitriseTokenStore
        self.bitriseClient = bitriseClient
    }
}

let setupReducer: Reducer<SetupState, SetupAction, SetupEnvironment> = Reducer.combine(
    Reducer { state, action, _ in

        switch action {

        case .save:
            if !state.token.isEmpty {
                return .init(value: .saveResponse(.success(state.token)))
            } else {
                return .init(value: .saveResponse(.failure(.empty)))
            }

        case .saveResponse(.success):
            state.alert = .none
            state.isNavigationActive = true

            return .none

        case .saveResponse(.failure(let error)):
            state.alert = .init(title: "Error", message: "The access token is empty.", dismissButton: .default("OK"))

            return .none

        case .picked(let ci):
            state.ci = ci

            return .none

        case .tokenChanged(let token):
            state.token = token

            return .none

        case .alertDismissed:
            state.alert = .none

            return .none

        }

    }
)

struct SetupView: View {

    let store: Store<SetupState, SetupAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                VStack(spacing: 16) {
                    Text("Bitrise")
                        .font(.title)

                    VStack {
                        TextField(
                            "Input access token",
                            text: viewStore.binding(
                                get: { $0.token },
                                send: SetupAction.tokenChanged)
                        )
                    }
                    .padding(8)
                    .background(Color(.tertiarySystemBackground))
                    .cornerRadius(8)

                    Button(
                        action: { viewStore.send(.save) },
                        label: {
                            HStack {
                                Spacer()
                                Text("Save")
                                Spacer()
                            }
                            .padding(8)
                        })
                        .background(Color(.tertiarySystemBackground))
                        .cornerRadius(8)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .navigationBarHidden(true)
            }
        }
        .alert(store.scope(state: \.alert), dismiss: .alertDismissed)
    }

}
