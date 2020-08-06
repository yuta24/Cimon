//
//  CimonScene.swift
//  Cimon
//
//  Created by Yu Tawata on 2020/07/07.
//

import SwiftUI
import ComposableArchitecture
import Mocha
import Common
import Domain
import BitriseAPI
import Core

struct SceneState: Equatable {
    var setupState: SetupState?
    var mainState: MainState?
}

enum SceneAction {
    case setup(SetupAction)
    case main(MainAction)
}

class SceneEnvironment {
    let session: URLSession
    let bitriseTokenStore: BitriseTokenStore
    let bitriseClient: Client

    init(
        session: URLSession,
        bitriseTokenStore: BitriseTokenStore,
        bitriseClient: Client
    ) {
        self.session = session
        self.bitriseTokenStore = bitriseTokenStore
        self.bitriseClient = bitriseClient
    }
}

let sceneReducer: Reducer<SceneState, SceneAction, SceneEnvironment> = Reducer.combine(
    setupReducer.optional.pullback(
        state: \.setupState,
        action: /SceneAction.setup,
        environment: { SetupEnvironment(bitriseTokenStore: $0.bitriseTokenStore) }
    ),
    mainReducer.optional.pullback(
        state: \.mainState,
        action: /SceneAction.main,
        environment: { MainEnvironment(session: $0.session, client: $0.bitriseClient) }
    ),
    Reducer { state, action, _ in

        switch action {

        case .setup(.saveResponse(.success)):
            state.setupState = .none
            state.mainState = .init(buildsState: .init(models: [], paging: .none, alert: .none))

            return .none

        case .setup:

            return .none

        case .main:

            return .none

        }

    }
)

struct CimonScene: View {

    let store: Store<SceneState, SceneAction>

    @ViewBuilder
    var body: some View {
        IfLetStore(
            store.scope(state: { $0.setupState }, action: SceneAction.setup),
            then: SetupView.init(store:)
        )

        IfLetStore(
            store.scope(state: { $0.mainState }, action: SceneAction.main),
            then: MainView.init(store:)
        )
    }

}
