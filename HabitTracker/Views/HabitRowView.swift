import SwiftUI

struct HabitRowView: View {
    let habit: Habit
    let currentDate: Date
    let onToggle: () -> Void

    var body: some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.55)) {
                onToggle()
            }
        } label: {
            HStack(spacing: 10) {
                Image(systemName: habit.isCompleted(on: currentDate) ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(habit.isCompleted(on: currentDate) ? .green : .secondary)

                VStack(alignment: .leading, spacing: 3) {
                    Text(habit.name)
                        .font(.subheadline)
                        .fontWeight(.semibold)

                    HStack(spacing: 4) {
                        Image(systemName: "flame.fill")
                            .font(.caption2)

                        Text("\(habit.currentStreak)")
                            .font(.caption2)
                            .fontWeight(.semibold)
                    }
                    .padding(.horizontal, 7)
                    .padding(.vertical, 2)
                    .background(Color.orange.opacity(0.16))
                    .clipShape(Capsule())
                    .foregroundStyle(.orange)
                }

                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 9)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.035), radius: 3, x: 0, y: 1)
        }
        .buttonStyle(.plain)
    }
}
