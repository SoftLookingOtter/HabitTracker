import Foundation
import SwiftData
import Observation

@Observable
class HabitViewModel {
    var errorMessage: String?

    func addHabit(named name: String, context: ModelContext) {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedName.isEmpty else {
            errorMessage = "Vanans namn kan inte vara tomt."
            return
        }

        let habit = Habit(name: trimmedName)
        context.insert(habit)

        do {
            try context.save()
        } catch {
            errorMessage = "Kunde inte spara vanan: \(error.localizedDescription)"
        }
    }
}
