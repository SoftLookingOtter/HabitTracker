import Foundation
import SwiftData

@Model
class Habit {
    var id: UUID
    var name: String
    var completedDates: [Date]
    var createdAt: Date

    init(name: String) {
        self.id = UUID()
        self.name = name
        self.completedDates = []
        self.createdAt = Date()
    }
}

extension Habit {
    func isCompleted(on date: Date) -> Bool {
        let calendar = Calendar.current

        return completedDates.contains { completedDate in
            calendar.isDate(completedDate, inSameDayAs: date)
        }
    }

    var isCompletedToday: Bool {
        isCompleted(on: Date())
    }

    var currentStreak: Int {
        let calendar = Calendar.current

        let uniqueDays = Set(completedDates.map {
            calendar.startOfDay(for: $0)
        })

        let sortedDays = uniqueDays.sorted(by: >)

        guard let latest = sortedDays.first else {
            return 0
        }

        let today = calendar.startOfDay(for: Date())
        let daysSinceLatest = calendar.dateComponents([.day], from: latest, to: today).day ?? 0

        if daysSinceLatest > 1 {
            return 0
        }

        var streak = 1
        var expected = calendar.date(byAdding: .day, value: -1, to: latest)!

        for day in sortedDays.dropFirst() {
            if day == expected {
                streak += 1
                expected = calendar.date(byAdding: .day, value: -1, to: expected)!
            } else {
                break
            }
        }

        return streak
    }
}
