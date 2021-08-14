//
//  Theme.swift
//  Habits
//
//  Created by Adam Fisher on 21/05/2021.
//

import SwiftUI

struct Theme {
    var themeName: String
    var backgroundColor: Color
    var absenceColor: Color
    var foregroundColor: Color

    static let themePreview: Theme =
        Theme(
            themeName: "color1",
            backgroundColor: Color("color1"),
            absenceColor: Color("color1_a"),
            foregroundColor: Color("color1_f")
        )
}

var themes: [Theme] = [
    Theme(
        themeName: "color1",
        backgroundColor: Color("color1"),
        absenceColor: Color("color1_a"),
        foregroundColor: Color("color1_f")
    ),
    Theme(
        themeName: "color2",
        backgroundColor: Color("color2"),
        absenceColor: Color("color2_a"),
        foregroundColor: Color("color2_f")
    ),
    Theme(
        themeName: "color3",
        backgroundColor: Color("color3"),
        absenceColor: Color("color3_a"),
        foregroundColor: Color("color3_f")
    ),
    Theme(
        themeName: "color4",
        backgroundColor: Color("color4"),
        absenceColor: Color("color4_a"),
        foregroundColor: Color("color4_f")
    ),
    Theme(
        themeName: "color5",
        backgroundColor: Color("color5"),
        absenceColor: Color("color5_a"),
        foregroundColor: Color("color5_f")
    ),
    Theme(
        themeName: "color6",
        backgroundColor: Color("color6"),
        absenceColor: Color("color6_a"),
        foregroundColor: Color("color6_f")
    ),
    Theme(
        themeName: "color7",
        backgroundColor: Color("color7"),
        absenceColor: Color("color7_a"),
        foregroundColor: Color("color7_f")
    ),
    Theme(
        themeName: "color8",
        backgroundColor: Color("color8"),
        absenceColor: Color("color8_a"),
        foregroundColor: Color("color8_f")
    ),
    Theme(
        themeName: "color9",
        backgroundColor: Color("color9"),
        absenceColor: Color("color9_a"),
        foregroundColor: Color("color9_f")
    ),
    Theme(
        themeName: "color10",
        backgroundColor: Color("color10"),
        absenceColor: Color("color10_a"),
        foregroundColor: Color("color10_f")
    ),
]
