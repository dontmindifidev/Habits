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
}
