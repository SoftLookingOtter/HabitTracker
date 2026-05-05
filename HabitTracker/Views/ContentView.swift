import SwiftUI
import SwiftData

struct ContentView: View {
    @Query private var habits: [Habit]

    var body: some View {
        NavigationStack {
            List {
                if habits.isEmpty {
                    Text("Inga vanor än")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(habits) { habit in
                        Text(habit.name)
                    }
                }
            }
            .navigationTitle("Habit Tracker")
        }
    }
}

#Preview {
    ContentView()
}
