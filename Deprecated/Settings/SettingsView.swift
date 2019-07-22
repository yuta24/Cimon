//
//  SettingsView.swift
//  App
//
//  Created by tawata-yu on 2019/07/09.
//

import SwiftUI
import Combine
import Shared
import Domain

struct SettingsView: View {
    @EnvironmentObject var settings: Settings

    var body: some View {
        List {
            Section(header: Text("API Tokens")) {
                NavigationLink(
                    "Travis CI",
                    destination: SettingsDetailView(ci: .travisci)
                        .environmentObject(settings)
                        .background(UIColor.systemBackground.ext.color)
                        .navigationBarTitle("Travis CI"))
                NavigationLink(
                    "Circle CI",
                    destination: SettingsDetailView(ci: .circleci)
                        .environmentObject(settings)
                        .background(UIColor.systemBackground.ext.color)
                        .navigationBarTitle("Circle CI"))
                NavigationLink(
                    "Bitrise",
                    destination: SettingsDetailView(ci: .bitrise)
                        .environmentObject(settings)
                        .background(UIColor.systemBackground.ext.color)
                        .navigationBarTitle("Bitrise"))
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
        .navigationBarTitle("Settings")
    }
}
