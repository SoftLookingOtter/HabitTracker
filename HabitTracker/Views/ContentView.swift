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
                        VStack(spacing: 18) {
                            Image(systemName: "leaf.circle.fill")
                                .font(.system(size: 72))
                                .foregroundStyle(.green)

                            VStack(spacing: 8) {
                                Text("Inga vanor än")
                                    .font(.title2)
                                    .fontWeight(.bold)

                                Text("Börja bygga bättre rutiner genom att lägga till din första vana.")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)

                                Text("Tryck på + för att komma igång")
                                    .font(.footnote)
                                    .foregroundStyle(.green)
                                    .padding(.top, 4)
                            }
                        }
                        .padding(32)
                        .frame(maxWidth: .infinity)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 28))
                        .shadow(
                            color: .black.opacity(0.06),
                            radius: 10,
                            x: 0,
                            y: 4
                        )
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
