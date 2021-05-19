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

    var completed: Bool {
        value == maxValue
    }

    var color: Color {
        if let colorName = colorName {
            return Color(colorName)
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
