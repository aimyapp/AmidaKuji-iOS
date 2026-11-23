import SwiftUI

struct AmidaBoard: View {
    let memberCount: Int
    let rowCount: Int
    let bridges: [AmidaBridge]
    let route: [AmidaPoint]
    let routeProgress: CGFloat

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            let spacing = width / CGFloat(memberCount)
            let stepY = height / CGFloat(rowCount * 2 + 2)
            let xPosition: (Int) -> CGFloat = { column in
                spacing * (CGFloat(column) + 0.5)
            }
            let yPosition: (Int) -> CGFloat = { row in
                stepY * CGFloat(row)
            }

            ZStack {
                Path { path in
                    for column in 0..<memberCount {
                        let x = xPosition(column)
                        path.move(to: CGPoint(x: x, y: 0))
                        path.addLine(to: CGPoint(x: x, y: height))
                    }
                }
                .stroke(Color.gray.opacity(0.65), lineWidth: 1.5)

                Path { path in
                    for bridge in bridges {
                        let y = yPosition(bridge.row * 2 + 1)
                        path.move(to: CGPoint(x: xPosition(bridge.column), y: y))
                        path.addLine(to: CGPoint(x: xPosition(bridge.column + 1), y: y))
                    }
                }
                .stroke(Color.gray.opacity(0.65), lineWidth: 1.5)

                if route.count > 1 {
                    RouteShape(
                        points: route.map {
                            CGPoint(x: xPosition($0.column), y: yPosition($0.row))
                        },
                        progress: routeProgress
                    )
                    .stroke(
                        AmidaStyle.orange,
                        style: StrokeStyle(lineWidth: 3.5, lineCap: .round, lineJoin: .round)
                    )
                }
            }
        }
    }
}

private struct RouteShape: Shape {
    let points: [CGPoint]
    var progress: CGFloat

    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        guard let first = points.first, points.count > 1 else { return path }

        let segments = zip(points.dropLast(), points.dropFirst()).map {
            (start: $0.0, end: $0.1)
        }
        let lengths = segments.map {
            hypot($0.end.x - $0.start.x, $0.end.y - $0.start.y)
        }
        let totalLength = lengths.reduce(0, +)
        var remaining = totalLength * min(max(progress, 0), 1)
        path.move(to: first)

        for (index, segment) in segments.enumerated() {
            let length = lengths[index]
            if length <= 0 { continue }
            if remaining >= length {
                path.addLine(to: segment.end)
                remaining -= length
            } else {
                let ratio = remaining / length
                path.addLine(to: CGPoint(
                    x: segment.start.x + (segment.end.x - segment.start.x) * ratio,
                    y: segment.start.y + (segment.end.y - segment.start.y) * ratio
                ))
                break
            }
        }
        return path
    }
}
