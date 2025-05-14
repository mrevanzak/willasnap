import SwiftUI

struct StoryAvatarView<Content: View>: View {
  var size: CGFloat = 120
  @ViewBuilder var content: () -> Content

  @State private var animateGradient = false

  var body: some View {
    VStack {
      ZStack {
        // Rainbow ring
        Circle()
          .fill(
            AngularGradient(
              colors: [.purple, .blue, .green, .yellow, .orange, .red, .purple],
              center: .center,
              startAngle: .degrees(0),
              endAngle: .degrees(360)
            )
          )
          .frame(width: size + 12, height: size + 12)
          .rotationEffect(.degrees(animateGradient ? 360 : 0))

        // White border
        Circle()
          .fill(.white)
          .frame(width: size + 8, height: size + 8)

        // Avatar
        Circle()
          .fill(Color(.systemGray6))
          .frame(width: size, height: size)
          .overlay(
            content()
              .clipShape(Circle())
          )
      }
    }
    .onAppear {
      withAnimation(.linear(duration: 4.0).repeatForever(autoreverses: false)) {
        animateGradient.toggle()
      }
    }
  }
}

#Preview {
  StoryAvatarView(size: 80) {
    Image("willas")
      .resizable()
      .scaledToFill()
  }
}
