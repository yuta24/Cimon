//
//  AccountView.swift
//  Cimon
//
//  Created by Yu Tawata on 2020/07/10.
//

import SwiftUI
import ComposableArchitecture
import FetchImage
import Mocha
import Common
import Domain
import BitriseAPI
import Core

struct AccountState: Equatable {
    var bitriseProfile: UserProfileDataModel?
    var bitriseAppList: [AppResponseItemModel]

    var alert: AlertState<AccountAction>?
    var actionSheet: ActionSheetState<AccountAction>?
}

enum AccountAction: Equatable {
    struct Load: Equatable {
        var userProfile: UserProfileRespModel
        var appList: AppListResponseModel
    }

    case load
    case reset

    case loadResponse(Result<Load, Client.Failure>)

    case resetTapped
    case cancelTapped
    case actionSheetDismissed
    case alertDismissed
}

class AccountEnvironment {
    let client: Client

    init(client: Client) {
        self.client = client
    }
}

let accountReducer: Reducer<AccountState, AccountAction, AccountEnvironment> = Reducer.combine(
    .init { state, action, environment in

        switch action {

        case .load:
            return environment.client.publisher(for: Endpoint.MeRequest())
                .zip(environment.client.publisher(for: Endpoint.AppsRequest(sortBy: .lastBuildAt, next: .none, limit: 10)))
                .map(AccountAction.Load.init)
                .catchToEffect()
                .map(AccountAction.loadResponse)
                .receive(on: DispatchQueue.main)
                .eraseToEffect()

        case .reset:
            return .none

        case .loadResponse(let result):
            switch result {
            case .success(let load):
                state.bitriseProfile = load.userProfile.data
                state.bitriseAppList = load.appList.data ?? []
                state.alert = .none
            case .failure(let error):
                state.alert = .init(title: "Error", message: error.localizedDescription)
            }

            return .none

        case .resetTapped:
            state.actionSheet = .init(
                title: "Delete all data?",
                message: "Are you sure you want to delete all data?",
                buttons: [
                    .destructive("OK", send: .reset),
                    .cancel(send: .cancelTapped)
                ])

            return .none

        case .cancelTapped:
            state.actionSheet = .none

            return .none

        case .actionSheetDismissed:
            state.actionSheet = .none

            return .none

        case .alertDismissed:
            state.alert = .none

            return .none

        }

    }
)

struct AccountView: View {

    struct BitriseAppView: View {

        let app: AppResponseItemModel

        var body: some View {
            HStack {
                app.avatarUrl.flatMap(URL.init(string:))
                    .flatMap { FetchImage(url: $0) }
                    .flatMap { ImageView(image: $0) }
                    .frame(width: 24, height: 24)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                        .stroke(lineWidth: 1)
                        .foregroundColor(Color(.lightGray))
                    )

                app.title.flatMap(Text.init)
                    .font(.body)
            }
        }

    }

    let store: Store<AccountState, AccountAction>

    @Environment(\.presentationMode)
    private var presentationMode: Binding<PresentationMode>

    @State
    private var isSheetPresented = false

    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                ScrollView {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Bitrise")
                                .font(.title2)
                                .bold()

                            Spacer()
                        }

                        if let profile = viewStore.bitriseProfile {
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Text("Profile")
                                        .font(.title3)
                                        .bold()

                                    Spacer()
                                }

                                profile.username.flatMap(Text.init)
                                    .font(.body)
                            }
                            .padding()
                            .background(Color(.tertiarySystemBackground))
                            .cornerRadius(8)
                            .padding([.top])
                        }

                        if !viewStore.bitriseAppList.isEmpty {
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Text("Recent build apps")
                                        .font(.title3)
                                        .bold()

                                    Spacer()
                                }

                                ForEach(Array(viewStore.bitriseAppList.enumerated()), id: \.offset) { _, app in
                                    BitriseAppView(app: app)
                                }
                            }
                            .padding()
                            .background(Color(.tertiarySystemBackground))
                            .cornerRadius(8)
                            .padding([.top])
                        }
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
                    .padding()

                    Button(
                        action: { viewStore.send(.resetTapped) },
                        label: {
                            HStack {
                                Spacer()
                                Text("Reset")
                                    .foregroundColor(Color(.systemRed))
                                    .bold()
                                Spacer()
                            }
                        }
                    )
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                        .stroke(lineWidth: 2)
                        .foregroundColor(Color(.systemRed))
                    )
                    .padding()
                }
                .actionSheet(store.scope(state: { $0.actionSheet }), dismiss: .actionSheetDismissed)
                .onAppear {
                    viewStore.send(.load)
                }
                .navigationTitle("Account")
                .navigationBarItems(
                    leading: Button(
                        action: { presentationMode.wrappedValue.dismiss() },
                        label: { Image(systemName: "xmark") }
                    )
                )
            }
        }
    }

}
