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
    
    func toggleToday(for habit: Habit, context: ModelContext) {
        let calendar = Calendar.current

        if let index = habit.completedDates.firstIndex(where: {
            calendar.isDateInToday($0)
        }) {
            // redan klar idag → ta bort
            habit.completedDates.remove(at: index)
        } else {
            // inte klar → lägg till idag
            habit.completedDates.append(Date())
        }

        do {
            try context.save()
        } catch {
            errorMessage = "Kunde inte spara ändringen: \(error.localizedDescription)"
        }
    }
}


