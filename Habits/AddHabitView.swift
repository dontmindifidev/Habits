//
//  AddHabitView.swift
//  Habits
//
//  Created by Adam Fisher on 19/05/2021.
//

import SwiftUI

struct AddHabitView: View {
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dataController: DataController

    @State private var habitName: String = ""
    @State private var maximumValue: Int = 3
    @State private var colorSelection = Int.random(in: 0 ..< colors.count)

    var currentColor: Color {
        Color(Self.colors[colorSelection])
    }

    static var colors = ["color1", "color2", "color3", "color4", "color5", "color6", "color7", "color8", "color9", "color10"]

    var body: some View {
        ZStack {
            currentColor.opacity(0.12)
                .edgesIgnoringSafeArea(.all)

            VStack(alignment: .leading, spacing: 20) {
                Text("New Habit")
                    .font(.system(.largeTitle, design: .rounded).bold())
                    .padding(.top, 40)

                Section {
                    TextField("Enter habit name", text: $habitName)
                }
                .font(.system(.largeTitle, design: .rounded).weight(.heavy))
                .foregroundColor(currentColor)

                Section {
                    HStack(spacing: 5) {
                        Text("\(maximumValue)")
                            .font(.system(.largeTitle, design: .rounded).bold())
                            .foregroundColor(currentColor)

                        Stepper("time\(maximumValue == 1 ? "" : "s") per week", value: $maximumValue, in: 1...20)
                            .font(.system(.title3, design: .rounded).bold())
                    }
                }

                Spacer()
                HStack {
                    Button {
                        colorSelection = Int.random(in: 0 ..< Self.colors.count)
                    } label: {
                        HStack {
                            Image(systemName: "shuffle")

                            Text("Colour")
                        }
                        .foregroundColor(currentColor)
                        .padding(.vertical, 20)
                        .padding(.horizontal, 30)
                        .clipShape(Capsule())
                    }

                    Spacer()
                    Button {
                        saveHabit()
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Create Habit")
                            .foregroundColor(.white)
                            .padding(.vertical, 20)
                            .padding(.horizontal, 30)
                            .background(currentColor)
                            .clipShape(Capsule())
                    }
                    .disabled(failedValidation)
                    .opacity(failedValidation ? 0.7 : 1)
                }
                .font(.system(.body, design: .rounded).bold())
            }
            .textFieldStyle(PlainTextFieldStyle())
            .accentColor(currentColor)
            .padding()
        }
    }

    var failedValidation: Bool {
        habitName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    func saveHabit() {
        let habit = Habit(context: viewContext)
        habit.id = UUID()
        habit.name = habitName
        habit.maxValue = Int16(maximumValue)
        habit.colorName = Self.colors[colorSelection]
        dataController.save()
    }
}


struct AddHabitView_Previews: PreviewProvider {
    static var previews: some View {
        AddHabitView()
    }
}
