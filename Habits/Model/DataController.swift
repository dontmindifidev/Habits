//
//  DataController.swift
//  Habits
//
//  Created by Adam Fisher on 19/05/2021.
//

import CoreData
import Foundation

class DataController: ObservableObject {
    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Habits")

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(string: "/dev/null")
        }

        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Error loading store: \(error.localizedDescription)")
            }
        }
    }

    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }

    func delete(_ object: NSManagedObject) {
        container.viewContext.delete(object)
    }

    func createDataOnFirstLaunch() {
        if UserDefaults.standard.bool(forKey: "previouslyLaunched") == false {
            createDefaultHabits()
            UserDefaults.standard.set(true, forKey: "previouslyLaunched")
        }
    }

    private func createDefaultHabits() {
        let habit1 = Habit(context: container.viewContext)
        habit1.id = UUID()
        habit1.name = "5k Run"
        habit1.colorName = "color1"
        habit1.maxValue = 3
        habit1.value = 2

        let habit2 = Habit(context: container.viewContext)
        habit2.id = UUID()
        habit2.name = "Read"
        habit2.colorName = "color2"
        habit2.maxValue = 5
        habit2.value = 3

        let habit3 = Habit(context: container.viewContext)
        habit3.id = UUID()
        habit3.name = "Meditate"
        habit3.colorName = "color3"
        habit3.maxValue = 4
        habit3.value = 2

        let habit4 = Habit(context: container.viewContext)
        habit4.id = UUID()
        habit4.name = "Wake up at 6am"
        habit4.colorName = "color4"
        habit4.maxValue = 5
        habit4.value = 1

        let habit5 = Habit(context: container.viewContext)
        habit5.id = UUID()
        habit5.name = "Study"
        habit5.colorName = "color5"
        habit5.maxValue = 4
        habit5.value = 3

        let habit6 = Habit(context: container.viewContext)
        habit6.id = UUID()
        habit6.name = "Set Goals"
        habit6.colorName = "color6"
        habit6.maxValue = 2
        habit6.value = 2

        save()
    }
}
