//
//  StoryView.swift
//  willasnap
//
//  Created by Revanza Kurniawan on 07/05/25.
//

import SwiftUI

struct StoryContent {
  let title: String
  let gradientColors: [Color]
  let duration: Double  // seconds
}

struct StoryScreenView: View {
  @Environment(\.dismiss) private var dismiss

  // Sample story contents with different gradients and durations
  private let stories: [StoryContent] = [
    StoryContent(
      title: "First Story", gradientColors: [Color.purple.opacity(0.8), Color.blue.opacity(0.6)],
      duration: 3.0),
    StoryContent(
      title: "Second Story", gradientColors: [Color.orange.opacity(0.8), Color.pink.opacity(0.6)],
      duration: 3.0),
    StoryContent(
      title: "Third Story", gradientColors: [Color.green.opacity(0.8), Color.yellow.opacity(0.6)],
      duration: 3.0),
  ]

  @State private var currentIndex: Int = 0
  @State private var progress: Double = 0.0
  @State private var timer: Timer? = nil

  private func startProgress() {
    timer?.invalidate()
    progress = 0.0

    let duration = stories[currentIndex].duration
    let interval = 0.016  // ~60fps for smoother animation

    timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { t in
      let increment = interval / duration

      if progress + increment >= 1.0 {
        progress = 1.0
        t.invalidate()

        if currentIndex < stories.count - 1 {
          DispatchQueue.main.async {
            goToNextStory()
          }
        } else {
          dismiss()
        }
      } else {
        progress += increment
      }
    }
  }

  private func goToNextStory() {
    if currentIndex < stories.count - 1 {
      currentIndex += 1
      startProgress()
    } else {
      dismiss()
    }
  }

  private func goToPreviousStory() {
    if currentIndex > 0 {
      currentIndex -= 1
      startProgress()
    }
  }

  var body: some View {
    GeometryReader { geometry in
      ZStack {
        GrainyGradientView(gradientColors: stories[currentIndex].gradientColors)
          .ignoresSafeArea()

        VStack(spacing: 0) {
          // Top progress bar
          HStack(spacing: 4) {
            ForEach(0..<stories.count, id: \.self) { idx in
              ZStack(alignment: .leading) {
                Capsule()
                  .fill(Color.white.opacity(0.3))
                  .frame(height: 4)
                if idx < currentIndex {
                  Capsule()
                    .fill(Color.white)
                    .frame(height: 4)
                } else if idx == currentIndex {
                  Capsule()
                    .fill(Color.white)
                    .frame(
                      width: CGFloat(progress)
                        * (geometry.size.width - CGFloat(stories.count - 1) * 4)
                        / CGFloat(stories.count), height: 4
                    )
                    .animation(.linear(duration: 0.016), value: progress)
                }
              }
            }
          }
          .padding(.horizontal, 12)

          // Story header
          HStack(spacing: 16) {
            Spacer()

            Button(action: { dismiss() }) {
              Image(systemName: "xmark")
                .foregroundColor(.white)
                .font(.system(size: 20, weight: .semibold))
            }
          }
          .padding()

          Spacer()

          // Story content
          Text(stories[currentIndex].title)
            .font(.largeTitle.bold())
            .foregroundColor(.white)

          Spacer()
        }

        // Tap areas for navigation
        HStack(spacing: 0) {
          Color.clear
            .contentShape(Rectangle())
            .onTapGesture {
              goToPreviousStory()
            }
          Color.clear
            .contentShape(Rectangle())
            .onTapGesture {
              goToNextStory()
            }
        }.padding(.top, 60)
      }
      .onAppear {
        startProgress()
      }
      .onChange(of: currentIndex) { _ in
        startProgress()
      }
    }
  }
}

#Preview {
  StoryScreenView()
}
