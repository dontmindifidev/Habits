//
//  HabitsApp.swift
//  Habits
//
//  Created by Adam Fisher on 19/05/2021.
//

import SwiftUI

@main
struct HabitsApp: App {

    @StateObject var dataController: DataController

    init() {
        let dataController = DataController()
        _dataController = StateObject(wrappedValue: dataController)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
                .onAppear {
                    dataController.createDataOnFirstLaunch()
                }
        }
    }
}
