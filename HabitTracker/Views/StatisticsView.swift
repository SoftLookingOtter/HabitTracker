import SwiftUI
import Charts

struct HabitCompletionData: Identifiable {
    let id = UUID()
    let date: Date
    let habitName: String
    let count: Int
}

struct StatisticsView: View {
    let habits: [Habit]

    private var weeklyData: [HabitCompletionData] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        return (0..<7).reversed().flatMap { offset in
            guard let date = calendar.date(byAdding: .day, value: -offset, to: today) else {
                return [] as [HabitCompletionData]
            }

            if habits.isEmpty {
                return [
                    HabitCompletionData(
                        date: date,
                        habitName: "Inga vanor",
                        count: 0
                    )
                ]
            }

            return habits.map { habit in
                let completedThatDay = habit.completedDates.contains { completedDate in
                    calendar.isDate(completedDate, inSameDayAs: date)
                }

                return HabitCompletionData(
                    date: date,
                    habitName: habit.name,
                    count: completedThatDay ? 1 : 0
                )
            }
        }
    }

    private var hasChartData: Bool {
        weeklyData.contains { $0.count > 0 }
    }

    private var totalHabits: Int {
        habits.count
    }

    private var totalCompletions: Int {
        habits.reduce(0) { total, habit in
            total + habit.completedDates.count
        }
    }

    private var bestStreak: Int {
        habits.map(\.currentStreak).max() ?? 0
    }

    private var topHabit: Habit? {
        habits.max(by: { $0.currentStreak < $1.currentStreak })
    }

    var body: some View {
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

            ScrollView {
                VStack(spacing: 20) {
                    Text("Statistik")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 16)

                    VStack(spacing: 12) {
                        StatCardView(
                            title: "Antal vanor",
                            value: "\(totalHabits)",
                            systemImage: "list.bullet"
                        )

                        StatCardView(
                            title: "Totala avklarningar",
                            value: "\(totalCompletions)",
                            systemImage: "checkmark.circle"
                        )

                        StatCardView(
                            title: "Bästa streak",
                            value: "\(bestStreak) dagar",
                            systemImage: "flame"
                        )

                        if let topHabit {
                            StatCardView(
                                title: "Top Habit",
                                value: "\(topHabit.name) • \(topHabit.currentStreak) dagar",
                                systemImage: "flame.fill"
                            )
                        }
                    }
                    .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 16) {
                        Text("Vanor senaste 7 dagarna")
                            .font(.headline)

                        if hasChartData {
                            Chart(weeklyData) { item in
                                BarMark(
                                    x: .value("Dag", item.date, unit: .day),
                                    y: .value("Antal", item.count)
                                )
                                .foregroundStyle(by: .value("Vana", item.habitName))
                                .position(by: .value("Vana", item.habitName))
                            }
                            .frame(height: 240)
                            .chartXAxis {
                                AxisMarks(values: .stride(by: .day)) { _ in
                                    AxisGridLine()
                                    AxisTick()
                                    AxisValueLabel(format: .dateTime.weekday(.abbreviated))
                                }
                            }
                            .chartLegend(position: .bottom)
                        } else {
                            Chart(weeklyData) { item in
                                BarMark(
                                    x: .value("Dag", item.date, unit: .day),
                                    y: .value("Antal", item.count)
                                )
                            }
                            .frame(height: 240)
                            .chartXAxis {
                                AxisMarks(values: .stride(by: .day)) { _ in
                                    AxisGridLine()
                                    AxisTick()
                                    AxisValueLabel(format: .dateTime.weekday(.abbreviated))
                                }
                            }

                            Text("Ingen historik ännu. Markera några vanor som utförda för att se statistik.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding()
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                    .padding(.horizontal)

                    Spacer(minLength: 24)
                }
            }
        }
    }
}

struct StatCardView: View {
    let title: String
    let value: String
    let systemImage: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.title3)
                .foregroundStyle(.orange)
                .frame(width: 32, height: 32)
                .background(Color.orange.opacity(0.15))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)

                Text(value)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }

            Spacer()
        }
        .padding()
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
