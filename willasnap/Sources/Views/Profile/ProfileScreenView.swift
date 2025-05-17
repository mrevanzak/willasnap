//
//  StoryView.swift
//  willasnap
//
//  Created by Revanza Kurniawan on 07/05/25.
//

import SwiftUI

struct ProfileScreenView: View {
  @Environment(\.colorScheme) var colorScheme
  @State private var showStory = false
  @State private var scrollOffset: CGFloat = 0
  @State private var enlargeAvatar: Bool = false

  @State private var showFullName = false
  @State private var displayedName = "Willas Daniel"
  @State private var typingTimer: Timer?

  let screenWidth = UIScreen.main.bounds.width

  let fullName = "Willas Daniel Rorrong Lumban Tobing"
  let shortName = "Willas Daniel"

  var normalizedProgress: CGFloat {
    let dynamicIslandDistance: CGFloat = -25.0
    let calculatedOffset = min(0, max(scrollOffset, dynamicIslandDistance))
    return abs(calculatedOffset / dynamicIslandDistance)
  }

  var body: some View {
    NavigationStack {
      ScrollView {
        VStack(alignment: .center, spacing: 16) {
          VStack(alignment: .center, spacing: 12) {
            StoryAvatarView(size: 96) {
              Image("willas")
                .resizable()
                .scaledToFill()
                .blur(radius: 10 * normalizedProgress, opaque: true)
            }
            .onTapGesture {
              showStory = true
            }
            .fullScreenCover(isPresented: $showStory) {
              StoryScreenView()
            }
            .scaleEffect(1.0 - normalizedProgress * 0.5, anchor: .top)
            .trackOffset($scrollOffset, in: "scroll")

            VStack {
              Button(
                action: {
                  withAnimation {
                    showFullName.toggle()
                  }
                  typingTimer?.invalidate()
                  if showFullName {
                    // Find common prefix (corrected)
                    let commonPrefix = String(
                      zip(fullName, displayedName).prefix { $0 == $1 }.map { $0.0 })
                    displayedName = commonPrefix
                    var currentIndex = commonPrefix.count
                    let characters = Array(fullName)
                    typingTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) {
                      timer in
                      if currentIndex < characters.count {
                        displayedName += String(characters[currentIndex])
                        currentIndex += 1
                      } else {
                        timer.invalidate()
                      }
                    }
                  } else {
                    displayedName = shortName
                  }
                }
              ) {
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                  Text(displayedName)
                    .lineLimit(1)
                    .font(.title3)
                    .foregroundStyle(.primary)
                  if !showFullName {
                    Image(systemName: "ellipsis")
                      .font(.caption)
                      .foregroundColor(.primary)
                  }
                }
              }

              Text("Machine Learning Enthusiast")
                .font(.subheadline)
                .foregroundColor(.gray)
            }
            .buttonStyle(.borderless)
            .accessibilityLabel("Toggle full name")
          }

          AudioPlayerView(audioFileName: "willas-intro", audioFileExtension: "m4a")

          // Personal Information Section
          VStack(alignment: .leading, spacing: 12) {
            Text("Personal Information")
              .font(.headline)
              .foregroundColor(.primary)

            VStack(alignment: .leading, spacing: 8) {
              HStack {
                Image(systemName: "birthday.cake")
                  .foregroundColor(.blue)
                Text("Date of Birth:")
                  .font(.subheadline)
                  .foregroundColor(.secondary)
                Spacer()
                Text("Palu, 16 April 2005")
                  .font(.subheadline)
              }
            }
          }
          .padding()
          .background(
            RoundedRectangle(cornerRadius: 12)
              .fill(Color(.systemGray6))
          )
          // End Personal Information Section
        }
      }
      .overlay(alignment: .top) {
        Rectangle()
          .fill(colorScheme == .dark ? Color.black : Color.white)
          .frame(width: screenWidth, height: 15)
          .ignoresSafeArea()
      }
      .coordinateSpace(name: "scroll")
    }
    .contentMargins(.horizontal, 16, for: .scrollContent)
    .navigationTitle("Profile")
    .navigationBarTitleDisplayMode(.inline)
    .animation(.easeInOut, value: scrollOffset)
  }
}

#Preview {
  ProfileScreenView()
}
