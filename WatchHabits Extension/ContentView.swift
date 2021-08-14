//
//  ContentView.swift
//  WatchHabits Extension
//
//  Created by Adam Fisher on 30/05/2021.
//

import SwiftUI

struct ContentView: View {

    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var dataController: DataController

    @FetchRequest(entity: Habit.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Habit.priority, ascending: true),
        NSSortDescriptor(keyPath: \Habit.creationDate, ascending: false)
    ]) var habits: FetchedResults<Habit>

    var body: some View {
        NavigationView {
            List {
                ForEach(habits) { habit in
                    HabitItem(habit: habit)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.2, dampingFraction: 0.8)) {
                                if habit.value < habit.maxValue {
                                    habit.value += 1
                                    dataController.save()
                                }
                            }
                        }
                }
                .listRowBackground(Color.clear)
            }
            .listStyle(EllipticalListStyle())
            .navigationTitle("Habitapp")
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
