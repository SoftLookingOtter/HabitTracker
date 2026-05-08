import SwiftUI

struct AboutView: View {
    var body: some View {
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

            ScrollView {
                VStack(spacing: 20) {
                    Text("Om appen")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 16)

                    VStack(alignment: .leading, spacing: 16) {
                        Text("Habit Tracker")
                            .font(.title2)
                            .fontWeight(.bold)

                        Text("En SwiftUI-app för att skapa vanor, markera dem som utförda och följa streaks över tid.")
                            .foregroundStyle(.secondary)

                        Divider()

                        AboutRowView(title: "SwiftUI", description: "Används för appens gränssnitt.")
                        AboutRowView(title: "SwiftData", description: "Sparar vanor lokalt på enheten.")
                        AboutRowView(title: "MVVM", description: "Delar upp kod i Models, Views och ViewModels.")
                        AboutRowView(title: "Charts", description: "Visar statistik över vanor de senaste sju dagarna.")
                    }
                    .padding()
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                    .padding(.horizontal)

                    Spacer(minLength: 24)
                }
            }
        }
    }
}

struct AboutRowView: View {
    let title: String
    let description: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)

            Text(description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}
