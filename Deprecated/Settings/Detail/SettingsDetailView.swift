//
//  SettingsDetailView.swift
//  App
//
//  Created by Yu Tawata on 2019/07/12.
//

import Foundation
import SwiftUI
import Combine
import Shared
import Domain

struct SettingsDetailView: View {
    @EnvironmentObject var settings: Settings

    var ci: CI

    var body: some View {
        let binding = Binding<String>(
            getValue: { self.settings.state.tokens[self.ci]! },
            setValue: { self.settings.dispatch(.update(value: $0, for: self.ci)) })

        return VStack {
            Text("API Token")
            TextField("", text: binding)
                .multilineTextAlignment(.center)
                .truncationMode(.tail)
                .border(Asset.accent.color.ext.color)
        }
        .background(UIColor.gray.ext.color)
        .padding(.init(top: 0, leading: 24, bottom: 0, trailing: 24))
    }
}

struct BridgeTextField: UIViewRepresentable {
    func makeUIView(context: UIViewRepresentableContext<BridgeTextField>) -> UITextField {
        return UITextField()
    }

    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<BridgeTextField>) {
    }
}
