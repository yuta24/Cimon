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
    var signInState: SignInState?
    var mainState: MainState?
}

enum SceneAction {
    case signIn(SignInAction)
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
    signInReducer.optional.pullback(
        state: \.signInState,
        action: /SceneAction.signIn,
        environment: { SignInEnvironment(bitriseTokenStore: $0.bitriseTokenStore) }
    ),
    mainReducer.optional.pullback(
        state: \.mainState,
        action: /SceneAction.main,
        environment: { MainEnvironment(session: $0.session, client: $0.bitriseClient) }
    ),
    Reducer { state, action, _ in

        switch action {

        case .signIn(.saveResponse(.success)):
            state.signInState = .none
            state.mainState = .init(buildsState: .init(models: [], paging: .none, alert: .none))

            return .none

        case .signIn:

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
            store.scope(state: { $0.signInState }, action: SceneAction.signIn),
            then: SignInView.init(store:)
        )

        IfLetStore(
            store.scope(state: { $0.mainState }, action: SceneAction.main),
            then: MainView.init(store:)
        )
    }

}
