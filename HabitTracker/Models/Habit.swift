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
    var isCompletedToday: Bool {
        let calendar = Calendar.current
        return completedDates.contains { date in
            calendar.isDateInToday(date)
        }
    }
}
