import SwiftUI
import SwiftData

struct AddHabitView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    @Bindable var viewModel: HabitViewModel
    @State private var habitName = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("Lägg till vana")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 32)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Ny vana")
                        .font(.headline)

                    TextField("Till exempel: Dricka vatten", text: $habitName)
                        .textFieldStyle(.roundedBorder)
                }
                .padding(.horizontal)

                Spacer()
            }
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
