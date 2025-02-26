import SwiftUI

struct FlipOnAppear: ViewModifier {
    @State private var rotationAngle: Angle = .zero

    func body(content: Content) -> some View {
        content
            .rotation3DEffect(rotationAngle, axis: (x: 1, y: 1, z: 0))
            .animation(animation, value: rotationAngle)
            .onAppear { rotationAngle = .fullRound }
    }

    private var animation: Animation {
        Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)
    }
}

struct FlipOnAppear_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello, World!")
            .rotationEffect(.degrees(-45))
            .modifier(FlipOnAppear())
            .frame(width: 200, height: 300)
    }
}
