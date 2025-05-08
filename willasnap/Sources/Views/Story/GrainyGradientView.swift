import SwiftUI

struct GrainyGradientView: View {
  var gradientColors: [Color] = [.purple, .blue]

  var body: some View {
    Canvas { context, size in
      // Draw gradient
      let gradient = Gradient(colors: gradientColors)
      let rect = CGRect(origin: .zero, size: size)
      context.fill(
        Path(rect),
        with: .linearGradient(
          gradient,
          startPoint: .zero,
          endPoint: CGPoint(x: size.width, y: size.height)
        )
      )

      // Draw noise
      let noiseScale: CGFloat = 1.0
      let cells = Int(size.width * size.height / (noiseScale * noiseScale))

      for _ in 0..<cells {
        let x = CGFloat.random(in: 0...size.width)
        let y = CGFloat.random(in: 0...size.height)
        let rect = CGRect(x: x, y: y, width: noiseScale, height: noiseScale)

        context.fill(
          Path(rect),
          with: .color(.white.opacity(Double.random(in: 0...0.1)))
        )
      }
    }
  }
}

#Preview {
  GrainyGradientView()
    .frame(width: 300, height: 500)
}
