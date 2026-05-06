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
            HStack(spacing: 14) {
                Image(systemName: habit.isCompleted(on: currentDate) ? "checkmark.circle.fill" : "circle")
                    .font(.title)
                    .foregroundStyle(habit.isCompleted(on: currentDate) ? .green : .secondary)

                VStack(alignment: .leading, spacing: 6) {
                    Text(habit.name)
                        .font(.headline)

                    HStack(spacing: 4) {
                        Image(systemName: "flame.fill")
                            .font(.caption)

                        Text("\(habit.currentStreak)")
                            .font(.caption)
                            .fontWeight(.semibold)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        habit.currentStreak > 0
                        ? Color.orange.opacity(0.2)
                        : Color.gray.opacity(0.1)
                    )
                    .clipShape(Capsule())
                    .foregroundStyle(habit.currentStreak > 0 ? .orange : .secondary)
                    .scaleEffect(habit.isCompleted(on: currentDate) ? 1.08 : 1.0)
                    .shadow(
                        color: habit.currentStreak > 0 ? Color.orange.opacity(0.35) : Color.clear,
                        radius: habit.currentStreak > 0 ? 8 : 0,
                        x: 0,
                        y: 0
                    )
                }

                Spacer()
            }
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }
}
