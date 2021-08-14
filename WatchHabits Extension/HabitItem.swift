//
//  HabitItem.swift
//  WatchHabits Extension
//
//  Created by Adam Fisher on 30/05/2021.
//

import SwiftUI

struct HabitItem: View {
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

                VStack(spacing: 0) {
                    HStack {
                        Text(habit.habitName)
                            .foregroundColor(habit.theme.foregroundColor)
                            .bold()

                        Spacer()
                    }
                    HStack {
                        Text("\(habit.value)/\(habit.maxValue)")
                            .foregroundColor(habit.theme.foregroundColor)
                            .font(.footnote)

                        Spacer()
                    }

                }

                .padding(.horizontal, 8)
                .padding(.vertical, 4)
            }
            .frame(maxWidth: .infinity)
            .background(habit.theme.absenceColor)
            .cornerRadius(10)
        }
    }
}

struct HabitItem_Previews: PreviewProvider {
    static var previews: some View {
        HabitItem(habit: Habit.preview)
    }
}
