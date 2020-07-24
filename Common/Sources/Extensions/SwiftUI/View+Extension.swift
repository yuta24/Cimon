//
//  View+Extension.swift
//  Common
//
//  Created by Yu Tawata on 2020/07/09.
//

import SwiftUI

extension View {
    public func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}
