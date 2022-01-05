import SwiftUI

struct BalanceOnAppear: ViewModifier {
    @Environment(\.clockIsAnimationEnabled) var isAnimationEnabled
    @State var rotationAngle: Angle = -.degrees(20)

    func body(content: Content) -> some View {
        content
            .rotationEffect(rotationAngle)
            .onAppear {
                guard self.isAnimationEnabled else { return }
                withSlightyDelayedAnimation(animation) { rotationAngle = .degrees(20) }
            }
    }

    private var animation: Animation {
        Animation.linear(duration: 4).repeatForever(autoreverses: true)
    }
}

struct BalanceOnAppear_Previews: PreviewProvider {
    static var previews: some View {
        Moon()
            .stroke()
            .modifier(BalanceOnAppear())
    }
}
