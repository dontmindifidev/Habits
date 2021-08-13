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

    @FetchRequest(entity: Habit.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Habit.priority, ascending: true),
        NSSortDescriptor(keyPath: \Habit.creationDate, ascending: false)
    ]) var habits: FetchedResults<Habit>

    @State private var itemEditing: Habit?

    var isEditing: Bool {
        itemEditing != nil
    }

    var body: some View {
            ZStack {
                Color("Background")
                    .edgesIgnoringSafeArea(.all)

                ScrollView {
                    VStack(spacing: 12) {
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 32)
                            .padding(.vertical, 30)
                            .zIndex(99)

                        ForEach(habits) { habit in
                            HabitItem(habit: habit, itemEditing: $itemEditing)
                                .disabled(itemEditing != habit && itemEditing != nil)
                                .opacity(itemEditing != habit && itemEditing != nil ? 0.1 : 1)
                                .transition(
                                    AnyTransition.asymmetric(
                                        insertion: .move(edge: .top).combined(with: .scale),
                                        removal: .move(edge: .leading).combined(with: .opacity))
                                    )
                        }
                    }
                    .padding(.horizontal)
                }
                .onTapGesture {
                    endEditing()
                }

                VStack {
                    Spacer()
                    HStack {
                        Spacer()

                        ZStack {
                            Button {
                                guard let maxValue = itemEditing?.maxValue else { return }

                                if maxValue < 20 {
                                    itemEditing?.maxValue += 1
                                }
                            } label: {
                                Image(systemName: "plus")
                                    .foregroundColor(.primary)
                                    .font(.system(size: 22))
                                    .frame(width: 60, height: 60)
                                    .background(itemEditing?.theme.backgroundColor ?? Color("Background"))
                                    .clipShape(Circle())
                                    .offset(x: itemEditing == nil ? 0 : 20, y: itemEditing == nil ? 0 : -60)
                                    .shadow(color: .black.opacity(0.08), radius: 4)
                                    .opacity(itemEditing == nil ? 0 : 1)
                                    .scaleEffect(itemEditing == nil ? 0.3 : 1)
                                    .rotationEffect(Angle(degrees: isEditing ? 0 : -90))
                            }

                            Button {
                                guard let maxValue = itemEditing?.maxValue else { return }
                                guard let value = itemEditing?.value else { return }

                                if maxValue > max(value, 1) {
                                    itemEditing?.maxValue -= 1
                                }
                            } label: {
                                Image(systemName: "minus")
                                    .foregroundColor(.primary)
                                    .font(.system(size: 22))
                                    .frame(width: 50, height: 50)
                                    .background(itemEditing?.theme.backgroundColor ?? Color("Background"))
                                    .clipShape(Circle())
                                    .padding(10)
                                    .offset(x: itemEditing == nil ? 0 : -40, y: itemEditing == nil ? 0 : -40)
                                    .shadow(color: .black.opacity(0.08), radius: 4)
                                    .opacity(itemEditing == nil ? 0 : 1)
                                    .scaleEffect(itemEditing == nil ? 0.3 : 1)
                                    .rotationEffect(Angle(degrees: isEditing ? 0 : -90))
                            }

                            Button {
                                withAnimation(.spring(response: 0.2, dampingFraction: 0.7)) {
                                    itemEditing?.colorName = themes.randomElement()?.themeName
                                }
                            } label: {
                                Image(systemName: "paintbrush.fill")
                                    .foregroundColor(.primary)
                                    .font(.system(size: 22))
                                    .frame(width: 60, height: 60)
                                    .background(itemEditing?.theme.backgroundColor ?? Color("Background"))
                                    .clipShape(Circle())
                                    .offset(x: itemEditing == nil ? 0 : -60, y: itemEditing == nil ? 0 : 20)
                                    .shadow(color: .black.opacity(0.08), radius: 4)
                                    .scaleEffect(itemEditing == nil ? 0.3 : 1)
                                    .rotationEffect(Angle(degrees: isEditing ? 0 : -90))
                            }

                            Button {
                                if isEditing {
                                    endEditing()
                                } else {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
                                        addNewItem()
                                    }
                                }
                            } label: {
                                Image(systemName: "plus")
                                    .foregroundColor(.primary)
                                    .font(.system(size: 36))
                                    .padding()
                                    .background(Circle().foregroundColor(Color("color9")).clipped())
                                    .shadow(color: .black.opacity(0.08), radius: 4)
                                    .scaleEffect(itemEditing == nil ? 1 : 0.7)
                                    .rotationEffect(Angle(degrees: itemEditing == nil ? 0 : 45))
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding([.horizontal, .bottom])
                }
            }
    }

    func addNewItem() {
        let newHabit = Habit(context: viewContext)
        newHabit.id = UUID()
        newHabit.creationDate = Date()
        newHabit.priority = 0
        newHabit.name = ""
        newHabit.maxValue = 3
        newHabit.colorName = themes[Int.random(in: 0..<themes.count)].themeName
        itemEditing = newHabit
    }

    func endEditing() {
        if itemEditing != nil {
            withAnimation(
                .spring(response: 0.7, dampingFraction: 1)) {
                itemEditing = nil
                Haptics.hapticTap(.soft)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
