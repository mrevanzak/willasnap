import SwiftUI

struct StoryProgressBarView: View {
  let count: Int
  let currentIndex: Int
  let progress: Double
  let spacing: CGFloat
  let barHeight: CGFloat

  public var body: some View {
    GeometryReader { geometry in
      HStack(spacing: spacing) {
        ForEach(0..<count, id: \.self) { idx in
          ZStack(alignment: .leading) {
            Capsule()
              .fill(Color.white.opacity(0.3))
              .frame(height: barHeight)
            if idx < currentIndex {
              Capsule()
                .fill(Color.white)
                .frame(height: barHeight)
            } else if idx == currentIndex {
              Capsule()
                .fill(Color.white)
                .frame(
                  width: CGFloat(progress)
                    * (geometry.size.width - CGFloat(count - 1) * spacing)
                    / CGFloat(count),
                  height: barHeight
                )
                .animation(.linear(duration: 0.016), value: progress)
            }
          }
        }
      }
    }
    .frame(height: barHeight)
  }
}

#Preview {
  StoryProgressBarView(count: 3, currentIndex: 1, progress: 0.1, spacing: 4, barHeight: 4)
    .padding()
    .background(Color.black)
}
