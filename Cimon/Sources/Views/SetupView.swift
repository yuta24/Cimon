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
    var loadAppsState: LoadAppsState?

    var alert: AlertState<SetupAction>?
    var isNavigationActive = false
}

enum TokenError: Error, Equatable {
    case empty
}

enum SetupAction: Equatable {
    case loadApps(LoadAppsAction)

    case save
    case saveResponse(Result<String, TokenError>)
    case picked(ContinuousIntegration)

    case tokenChanged(String)

    case setNavigation(isActive: Bool)
    case setNavigationIsActiveDelayCompleted

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
    loadAppsReducer.optional.pullback(
        state: \.loadAppsState,
        action: /SetupAction.loadApps,
        environment: {
            LoadAppsEnvironment(client: $0.bitriseClient)
        }
    ),
    Reducer { state, action, _ in

        switch action {

        case .loadApps:

            return .none

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

        case .setNavigation(true):
            state.isNavigationActive = true

            return Effect(value: .setNavigationIsActiveDelayCompleted)
                .delay(for: 1, scheduler: DispatchQueue.main)
                .eraseToEffect()

        case .setNavigation(false):
            state.isNavigationActive = false
            state.loadAppsState = .none

            return .none

        case .setNavigationIsActiveDelayCompleted:
            state.loadAppsState = .init(token: state.token, models: [], paging: .none, alert: .none)

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
                VStack {
                    NavigationLink(
                        destination: IfLetStore(
                            store.scope(state: \.loadAppsState, action: SetupAction.loadApps),
                            then: LoadAppsView.init(store:)
                        ),
                        isActive: viewStore.binding(
                            get: { $0.isNavigationActive },
                            send: SetupAction.setNavigation(isActive:)
                        ),
                        label: {
                            EmptyView()
                        }
                    )

                    Text("Setup")
                        .font(.title)

                    VStack {
                        WithViewStore(self.store.scope(state: { $0.ci }, action: SetupAction.picked)) { viewStore in
                            Picker("Service", selection: viewStore.binding(send: { $0 })) {
                                ForEach(ContinuousIntegration.allCases, id: \.self) { service in
                                    Text(service.description)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }

                        Divider()

                        TextField(
                            "Input access token",
                            text: viewStore.binding(
                                get: { $0.token },
                                send: SetupAction.tokenChanged)
                        )
                    }
                    .padding(8)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
                    .padding()

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
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
                        .padding()
                }
                .navigationBarHidden(true)
            }
        }
        .alert(store.scope(state: \.alert), dismiss: .alertDismissed)
    }

}
