//
//  CimonApp.swift
//  Cimon
//
//  Created by Yu Tawata on 2020/07/07.
//

import SwiftUI
import Combine
import ComposableArchitecture
import KeychainAccess
import Mocha
import Domain
import BitriseAPI
import Core

struct AppState: Equatable {
    var account: Account

    var sceneState: SceneState
}

enum AppAction {
    case prepare

    case scene(SceneAction)
}

class AppEnvironment {
    let session: URLSession
    let appInstalledStore: AppInstalledStore
    let bitriseTokenStore: BitriseTokenStore
    let bitriseClient: Client

    init(
        session: URLSession,
        appInstalledStore: AppInstalledStore,
        bitriseTokenStore: BitriseTokenStore
    ) {
        self.session = session
        self.appInstalledStore = appInstalledStore
        self.bitriseTokenStore = bitriseTokenStore
        self.bitriseClient = Client({
            let network = Network(session: session)
            network.interceptors.append(AuthorizationInterceptor(kindProvider: { bitriseTokenStore.load().flatMap({ .customize(prefix: .none, token: $0.value) }) }))
            return network
            }(),
            with: URL(string: "https://api.bitrise.io/v0.1")!
        )
    }
}

let appReducer: Reducer<AppState, AppAction, AppEnvironment> = Reducer.combine(
    sceneReducer.pullback(
        state: \.sceneState,
        action: /AppAction.scene,
        environment: {
            SceneEnvironment(
                session: $0.session,
                bitriseTokenStore: $0.bitriseTokenStore,
                bitriseClient: $0.bitriseClient
            )
        }
    ),
    Reducer { state, action, environment in

        switch action {

        case .prepare:
            let appInstalled = environment.appInstalledStore.load()
            if appInstalled {
                state.account.bitrise = environment.bitriseTokenStore.load()
            } else {
                environment.appInstalledStore.save(true)
                environment.bitriseTokenStore.remove()
            }

            if !state.account.bitrise.isNil {
                state.sceneState.setupState = .none
                state.sceneState.mainState = .init(buildsState: .init(models: [], paging: .none, alert: .none))
            }

            return .none

        case .scene(.setup(.saveResponse(.success(let value)))):
            let token = BitriseToken(token: value)
            state.account.bitrise = token
            environment.bitriseTokenStore.save(token)

            return .none

        case .scene(.main(.account(.reset))):
            state.account.bitrise = .none
            state.sceneState = .init(setupState: .init(), mainState: .none)

            environment.bitriseTokenStore.remove()

            return .none

        case .scene:
            return .none

        }

    }
)

@main
struct CimonApp: SwiftUI.App {

    @UIApplicationDelegateAdaptor(ApplicationDelegateAdaptor.self)
    private var appDelegate // swiftlint:disable:this weak_delegate

    @Environment(\.scenePhase)
    private var scenePhase

    let store = Store<AppState, AppAction>(
        initialState: .init(
            account: .init(),
            sceneState: .init(setupState: .init(), mainState: .none)
        ),
        reducer: appReducer.debug(),
        environment: .init(
            session: .shared,
            appInstalledStore: DefaultAppInstalledStore(userDefaults: .standard),
            bitriseTokenStore: DefaultBitriseTokenStore(keychain: Keychain(service: "cimon")))
    )

    var body: some Scene {
        WindowGroup {
            WithViewStore(store) { viewStore in
                CimonScene(store: store.scope(state: \.sceneState, action: AppAction.scene))
                    .onAppear {
                        viewStore.send(.prepare)
                    }
            }
        }
    }

}
