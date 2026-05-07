import SwiftUI
import Charts

struct HabitCompletionData: Identifiable {
    let id = UUID()
    let date: Date
    let habitName: String
    let habitIndex: Int
}

struct StatisticsView: View {
    let habits: [Habit]

    private let chartColors: [Color] = [
        .blue, .green, .orange, .purple, .red, .cyan, .yellow, .mint, .pink, .indigo,
        .teal, .brown, .gray, .black, .accentColor,
        .orange.opacity(0.7), .green.opacity(0.7), .blue.opacity(0.7), .purple.opacity(0.7), .red.opacity(0.7),
        .cyan.opacity(0.7), .mint.opacity(0.7), .indigo.opacity(0.7), .pink.opacity(0.7), .teal.opacity(0.7),
        .brown.opacity(0.7), .gray.opacity(0.7),
    ]

    private var weekDays: [Date] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        return (0..<7).reversed().compactMap { offset in
            calendar.date(byAdding: .day, value: -offset, to: today)
        }
    }

    private var chartHeight: CGFloat {
        220
    }

    private var completedTimelineData: [HabitCompletionData] {
        let calendar = Calendar.current

        return weekDays.flatMap { date in
            habits.enumerated().compactMap { index, habit in
                let completedThatDay = habit.completedDates.contains { completedDate in
                    calendar.isDate(completedDate, inSameDayAs: date)
                }

                guard completedThatDay else {
                    return nil
                }

                return HabitCompletionData(
                    date: date,
                    habitName: habit.name,
                    habitIndex: index
                )
            }
        }
    }

    private var hasChartData: Bool {
        !completedTimelineData.isEmpty
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
                VStack(spacing: 16) {
                    Text("Statistik")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 16)

                    VStack(spacing: 8) {
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
                        Text("Utförda vanor senaste 7 dagarna")
                            .font(.headline)

                        if hasChartData {
                            Chart {
                                ForEach(weekDays, id: \.self) { day in
                                    RuleMark(x: .value("Dag", day, unit: .day))
                                        .foregroundStyle(Color.gray.opacity(0.18))
                                }

                                ForEach(habits.indices, id: \.self) { index in
                                    RuleMark(y: .value("Vana", index))
                                        .foregroundStyle(Color.gray.opacity(0.15))
                                }

                                ForEach(completedTimelineData) { item in
                                    PointMark(
                                        x: .value("Dag", item.date, unit: .day),
                                        y: .value("Vana", item.habitIndex)
                                    )
                                    .foregroundStyle(color(for: item.habitIndex))
                                    .symbol(Circle())
                                    .symbolSize(130)
                                }
                            }
                            .frame(height: chartHeight)
                            .chartYScale(domain: -0.5...Double(max(habits.count - 1, 0)) + 0.5)
                            .chartXAxis {
                                AxisMarks(values: weekDays) { _ in
                                    AxisGridLine()
                                    AxisTick()
                                    AxisValueLabel(format: .dateTime.weekday(.abbreviated))
                                }
                            }
                            .chartYAxis(.hidden)
                            .chartLegend(.hidden)

                            HabitLegendView(
                                habits: habits,
                                colors: chartColors
                            )

                            Text("Varje prick visar att en vana utfördes den dagen.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        } else {
                            Chart {
                                ForEach(weekDays, id: \.self) { day in
                                    RuleMark(x: .value("Dag", day, unit: .day))
                                        .foregroundStyle(Color.gray.opacity(0.18))
                                }
                            }
                            .frame(height: 180)
                            .chartXAxis {
                                AxisMarks(values: weekDays) { _ in
                                    AxisGridLine()
                                    AxisTick()
                                    AxisValueLabel(format: .dateTime.weekday(.abbreviated))
                                }
                            }
                            .chartYAxis(.hidden)

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

    private func color(for index: Int) -> Color {
        chartColors[index % chartColors.count]
    }
}

struct HabitLegendView: View {
    let habits: [Habit]
    let colors: [Color]

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: 6) {
            ForEach(habits.indices, id: \.self) { index in
                HStack(spacing: 6) {
                    Circle()
                        .fill(colors[index % colors.count])
                        .frame(width: 8, height: 8)

                    Text(habits[index].name)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }
        }
        .padding(.top, 4)
    }
}

struct StatCardView: View {
    let title: String
    let value: String
    let systemImage: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: systemImage)
                .font(.subheadline)
                .foregroundStyle(.orange)
                .frame(width: 28, height: 28)
                .background(Color.orange.opacity(0.15))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)

                Text(value)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            Spacer()
        }
        .padding(12)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
    }
}
