import SwiftUI

struct OffsetPreferenceKey: PreferenceKey {
  static var defaultValue: CGFloat = 0
  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    value = nextValue()
  }
}

struct OffsetTrackingModifier: ViewModifier {
  let coordinateSpace: String
  @Binding var offset: CGFloat

  func body(content: Content) -> some View {
    content
      .background(
        GeometryReader { geo in
          Color.clear
            .preference(
              key: OffsetPreferenceKey.self, value: geo.frame(in: .named(coordinateSpace)).minY)
        }
      )
      .onPreferenceChange(OffsetPreferenceKey.self) { value in
        offset = value
      }
  }
}

extension View {
  /// Tracks the vertical offset of the view in the given coordinate space.
  /// - Parameters:
  ///   - offset: Binding to update with the current offset.
  ///   - coordinateSpace: The named coordinate space to use (must match the parent ScrollView).
  /// - Returns: A view that updates the binding with its offset.
  func trackOffset(_ offset: Binding<CGFloat>, in coordinateSpace: String) -> some View {
    self.modifier(OffsetTrackingModifier(coordinateSpace: coordinateSpace, offset: offset))
  }
}
