//
//  SignInView.swift
//  Cimon
//
//  Created by Yu Tawata on 2020/07/11.
//

import SwiftUI
import ComposableArchitecture
import BitriseAPI
import Domain
import Core

struct SignInState: Equatable {
    var alert: AlertState<SignInAction>?
}

enum TokenError: Error, Equatable {
    case empty
}

enum SignInAction: Equatable {
    case save(String)
    case saveResponse(Result<String, TokenError>)

    case alertDismissed
}

class SignInEnvironment {
    let bitriseTokenStore: BitriseTokenStore

    init(bitriseTokenStore: BitriseTokenStore) {
        self.bitriseTokenStore = bitriseTokenStore
    }
}

let signInReducer: Reducer<SignInState, SignInAction, SignInEnvironment> = Reducer.combine(
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

        case .alertDismissed:
            state.alert = .none

            return .none

        }

    }
)

struct SignInView: View {
    let store: Store<SignInState, SignInAction>

    @State
    private var token: String = ""

    var body: some View {
        WithViewStore(store) { viewStore in
            VStack(alignment: .leading) {
                Text("Bitrise")
                    .font(.title)
                    .bold()

                TextField("Access token", text: $token)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)

                HStack {
                    Spacer()

                    Button(
                        action: { viewStore.send(.save(token)) },
                        label: { Text("Save") }
                    )
                }
            }
            .offset(x: 0, y: -80)
            .alert(store.scope(state: \.alert), dismiss: .alertDismissed)
        }
        .padding()
    }
}
