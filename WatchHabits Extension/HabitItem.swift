//
//  HabitItem.swift
//  WatchHabits Extension
//
//  Created by Adam Fisher on 30/05/2021.
//

import SwiftUI

struct HabitItem: View {
    @EnvironmentObject var dataController: DataController
    @ObservedObject var habit: Habit

    var body: some View {
        GeometryReader { geo in
            ZStack {
                HStack {
                    Rectangle()
                        .foregroundColor(habit.theme.backgroundColor)
                        .frame(maxHeight: .infinity)
                        .frame(width: max(0, geo.size.width / CGFloat(habit.maxValue) * CGFloat(habit.value)))

                    Spacer()
                        .frame(width: max(0, geo.size.width / CGFloat(habit.maxValue) * CGFloat(habit.maxValue - habit.value)))
                }

                HStack {
                    Text(habit.habitName)
                        .foregroundColor(habit.theme.foregroundColor)
                    Spacer()
                }
                .padding(.horizontal, 8)
            }
            .frame(maxWidth: .infinity)
            .background(habit.theme.absenceColor)
            .cornerRadius(10)
        }
        .onTapGesture {
            withAnimation(.spring(response: 0.2, dampingFraction: 0.8)) {
                if habit.value < habit.maxValue {
                    habit.value += 1
                    dataController.save()
                }
            }
        }
    }
}

struct HabitItem_Previews: PreviewProvider {
    static var previews: some View {
        HabitItem(habit: Habit.preview)
    }
}
