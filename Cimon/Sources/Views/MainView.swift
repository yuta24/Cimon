//
//  MainView.swift
//  Cimon
//
//  Created by Yu Tawata on 2020/07/12.
//

import SwiftUI
import ComposableArchitecture
import Mocha
import BitriseAPI
import Domain
import Core

enum MainSheet: Identifiable, Equatable {
    case account

    var id: Self { self }
}

struct MainState: Equatable {
    var buildsState: BuildsState
    var accountState: AccountState?

    var sheet: MainSheet? {
        if accountState != .none {
            return .account
        } else {
            return .none
        }
    }
}

enum MainAction: Equatable {
    case builds(BuildsAction)
    case account(AccountAction)

    case sheetDismissed
}

class MainEnvironment {
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

let mainReducer: Reducer<MainState, MainAction, MainEnvironment> = Reducer.combine(
    accountReducer.optional.pullback(
        state: \.accountState,
        action: /MainAction.account,
        environment: { AccountEnvironment(client: $0.client) }
    ),
    buildsReducer.pullback(
        state: \.buildsState,
        action: /MainAction.builds,
        environment: { BuildsEnvironment(session: $0.session, client: $0.client) }
    ),
    Reducer { state, action, _ in

        switch action {

        case .builds(.gearTapped):
            state.accountState = .init(bitriseProfile: .none, bitriseAppList: [], alert: .none, actionSheet: .none)

            return .none

        case .builds:

            return .none

        case .account:

            return .none

        case .sheetDismissed:
            state.accountState = .none

            return .none

        }

    }
)

struct MainView: View {

    let store: Store<MainState, MainAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            BuildsView(store: store.scope(state: \.buildsState, action: MainAction.builds))
                .sheet(item: viewStore.binding(get: { $0.sheet }, send: .sheetDismissed)) { sheet in
                    switch sheet {
                    case .account:
                        IfLetStore(
                            store.scope(state: \.accountState, action: MainAction.account),
                            then: AccountView.init(store:)
                        )
                    }
                }
        }
    }

}
