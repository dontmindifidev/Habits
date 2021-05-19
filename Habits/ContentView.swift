//
//  ContentView.swift
//  Habits
//
//  Created by Adam Fisher on 19/05/2021.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var dataController: DataController

    @FetchRequest(entity: Habit.entity(), sortDescriptors: []) var habits: FetchedResults<Habit>

    @State private var showSheet = false

    var body: some View {
            ZStack {
                Color("Background").opacity(0.12)
                    .edgesIgnoringSafeArea(.all)

                ScrollView {
                    VStack(spacing: 10) {
                        Text("SIMPLE HABITS")
                            .font(.system(.largeTitle, design: .rounded)).bold()
                            .padding(.vertical, 30)

                        ForEach(habits) { habit in
                            HabitItem(habit: habit)
                        }
                    }
                    .padding(.horizontal)
                }

                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            withAnimation {
                                showSheet.toggle()
                            }
                        } label: {
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                                .font(.system(size: 50))
                                .padding()
                                .background(Color("Background"))
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.08), radius: 4)
                        }
                        .buttonStyle(ScaledButtonStyle())
                    }
                    .padding([.horizontal, .bottom])
                }
            }
            .sheet(isPresented: $showSheet) {
                AddHabitView()
                    .environment(\.managedObjectContext, viewContext)
                    .environmentObject(dataController)
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}