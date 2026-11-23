import SwiftUI

struct ResultSettingsView: View {
    let memberCount: Int
    @State private var results: [String] = []
    @State private var showAmida = false

    var body: some View {
        VStack(spacing: 20) {
            Text("結果を決めよう")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(.white)
                .padding(.top, 20)
            Text("結果の名前をタップして変更できます")
                .foregroundStyle(.white)
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(results.indices, id: \.self) { index in
                        HStack(spacing: 12) {
                            Text("\(index + 1)")
                                .frame(width: 30)
                            TextField("結果を入力", text: $results[index])
                                .textFieldStyle(.roundedBorder)
                        }
                        .padding()
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding()
            }
            OrangeButton(title: "あみだ始め！") { showAmida = true }
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AmidaStyle.background)
        .navigationDestination(isPresented: $showAmida) {
            AmidaGameView(memberCount: memberCount, results: results)
        }
        .onAppear {
            if results.isEmpty {
                results = (1...memberCount).map { "\($0)" }
            }
        }
    }
}
