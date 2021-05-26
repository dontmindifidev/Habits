//
//  ButtonStyles.swift
//  Habits
//
//  Created by Adam Fisher on 19/05/2021.
//

import SwiftUI

struct ScaledButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
    }
}

struct SymbolButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {

        configuration.label
            .opacity(configuration.isPressed ? 0.8 : 1)

    }
}
