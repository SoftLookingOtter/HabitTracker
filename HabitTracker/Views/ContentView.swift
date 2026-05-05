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
                                Button {
                                    viewModel.toggleToday(for: habit, context: context)
                                } label: {
                                    HStack(spacing: 14) {

                                        Image(systemName: habit.isCompletedToday ? "checkmark.circle.fill" : "circle")
                                            .font(.title)
                                            .foregroundStyle(
                                                habit.isCompletedToday
                                                ? LinearGradient(colors: [.green, .mint], startPoint: .top, endPoint: .bottom)
                                                : .secondary
                                            )

                                        VStack(alignment: .leading, spacing: 6) {
                                            Text(habit.name)
                                                .font(.headline)

                                            HStack(spacing: 4) {
                                                Image(systemName: "flame.fill")
                                                    .font(.caption)

                                                Text("\(habit.currentStreak)")
                                                    .font(.caption)
                                                    .fontWeight(.semibold)
                                            }
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(
                                                habit.currentStreak > 0
                                                ? Color.orange.opacity(0.2)
                                                : Color.gray.opacity(0.1)
                                            )
                                            .clipShape(Capsule())
                                            .foregroundStyle(
                                                habit.currentStreak > 0 ? .orange : .secondary
                                            )
                                        }

                                        Spacer()
                                    }
                                    .padding()
                                    .background(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 18))
                                    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                                }
                                .buttonStyle(.plain)
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                            }
                            .onDelete { indexSet in
                                for index in indexSet {
                                    context.delete(habits[index])
                                }

                                do {
                                    try context.save()
                                } catch {
                                    viewModel.errorMessage = "Kunde inte radera vanan."
                                }
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
