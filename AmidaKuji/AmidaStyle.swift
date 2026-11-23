import SwiftUI

enum AmidaStyle {
    static let background = Color(red: 0.32, green: 0.78, blue: 0.85)
    static let orange = Color(red: 1.0, green: 0.58, blue: 0.17)
    static let emojis = ["👨", "👩", "🐱", "🐶", "🐼", "🦊", "🐰", "🐻", "🐸", "🐵", "🐯", "🐨", "🐷", "🐧", "🦁"]
    static func emoji(at index: Int) -> String { emojis[index % emojis.count] }
}

struct OrangeButton: View {
    let title: String
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 21, weight: .bold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(AmidaStyle.orange)
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }
}
