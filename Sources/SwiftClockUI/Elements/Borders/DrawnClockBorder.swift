import SwiftUI

struct DrawnClockBorder: View {
    @Environment(\.clockRandom) var random
    var drawStep: CGFloat?
    @State private var animate = false

    private static let borderWidthRatio: CGFloat = 1/35


    var body: some View {
        GeometryReader(content: content)
    }

    private func content(geometry: GeometryProxy) -> some View {
        DrawnCircle(drawStep: drawStep ?? (animate ? 1 : 0), random: random)
            .strokeBorder(lineWidth: geometry.radius * Self.borderWidthRatio)
            .onAppear {
                withAnimation(.easeInOut(duration: 1)) {
                    self.animate = true
                }
            }
    }
}

struct DrawnCircle: Shape {
    private static let marginRatio: CGFloat = 1/80
    private static let numberOfArcs = 26
    private static let angleRatio: Double = 360/Double(Self.numberOfArcs - 1)
    private let maxMarginRatio: CGFloat
    private let angleMarginRatio: Double
    private var circleStep: CGFloat

    var insetAmount: CGFloat = 0

    init(drawStep: CGFloat, random: Random) {
        self.circleStep = drawStep
        self.maxMarginRatio = random.borderMarginRatio.maxMargin(Self.marginRatio)
        self.angleMarginRatio = random.borderMarginRatio.angleMargin()
    }

    var animatableData: CGFloat {
        get { self.circleStep }
        set { self.circleStep = newValue }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let rect = rect.insetBy(dx: insetAmount, dy: insetAmount)
        path.move(to: .inCircle(rect, for: .zero))
        addArcs(to: &path, rect: rect)
        return path.trimmedPath(from: 0, to: self.circleStep)
    }

    private func addArcs(to path: inout Path, rect: CGRect) {
        let margin = rect.width * self.maxMarginRatio
        for i in 1...Self.numberOfArcs {
            let angle = Angle(degrees: Double(i) * Self.angleRatio)
            let to = CGPoint.inCircle(rect, for: angle, margin: margin)

            let controlAngle = Angle(degrees: angle.degrees - self.angleMarginRatio * Self.angleRatio)
            let control = CGPoint.inCircle(rect, for: controlAngle, margin: margin)
            path.addQuadCurve(to: to, control: control)
        }
    }
}

extension DrawnCircle: InsettableShape {
    func inset(by amount: CGFloat) -> some InsettableShape {
        var circle = self
        circle.insetAmount += amount
        return circle
    }
}

#if DEBUG
struct DrawnClockBorder_Previews: PreviewProvider {
    static var previews: some View {
        DrawnClockBorder(drawStep: 1)
    }
}

struct DrawnClockBorderAnimation_Previews: PreviewProvider {
    static var previews: some View {
        Preview()
    }

    private struct Preview: View {
        @State private var drawStep: CGFloat = 1

        var body: some View {
            VStack {
                DrawnClockBorder(drawStep: drawStep)
                Slider(value: $drawStep)
            }
        }
    }
}
#endif
