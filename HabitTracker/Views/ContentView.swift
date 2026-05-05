import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context

    @Query private var habits: [Habit]

    @State private var viewModel = HabitViewModel()
    @State private var showingAddHabit = false

    var body: some View {
        NavigationStack {
            List {
                if habits.isEmpty {
                    ContentUnavailableView(
                        "Inga vanor än",
                        systemImage: "leaf",
                        description: Text("Lägg till din första vana för att börja bygga en streak.")
                    )
                } else {
                    ForEach(habits) { habit in
                        Text(habit.name)
                    }
                }
            }
            .navigationTitle("Habit Tracker")
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
