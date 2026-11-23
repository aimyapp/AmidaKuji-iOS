import SwiftUI

struct ContentView: View {
    @State private var showNumberInput = false
    @State private var numberOfMembers = ""
    @State private var memberCount = 0
    @State private var showMemberList = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Spacer()
                Text("人数を決めよう")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.white)
                Button {
                    numberOfMembers = ""
                    showNumberInput = true
                } label: {
                    HStack(spacing: 15) {
                        Image(systemName: "person.3.fill")
                            .font(.system(size: 28))
                        Text("手入力")
                            .font(.system(size: 24, weight: .bold))
                    }
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 90)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .padding(.horizontal, 35)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(AmidaStyle.background)
            .navigationTitle("あみだくじセンター")
            .navigationBarTitleDisplayMode(.inline)
            .alert("人数を入力", isPresented: $showNumberInput) {
                TextField("人数", text: $numberOfMembers)
                    .keyboardType(.numberPad)
                Button("キャンセル", role: .cancel) {}
                Button("確認") {
                    if let count = Int(numberOfMembers), (2...30).contains(count) {
                        memberCount = count
                        showMemberList = true
                    }
                }
            } message: {
                Text("2〜30人の人数を入力してください")
            }
            .navigationDestination(isPresented: $showMemberList) {
                MemberListView(memberCount: memberCount)
            }
        }
    }
}

#Preview { ContentView() }
