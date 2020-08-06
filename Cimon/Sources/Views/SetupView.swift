//
//  SetupView.swift
//  Cimon
//
//  Created by Yu Tawata on 2020/07/11.
//

import SwiftUI
import ComposableArchitecture
import BitriseAPI
import Domain
import Core

struct SetupState: Equatable {
    var ci: ContinuousIntegration = .bitrise

    var alert: AlertState<SetupAction>?
}

enum TokenError: Error, Equatable {
    case empty
}

enum SetupAction: Equatable {
    case save(String)
    case saveResponse(Result<String, TokenError>)
    case picked(ContinuousIntegration)

    case alertDismissed
}

class SetupEnvironment {
    let bitriseTokenStore: BitriseTokenStore

    init(bitriseTokenStore: BitriseTokenStore) {
        self.bitriseTokenStore = bitriseTokenStore
    }
}

let setupReducer: Reducer<SetupState, SetupAction, SetupEnvironment> = Reducer.combine(
    Reducer { state, action, _ in

        switch action {

        case .save(let value):
            if !value.isEmpty {
                return .init(value: .saveResponse(.success(value)))
            } else {
                return .init(value: .saveResponse(.failure(.empty)))
            }

        case .saveResponse(let result):
            switch result {
            case .success:
                state.alert = .none
            case .failure(let error):
                switch error {
                case .empty:
                    state.alert = .init(title: "Error", message: "The access token is empty.", dismissButton: .default("OK"))
                }
            }

            return .none

        case .picked(let ci):
            state.ci = ci

            return .none

        case .alertDismissed:
            state.alert = .none

            return .none

        }

    }
)

struct SetupView: View {
    let store: Store<SetupState, SetupAction>

    @State
    private var token: String = ""

    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                Form {
                    Section {
                        WithViewStore(self.store.scope(state: { $0.ci }, action: SetupAction.picked)) { viewStore in
                            Picker("Service", selection: viewStore.binding(send: { $0 })) {
                                ForEach(ContinuousIntegration.allCases, id: \.self) { service in
                                    Text(service.description)
                                }
                            }
                        }

                        TextField("Input Access token", text: $token)
                    }

                    Section {
                        Button(
                            action: { viewStore.send(.save(token)) },
                            label: { Text("Save") }
                        )
                    }
                }
                .navigationBarTitle("Setup")
            }
            .alert(store.scope(state: \.alert), dismiss: .alertDismissed)
        }
    }
}
