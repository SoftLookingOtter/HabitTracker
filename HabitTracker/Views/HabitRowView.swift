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
            HStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(
                            habit.isCompleted(on: currentDate)
                            ? Color.green.opacity(animateCompletion ? 0.35 : 0)
                            : Color.clear
                        )
                        .frame(width: 42, height: 42)
                        .blur(radius: animateCompletion ? 10 : 0)
                        .scaleEffect(animateCompletion ? 1.35 : 0.8)

                    Image(
                        systemName: habit.isCompleted(on: currentDate)
                        ? "checkmark.circle.fill"
                        : "circle"
                    )
                    .font(.title3)
                    .foregroundStyle(
                        habit.isCompleted(on: currentDate)
                        ? .green
                        : .secondary
                    )
                    .scaleEffect(
                        animateCompletion && habit.isCompleted(on: currentDate)
                        ? 1.3
                        : 1.0
                    )
                    .symbolEffect(.bounce, value: animateCompletion)
                }

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
                    .scaleEffect(
                        animateCompletion && habit.isCompleted(on: currentDate)
                        ? 1.12
                        : 1.0
                    )
                    .shadow(
                        color: habit.currentStreak > 0 && animateCompletion
                        ? Color.orange.opacity(0.55)
                        : .clear,
                        radius: animateCompletion ? 12 : 0
                    )
                }

                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 9)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(
                color: .black.opacity(0.035),
                radius: 3,
                x: 0,
                y: 1
            )
            .scaleEffect(animateCompletion ? 1.015 : 1.0)
        }
        .buttonStyle(.plain)
    }
}
