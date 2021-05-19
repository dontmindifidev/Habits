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
            GeometryReader { geo in
                Rectangle()
                    .foregroundColor(habit.color)
                    .frame(maxHeight: .infinity)
                    .frame(width: max(0, geo.size.width / CGFloat(habit.maxValue) * CGFloat(habit.value)))
            }

            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(habit.habitName)
                        .font(.system(.headline, design: .rounded).bold())
                    Text("\(habit.value)/\(habit.maxValue) completed")
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
            .padding(.horizontal)
        }
        .background(habit.color.opacity(0.2))
        .cornerRadius(10)
        .onTapGesture {
            if habit.value < habit.maxValue {
                withAnimation(.spring()) {
                    habit.value += 1
                    dataController.save()
                }
            }
        }
        .offset(x: dragOffset.width)
        .gesture(
            DragGesture()
                .onChanged { value in
                    dragOffset.width = value.translation.width
                }
                .onEnded { value in
                    if value.translation.width < -200 {
                        withAnimation(.easeOut) {
                            dataController.delete(habit)
                            dataController.save()
                        }
                    } else if value.translation.width > 200 {
                        habit.objectWillChange.send()
                        withAnimation {
                            habit.value = 0
                            dragOffset = .zero
                        }
                    } else {
                        withAnimation {
                            dragOffset = .zero
                        }
                    }
                }
        )
        .transition(.move(edge: .leading))
    }
}

struct HabitItem_Previews: PreviewProvider {
    static var previews: some View {
        HabitItem(habit: Habit.preview)
    }
}

