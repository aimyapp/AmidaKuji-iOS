import SwiftUI

struct MemberListView: View {
    let memberCount: Int
    @State private var showResultSettings = false

    var body: some View {
        VStack(spacing: 20) {
            Text("メンバー一覧")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(.white)
                .padding(.top, 20)
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(0..<memberCount, id: \.self) { index in
                        HStack(spacing: 15) {
                            Text(AmidaStyle.emoji(at: index))
                                .font(.system(size: 30))
                            Text("メンバー\(index + 1)")
                                .font(.system(size: 20))
                            Spacer()
                        }
                        .padding()
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding()
            }
            OrangeButton(title: "次へ") { showResultSettings = true }
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AmidaStyle.background)
        .navigationDestination(isPresented: $showResultSettings) {
            ResultSettingsView(memberCount: memberCount)
        }
    }
}
