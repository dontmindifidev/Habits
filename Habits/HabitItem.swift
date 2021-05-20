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
            .padding(.horizontal)
        }
        .background(habit.color.opacity(0.2))
        .cornerRadius(12)
        .scaleEffect(scaled ? 0.97 : 1)
        .offset(x: dragOffset.width)
        .onTapGesture {
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
                        hapticNotification(.success)
                    } else {
                        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { _ in
                            withAnimation(.spring(response: 0.2, dampingFraction: 0.4)) {
                                scaled = false
                            }
                        }
                        hapticTap(.medium)
                    }
                }
            }
        }
        .onLongPressGesture {
            print("Long press")
        }
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
                            hapticNotification(.warning)
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

    func hapticTap(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }

    func hapticNotification(_ feedbackType: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(feedbackType)
    }
}

struct HabitItem_Previews: PreviewProvider {
    static var previews: some View {
        HabitItem(habit: Habit.preview)
    }
}

