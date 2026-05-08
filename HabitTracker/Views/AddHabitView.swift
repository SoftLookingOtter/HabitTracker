import SwiftUI
import SwiftData

struct AddHabitView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    @Bindable var viewModel: HabitViewModel
    @State private var habitName = ""

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [
                        Color(red: 1.00, green: 0.93, blue: 0.88),
                        Color(red: 1.00, green: 0.88, blue: 0.82),
                        Color(red: 0.98, green: 0.84, blue: 0.78)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 24) {
                    Text("Ny vana")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 16)

                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 8) {
                            Image(systemName: "sparkles")
                                .foregroundStyle(.orange)

                            Text("Vad vill du börja med?")
                                .font(.headline)
                        }

                        TextField("Till exempel: Dricka vatten", text: $habitName)
                            .textFieldStyle(.plain)
                            .padding()
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 12))

                        Text("Tips: välj något enkelt som du kan göra varje dag.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .shadow(color: .orange.opacity(0.12), radius: 8, x: 0, y: 3)
                    .padding(.horizontal)

                    Spacer()
                }
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
