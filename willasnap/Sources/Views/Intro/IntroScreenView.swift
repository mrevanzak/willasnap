//
//  StoryView.swift
//  willasnap
//
//  Created by Revanza Kurniawan on 17/05/25.
//

import SwiftUI

struct IntroScreenView: View {
  @State private var activeCard: Card? = cards.first
  @State private var scrollPosition: ScrollPosition = .init()
  @State private var currentScrollOffset: CGFloat = 0
  @State private var timer = Timer.publish(every: 0.01, on: .current, in: .default).autoconnect()
  @State private var initialAnimation: Bool = false
  @State private var titleProgress: CGFloat = 0
  @State private var scrollPhase: ScrollPhase = .idle
  @State private var showProfileScreen: Bool = false

  var body: some View {
    ZStack {
      AmbientBackground()
        .animation(.easeInOut(duration: 1), value: activeCard)

      VStack(spacing: 56) {
        InfiniteScrollView {
          ForEach(cards) { card in
            CarouselCardView(card)
          }
        }
        .scrollIndicators(.hidden)
        .scrollPosition($scrollPosition)
        .scrollClipDisabled()
        .containerRelativeFrame(.vertical) { value, _ in
          value * 0.45
        }
        .onScrollPhaseChange({ oldPhase, newPhase in
          scrollPhase = newPhase
        })
        .onScrollGeometryChange(for: CGFloat.self) {
          $0.contentOffset.x + $0.contentInsets.leading
        } action: { oldValue, newValue in
          currentScrollOffset = newValue
          if scrollPhase != .decelerating || scrollPhase != .animating {
            let activeIndex = Int((currentScrollOffset / 220).rounded()) % cards.count
            activeCard = cards[activeIndex]
          }
        }
        .visualEffect { [initialAnimation] content, proxy in
          content
            .offset(y: !initialAnimation ? -(proxy.size.height + 200) : 0)
        }

        VStack(spacing: 4) {
          Text("Halo!")
            .font(.largeTitle.bold())
            .foregroundStyle(.white)
            .textRenderer(TitleTextRenderer(progress: titleProgress))
            .padding(.bottom, 12)

          Text(
            "This is me, Willas. I'm a second year student majoring informatics at Universitas Ciputra Surabaya, that is always fueled by curiosity and hard work to achieve many things. I am fond to collaborate and work with other people."
          )
          .font(.body)
          .multilineTextAlignment(.center)
          .foregroundStyle(.white.secondary)
          .offset(y: initialAnimation ? 0 : -40)
          .opacity(initialAnimation ? 1 : 0)
          .animation(
			.spring(response: 0.4, dampingFraction: 0.3).delay(0.5), value: initialAnimation)
        }

        Button {
          showProfileScreen = true
        } label: {
          Text("Get to know me!")
            .fontWeight(.semibold)
            .foregroundStyle(.black)
            .padding(.horizontal, 25)
            .padding(.vertical, 12)
            .background(.white, in: .capsule)
        }
        .fullScreenCover(isPresented: $showProfileScreen) {
          ProfileScreenView()
        }
        .blurOpacityEffect(initialAnimation)

      }
      .safeAreaPadding(15)

    }
    .onReceive(timer) { _ in
      currentScrollOffset += 0.35
      scrollPosition.scrollTo(x: currentScrollOffset)
    }
    .task {
      try? await Task.sleep(for: .seconds(0.35))
      withAnimation(.smooth(duration: 0.75, extraBounce: 0)) {
        initialAnimation = true
      }

      withAnimation(.smooth(duration: 2.5, extraBounce: 0).delay(0.3)) {
        titleProgress = 1
      }
    }

  }

  @ViewBuilder
  private func AmbientBackground() -> some View {
    GeometryReader {
      let size = $0.size
      ZStack {
        ForEach(cards) { card in

          Image(card.image)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .ignoresSafeArea()
            .frame(width: size.width, height: size.height)
            .opacity(activeCard?.id == card.id ? 1 : 0)

        }

        Rectangle()
          .fill(.black.opacity(0.45))
          .ignoresSafeArea()

      }
      .compositingGroup()
      .blur(radius: 90, opaque: true)
      .ignoresSafeArea()
    }
  }

  @ViewBuilder
  private func CarouselCardView(_ card: Card) -> some View {
    let screenWidth = UIScreen.main.bounds.width

    GeometryReader {
      let size = $0.size

      Image(card.image)
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(width: size.width, height: size.height)
        .clipShape(.rect(cornerRadius: 20))
        .shadow(color: .black.opacity(0.4), radius: 10, x: 1, y: 0)

    }
    .frame(width: screenWidth * 0.65)
    .scrollTransition(.interactive.threshold(.centered), axis: .horizontal) { content, phase in
      content
        .offset(y: phase == .identity ? -10 : 0)
        .rotationEffect(.degrees(phase.value * 5), anchor: .bottom)
    }
  }

}

extension UIView {
  var scrollView: UIScrollView? {
    if let superview, superview is UIScrollView {
      return superview as? UIScrollView
    }
    return superview?.scrollView
  }
}

#Preview {
  IntroScreenView()
}
