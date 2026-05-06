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
            ZStack {
                LinearGradient(
                    colors: [
                        Color.green.opacity(0.15),
                        Color.orange.opacity(0.15),
                        Color.clear
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 16) {
                    Text("Mina vanor")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 16)

                    if habits.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "leaf.fill")
                                .font(.system(size: 48))
                                .foregroundStyle(.green)

                            Text("Inga vanor än")
                                .font(.headline)

                            Text("Lägg till din första vana för att börja bygga en streak.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        .padding(24)
                        .frame(maxWidth: .infinity)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding(.horizontal)

                        Spacer()
                    } else {
                        List {
                            ForEach(habits) { habit in
                                HabitRowView(habit: habit) {
                                    viewModel.toggleToday(for: habit, context: context)
                                }
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                            }
                            .onDelete { indexSet in
                                viewModel.deleteHabits(
                                    at: indexSet,
                                    from: habits,
                                    context: context
                                )
                            }
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                    }
                }
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
