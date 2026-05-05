import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context

    @Query(sort: \Habit.createdAt, order: .reverse)
    private var habits: [Habit]

    @State private var viewModel = HabitViewModel()
    @State private var showingAddHabit = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {

                Text("Mina vanor")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 16)

                List {
                    if habits.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "leaf")
                                .font(.largeTitle)
                                .foregroundStyle(.green)

                            Text("Inga vanor än")
                                .font(.headline)

                            Text("Lägg till din första vana för att börja bygga en streak.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 40)
                    } else {
                        ForEach(habits) { habit in
                            Button {
                                viewModel.toggleToday(for: habit, context: context)
                            } label: {
                                HStack(spacing: 12) {
                                    Image(systemName: habit.isCompletedToday ? "checkmark.circle.fill" : "circle")
                                        .font(.title2)
                                        .foregroundStyle(habit.isCompletedToday ? .green : .secondary)

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(habit.name)
                                            .font(.headline)

                                        Text("Streak: \(habit.currentStreak) dagar")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }

                                    Spacer()
                                }
                                .padding(.vertical, 4)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .listStyle(.plain)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddHabit = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddHabit) {
                AddHabitView(viewModel: viewModel)
            }
            .alert(
                "Något gick fel",
                isPresented: Binding(
                    get: { viewModel.errorMessage != nil },
                    set: { if !$0 { viewModel.errorMessage = nil } }
                ),
                presenting: viewModel.errorMessage
            ) { _ in
                Button("OK", role: .cancel) { }
            } message: { message in
                Text(message)
            }
        }
    }
}

#Preview {
    ContentView()
}
