import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.scenePhase) private var scenePhase

    @Query(sort: \Habit.createdAt, order: .reverse)
    private var habits: [Habit]

    @State private var viewModel = HabitViewModel()
    @State private var showingAddHabit = false
    @State private var currentDate = Date()

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
                                HabitRowView(
                                    habit: habit,
                                    currentDate: currentDate
                                ) {
                                    viewModel.toggleToday(for: habit, context: context)
                                    currentDate = Date()
                                }
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                                .listRowInsets(
                                    EdgeInsets(
                                        top: 4,
                                        leading: 16,
                                        bottom: 4,
                                        trailing: 16
                                    )
                                )
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
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink {
                        StatisticsView(habits: habits)
                    } label: {
                        Image(systemName: "chart.bar.fill")
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        NavigationLink {
                            AboutView()
                        } label: {
                            Image(systemName: "info.circle")
                        }

                        Button {
                            showingAddHabit = true
                        } label: {
                            Image(systemName: "plus")
                        }
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
            .onAppear {
                currentDate = Date()
            }
            .onChange(of: scenePhase) {
                if scenePhase == .active {
                    currentDate = Date()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
