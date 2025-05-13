//
//  StoryView.swift
//  willasnap
//
//  Created by Revanza Kurniawan on 07/05/25.
//

import SwiftUI

struct StoryLine {
  let text: String
  let duration: Double
}

struct StoryContent {
  let lines: [StoryLine]
  let gradientColors: [Color]
}

struct ProgressMaskText: View {
  let text: String
  let font: Font
  let progress: Double
  let highlightColor: Color
  let fadedColor: Color

  var body: some View {
    ZStack(alignment: .leading) {
      // Faded background text
      Text(text)
        .font(font)
        .foregroundColor(fadedColor)
        .fixedSize(horizontal: false, vertical: true)
      // Foreground text, masked by progress
      Text(text)
        .font(font)
        .foregroundColor(highlightColor)
        .fixedSize(horizontal: false, vertical: true)
        .mask(
          GeometryReader { geo in
            Rectangle()
              .frame(width: geo.size.width * progress)
              .animation(.linear(duration: 0.01), value: progress)
          }
        )
    }
  }
}

struct StoryScreenView: View {
  @Environment(\.dismiss) private var dismiss

  // Sample story contents with multi-line lyrics and per-line durations
  private let stories: [StoryContent] = [
    StoryContent(
      lines: [
        StoryLine(text: "Ntara! ngala ku Willas.", duration: 2.0),
        StoryLine(text: "kaiu'u ku ntua Palu", duration: 2.0),
      ],
      gradientColors: [Color.purple.opacity(0.8), Color.blue.opacity(0.6)]
    ),
    StoryContent(
      lines: [
        StoryLine(text: "Second Story Line 1", duration: 2.0),
        StoryLine(text: "Second Story Line 2", duration: 2.0),
      ],
      gradientColors: [Color.orange.opacity(0.8), Color.pink.opacity(0.6)]
    ),
    StoryContent(
      lines: [
        StoryLine(text: "Third Story Line 1", duration: 2.0),
        StoryLine(text: "Third Story Line 2", duration: 2.0),
      ],
      gradientColors: [Color.green.opacity(0.8), Color.yellow.opacity(0.6)]
    ),
  ]

  @State private var currentIndex: Int = 0
  @State private var currentLineIndex: Int = 0
  @State private var lineProgress: Double = 0.0
  @State private var timer: Timer? = nil

  private func startLineProgress() {
    timer?.invalidate()
    lineProgress = 0.0

    let story = stories[currentIndex]
    let duration = story.lines[currentLineIndex].duration
    let interval = 0.016  // ~60fps

    timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { t in
      let increment = interval / duration
      if lineProgress + increment < 1.0 {
        lineProgress += increment
        return
      }
      lineProgress = 1.0
      t.invalidate()
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
        goToNextLineOrStory()
      }
    }
  }

  private func goToNextLineOrStory() {
    let story = stories[currentIndex]
    if currentLineIndex < story.lines.count - 1 {
      currentLineIndex += 1
      startLineProgress()
    } else {
      goToNextStory()
    }
  }

  private func goToNextStory() {
    if currentIndex >= stories.count - 1 {
      dismiss()
      return
    }
    currentIndex += 1
    currentLineIndex = 0
    startLineProgress()
  }

  private func goToPreviousStory() {
    if currentIndex > 0 {
      currentIndex -= 1
      currentLineIndex = 0
      startLineProgress()
    }
  }

  var body: some View {
    GeometryReader { geometry in
      ZStack {
        // Replace with your gradient background
        LinearGradient(
          colors: stories[currentIndex].gradientColors,
          startPoint: .topLeading,
          endPoint: .bottomTrailing
        )
        .ignoresSafeArea()

        VStack(spacing: 0) {
          // Progress bar for stories
          StoryProgressBarView(
            count: stories.count,
            currentIndex: currentIndex,
            progress: {
              let story = stories[currentIndex]
              let totalDuration = story.lines.map { $0.duration }.reduce(0, +)
              let completedDuration = story.lines.prefix(currentLineIndex).map { $0.duration }
                .reduce(0, +)
              let currentLineDuration = story.lines[currentLineIndex].duration
              return (completedDuration + lineProgress * currentLineDuration) / totalDuration
            }(),
            spacing: 4,
            barHeight: 4
          )
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

          // Animated lyrics
          VStack(spacing: 12) {
            ForEach(Array(stories[currentIndex].lines.enumerated()), id: \.offset) { idx, line in
              ProgressMaskText(
                text: line.text,
                font: .largeTitle.bold(),
                progress: idx == currentLineIndex
                  ? lineProgress : (idx < currentLineIndex ? 1.0 : 0.0),
                highlightColor: .white,
                fadedColor: .white.opacity(0.3)
              )
              .frame(maxWidth: .infinity, alignment: .center)
            }
          }
          .padding(.horizontal, 24)

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
        startLineProgress()
      }
      .onChange(of: currentIndex) { _ in
        currentLineIndex = 0
        startLineProgress()
      }
      .onChange(of: currentLineIndex) { _ in
        startLineProgress()
      }
    }
  }
}

#Preview {
  StoryScreenView()
}
