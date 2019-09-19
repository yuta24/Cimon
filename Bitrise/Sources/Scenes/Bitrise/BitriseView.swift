//
//  BitriseView.swift
//  Bitrise
//
//  Created by Yu Tawata on 2019/09/20.
//

import SwiftUI
import BitriseAPI

public struct BitriseView: View {
    public struct State {
        var isLoading: Bool
        var next: String?
        var builds: [BuildListAllResponseItemModel]
    }

    public enum Action {
        case fetch
        case fetchNext
        case token(String?)
    }

    public var body: some View {
        Text("")
    }
}

public func bitriseReducer(state: inout BitriseView.State, action: BitriseView.Action) {
    switch action {
    case .fetch:
        guard !state.isLoading else {
            return
        }
        state.isLoading = true
    case .fetchNext:
    case .token(let token):
    }
}
