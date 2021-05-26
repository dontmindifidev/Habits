//
//  HabitItem.swift
//  Habits
//
//  Created by Adam Fisher on 19/05/2021.
//

import SwiftUI

struct HabitItem: View {
    @EnvironmentObject var dataController: DataController

    @ObservedObject var habit: Habit
    @State private var dragOffset = CGSize.zero
    @State private var scaled = false

    var isEditing: Bool {
        itemEditing == habit
    }

    @Binding var itemEditing: Habit?

    @State private var habitName = ""

    var completed: Bool {
        withAnimation {
            habit.value == habit.maxValue
        }
    }

    var completedProgressWidth: CGFloat {
        CGFloat(habit.maxValue) * CGFloat(habit.value)
    }

    var body: some View {
        ZStack {
            HStack {
                Image(systemName: "arrow.counterclockwise")
                    .foregroundColor(.blue)
                    .scaleEffect(dragOffset.width > .zero ? 1 : 0.001)
                    .opacity(dragOffset.width > .zero ? 1 : 0.001)

                Spacer()

                Image(systemName: "trash")
                    .foregroundColor(.red)
                    .scaleEffect(dragOffset.width < .zero ? 1 : 0.001)
                    .opacity(dragOffset.width < .zero ? 1 : 0.001)
            }
            .font(.title.bold())
            .padding()
            .opacity(isEditing ? 0 : 1)

            ZStack {
                GeometryReader { geo in
                    Rectangle()
                        .foregroundColor(habit.theme.backgroundColor)
                        .frame(maxHeight: .infinity)
                        .frame(width: max(0, geo.size.width / CGFloat(habit.maxValue) * CGFloat(habit.value)))
                }

                if isEditing {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            TextField("Enter habit Name", text: $habitName)
                                .font(.system(.title3, design: .rounded).bold())
                                .accentColor(habit.theme.foregroundColor)
                                .onChange(of: habitName) { _ in
                                    habit.name = habitName
                                }

                            Text("\(habit.value) / \(habit.maxValue)")
                                .font(.system(.subheadline, design: .rounded).bold())
                                .textCase(.uppercase)

                        }
                        .padding(.bottom, 10)
                        .padding(.top, 30)
                    }
                    .foregroundColor(habit.theme.foregroundColor)
                    .padding(.horizontal)

                } else {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(habit.habitName)
                                .font(.system(.title3, design: .rounded).bold())
                            Text("\(habit.value) / \(habit.maxValue)")
                                .font(.system(.subheadline, design: .rounded).bold())
                                .textCase(.uppercase)
                        }
                        .padding(.bottom, 10)
                        .padding(.top, 30)

                        Spacer()
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title2)
                            .opacity(completed ? 1 : 0)
                            .scaleEffect(completed ? 1 : 10)
                    }
                    .foregroundColor(habit.theme.foregroundColor)
                    .padding(.horizontal)
                }
            }
            .background(habit.theme.absenceColor)
            .cornerRadius(12)
            .scaleEffect(scaled ? 0.96 : 1)
            .scaleEffect(isEditing ? 1.06 : 1)
            .offset(x: dragOffset.width)
            .onChange(of: isEditing) { _ in
                if isEditing == false {
                    updateHabit()
                }
            }
            .onTapGesture {
                if !isEditing {
                    if habit.value < habit.maxValue {
                        withAnimation(.spring(response: 0.2, dampingFraction: 0.8)) {
                            habit.value += 1
                            scaled = true
                            dataController.save()
                            if completed {
                                Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
                                    withAnimation(.spring(response: 0.1, dampingFraction: 0.2)) {
                                        scaled = false
                                    }
                                }
                                Haptics.hapticNotification(.success)
                            } else {
                                Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { _ in
                                    withAnimation(.spring(response: 0.2, dampingFraction: 0.4)) {
                                        scaled = false
                                    }
                                }
                                Haptics.hapticTap(.medium)
                            }
                        }
                    }
                }
            }
            .onLongPressGesture {
                if !isEditing {
                    habitName = habit.habitName
                    withAnimation {
                        itemEditing = habit
                        Haptics.hapticTap(.heavy)
                    }
                }
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if !isEditing {
                            dragOffset.width = value.translation.width
                        }
                    }
                    .onEnded { value in
                        if !isEditing {
                            if value.translation.width < -200 {
                                withAnimation(.easeOut) {
                                    dataController.delete(habit)
                                    dataController.save()
                                }
                            } else if value.translation.width > 200 {
                                habit.objectWillChange.send()
                                habit.value = 0
                                dataController.save()
                                Haptics.hapticNotification(.warning)
                                withAnimation {
                                    dragOffset = .zero
                                }
                            } else {
                                withAnimation {
                                    dragOffset = .zero
                                }
                            }
                        }
                    }
            )
        }
    }

    func updateHabit() {
        if habitName.isEmpty {
            dataController.delete(habit)
        } else {
            habit.name = habitName
        }
        dataController.save()
    }
}

struct HabitItem_Previews: PreviewProvider {
    static var previews: some View {
        HabitItem(habit: Habit.preview, itemEditing: .constant(Habit.preview))
    }
}

