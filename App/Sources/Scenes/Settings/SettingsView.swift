//
//  SettingsView.swift
//  App
//
//  Created by tawata-yu on 2019/07/09.
//

import SwiftUI
import Shared
import Combine

struct SettingsView: View {
    @ObjectBinding var settings: Settings

    private var isTravisCI: Binding<Bool> {
        return .init(
            getValue: { self.settings.state.isTravisCI },
            setValue: { self.settings.dispatch(.update(value: $0, path: \.isTravisCI)) })
    }
    private var isCircleCI: Binding<Bool> {
        return .init(
            getValue: { self.settings.state.isCircleCI },
            setValue: { self.settings.dispatch(.update(value: $0, path: \.isCircleCI)) })
    }
    private var isBitrise: Binding<Bool> {
        return .init(
            getValue: { self.settings.state.isBitrise },
            setValue: { self.settings.dispatch(.update(value: $0, path: \.isBitrise)) })
    }

    var body: some View {
        VStack {
            List {
                Section(header: Text("API Tokens")) {
                    Toggle("Travis CI", isOn: isTravisCI)
                    Toggle("Circle CI", isOn: isCircleCI)
                    Toggle("Bitrise", isOn: isBitrise)
                }
                Section {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("\(UIDevice.shortVersion)(\(UIDevice.buildVersion))")
                    }
                }
            }
            .listStyle(.grouped)
        }
        .navigationBarTitle("Settings")
    }
}
