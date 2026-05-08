import SwiftUI

struct HabitRowView: View {
    let habit: Habit
    let currentDate: Date
    let onToggle: () -> Void

    @State private var animateCompletion = false

    var body: some View {
        Button {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.45)) {
                onToggle()
                animateCompletion = true
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                withAnimation(.easeOut(duration: 0.3)) {
                    animateCompletion = false
                }
            }
        } label: {
            HStack(spacing: 14) {

                ZStack {
                    Circle()
                        .fill(
                            habit.isCompleted(on: currentDate)
                            ? Color.green.opacity(animateCompletion ? 0.35 : 0)
                            : Color.clear
                        )
                        .frame(width: 52, height: 52)
                        .blur(radius: animateCompletion ? 12 : 0)
                        .scaleEffect(animateCompletion ? 1.4 : 0.8)

                    Image(systemName:
                            habit.isCompleted(on: currentDate)
                          ? "checkmark.circle.fill"
                          : "circle"
                    )
                    .font(.system(size: 30))
                    .foregroundStyle(
                        habit.isCompleted(on: currentDate)
                        ? .green
                        : .secondary
                    )
                    .scaleEffect(
                        animateCompletion &&
                        habit.isCompleted(on: currentDate)
                        ? 1.35
                        : 1.0
                    )
                    .symbolEffect(
                        .bounce,
                        value: animateCompletion
                    )
                }

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
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(
                        habit.currentStreak > 0
                        ? Color.orange.opacity(0.2)
                        : Color.gray.opacity(0.1)
                    )
                    .clipShape(Capsule())
                    .foregroundStyle(
                        habit.currentStreak > 0
                        ? .orange
                        : .secondary
                    )
                    .scaleEffect(
                        animateCompletion &&
                        habit.isCompleted(on: currentDate)
                        ? 1.15
                        : 1.0
                    )
                    .shadow(
                        color: habit.currentStreak > 0 && animateCompletion
                        ? Color.orange.opacity(0.7)
                        : .clear,
                        radius: animateCompletion ? 16 : 0
                    )
                }

                Spacer()
            }
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .shadow(
                color: .black.opacity(0.05),
                radius: 5,
                x: 0,
                y: 2
            )
            .scaleEffect(
                animateCompletion ? 1.02 : 1.0
            )
        }
        .buttonStyle(.plain)
    }
}
