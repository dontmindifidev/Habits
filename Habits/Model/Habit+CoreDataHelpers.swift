//
//  Habit+CoreDataHelpers.swift
//  Habits
//
//  Created by Adam Fisher on 19/05/2021.
//

import SwiftUI

extension Habit {
    var habitName: String {
        name ?? ""
    }

    var theme: Theme {
        themes.first(where: {$0.themeName == colorName }) ?? Theme(themeName: "unknown", backgroundColor: Color("Background"), absenceColor: Color("Background"), foregroundColor: Color("Background"))
    }

    var completed: Bool {
        value == maxValue
    }

    var color: Color {
        if let colorName = colorName {
            return Color(colorName)
        }
        return Color.red
    }

    var altColor: Color {
        if let colorName = colorName {
            return Color("\(colorName)_a")
        }
        return Color.red
    }

    static var preview: Habit {
        let dataController = DataController(inMemory: true)
        let habit = Habit(context: dataController.container.viewContext)
        habit.id = UUID()
        habit.name = "Example"
        habit.maxValue = 7
        return habit
    }
}
