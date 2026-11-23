import SwiftUI

struct AmidaGameView: View {
    let memberCount: Int
    let results: [String]
    private let rowCount = 12

    @State private var bridges: [AmidaBridge] = []
    @State private var selectedMember: Int?
    @State private var selectedResult: Int?
    @State private var route: [AmidaPoint] = []
    @State private var routeProgress: CGFloat = 0
    @State private var isAnimating = false
    @State private var showResultAlert = false
    @State private var animationTask: Task<Void, Never>?

    private func resultName(at index: Int) -> String {
        guard index < results.count else { return "\(index + 1)" }
        let name = results[index].trimmingCharacters(in: .whitespacesAndNewlines)
        return name.isEmpty ? "\(index + 1)" : name
    }

    var body: some View {
        VStack(spacing: 14) {
            HStack {
                Text("あみだくじ")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.white)
                Spacer()
                Button { shuffle() } label: {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 56, height: 56)
                        .background(AmidaStyle.orange)
                        .clipShape(Circle())
                }
                .disabled(isAnimating)
                .accessibilityLabel("シャッフル")
            }
            .padding(.horizontal, 18)

            Text("上の絵文字をタップしてスタート！")
                .font(.system(size: 15))
                .foregroundStyle(.white)

            GeometryReader { geometry in
                let boardWidth = max(CGFloat(memberCount) * 54, geometry.size.width - 24)
                ScrollView(.horizontal) {
                    VStack(spacing: 0) {
                        HStack(spacing: 0) {
                            ForEach(0..<memberCount, id: \.self) { index in
                                Button { startAmida(from: index) } label: {
                                    Text(AmidaStyle.emoji(at: index))
                                        .font(.system(size: 28))
                                        .frame(width: 54, height: 54)
                                        .background(.white)
                                        .clipShape(Circle())
                                        .overlay {
                                            Circle().stroke(
                                                selectedMember == index ? AmidaStyle.orange : .clear,
                                                lineWidth: 4
                                            )
                                        }
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 68)
                                }
                                .disabled(isAnimating)
                            }
                        }
                        .frame(width: boardWidth)

                        AmidaBoard(
                            memberCount: memberCount,
                            rowCount: rowCount,
                            bridges: bridges,
                            route: route,
                            routeProgress: routeProgress
                        )
                        .frame(width: boardWidth, height: 360)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))

                        HStack(spacing: 6) {
                            ForEach(0..<memberCount, id: \.self) { index in
                                Text(resultName(at: index))
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundStyle(
                                        selectedResult == index ? AmidaStyle.orange : .black
                                    )
                                    .lineLimit(2)
                                    .minimumScaleFactor(0.7)
                                    .multilineTextAlignment(.center)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 65)
                                    .background(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 10).stroke(
                                            selectedResult == index ? AmidaStyle.orange : .clear,
                                            lineWidth: 3
                                        )
                                    }
                            }
                        }
                        .frame(width: boardWidth)
                        .padding(.top, 10)
                    }
                    .padding(.horizontal, 12)
                }
            }
            Spacer(minLength: 8)
        }
        .padding(.top, 12)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AmidaStyle.background)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if bridges.isEmpty { shuffle() }
        }
        .onDisappear {
            animationTask?.cancel()
            animationTask = nil
        }
        .alert("あみだの結果！", isPresented: $showResultAlert) {
            Button("OK") {}
        } message: {
            if let index = selectedResult {
                Text("結果は「\(resultName(at: index))」です！")
            }
        }
    }

    private func shuffle() {
        guard !isAnimating else { return }
        animationTask?.cancel()
        animationTask = nil
        var newBridges: [AmidaBridge] = []

        for _ in 0..<10 {
            var candidateBridges: [AmidaBridge] = []
            for row in 0..<rowCount {
                if Int.random(in: 0..<100) >= 65 { continue }
                var candidates = Array(0..<(memberCount - 1))
                candidates.shuffle()
                var occupied: Set<Int> = []
                let targetCount = memberCount == 2 ? 1 : max(1, (memberCount - 1) / 3)
                for column in candidates {
                    if occupied.contains(column - 1)
                        || occupied.contains(column)
                        || occupied.contains(column + 1) {
                        continue
                    }
                    candidateBridges.append(AmidaBridge(row: row, column: column))
                    occupied.insert(column)
                    if occupied.count >= targetCount { break }
                }
            }
            candidateBridges.sort {
                if $0.row == $1.row { return $0.column < $1.column }
                return $0.row < $1.row
            }
            newBridges = candidateBridges
            if newBridges != bridges { break }
        }

        bridges = newBridges
        selectedMember = nil
        selectedResult = nil
        route = []
        routeProgress = 0
        isAnimating = false
    }

    private func startAmida(from member: Int) {
        guard !isAnimating else { return }
        animationTask?.cancel()
        selectedMember = member
        selectedResult = nil
        routeProgress = 0
        showResultAlert = false
        let calculated = calculateRoute(from: member)
        route = calculated.points
        isAnimating = true
        let segmentCount = max(calculated.points.count - 1, 1)
        let duration = Double(segmentCount) * 0.18
        withAnimation(.linear(duration: duration)) { routeProgress = 1 }
        animationTask = Task { @MainActor in
            do {
                try await Task.sleep(for: .seconds(duration + 0.1))
            } catch {
                return
            }
            guard !Task.isCancelled else { return }
            selectedResult = calculated.result
            isAnimating = false
            showResultAlert = true
        }
    }

    private func calculateRoute(from start: Int) -> (points: [AmidaPoint], result: Int) {
        var column = start
        var points = [AmidaPoint(column: start, row: 0)]
        for row in 0..<rowCount {
            points.append(AmidaPoint(column: column, row: row * 2 + 1))
            if bridges.contains(where: { $0.row == row && $0.column == column }) {
                column += 1
            } else if bridges.contains(where: { $0.row == row && $0.column == column - 1 }) {
                column -= 1
            }
            points.append(AmidaPoint(column: column, row: row * 2 + 1))
        }
        points.append(AmidaPoint(column: column, row: rowCount * 2 + 2))
        return (points, column)
    }
}
