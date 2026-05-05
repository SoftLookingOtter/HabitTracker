import SwiftUI
import SwiftData

struct AddHabitView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    @Bindable var viewModel: HabitViewModel
    @State private var habitName = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Ny vana") {
                    TextField("Till exempel: Dricka vatten", text: $habitName)
                }
            }
            .navigationTitle("Lägg till vana")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Avbryt") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Spara") {
                        viewModel.addHabit(named: habitName, context: context)

                        if viewModel.errorMessage == nil {
                            dismiss()
                        }
                    }
                    .disabled(habitName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}
