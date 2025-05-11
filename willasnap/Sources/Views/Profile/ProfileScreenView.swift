//
//  StoryView.swift
//  willasnap
//
//  Created by Revanza Kurniawan on 07/05/25.
//

import Inject
import SwiftUI

struct ProfileScreenView: View {
  @ObservedObject private var iO = InjectConfiguration.observer

  @State private var showStory = false
  @State private var scrollOffset: CGFloat = 0

  @State private var showFullName = false
  @State private var displayedName = "Willas Daniel"
  @State private var typingTimer: Timer?

  let fullName = "Willas Daniel Rorrong Lumban Tobing"
  let shortName = "Willas Daniel"

  //  @Binding var offset: CGPoint

  var body: some View {
    NavigationStack {
      ScrollView {
        VStack(alignment: .center, spacing: 12) {
          StoryAvatarView(size: 72)
            .onTapGesture {
              showStory = true
            }
            .fullScreenCover(isPresented: $showStory) {
              StoryScreenView()
            }

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
              HStack(alignment: .bottom, spacing: 4) {
                Text(displayedName)
                  .lineLimit(1)
                  .font(.title3)
                  .foregroundStyle(.primary)
                if !showFullName {
                  Image(systemName: "ellipsis")
                    .font(.caption)
                    .foregroundColor(.primary)
                    .padding(.bottom, 4)
                }
              }
            }

            Text("Machine Learning Enthusiast")
              .font(.subheadline)
              .foregroundColor(.gray)
          }
          .buttonStyle(.borderless)
          .accessibilityLabel("Toggle full name")

          AudioPlayerView(audioFileName: "willas-intro", audioFileExtension: "m4a")
        }

        Spacer()
      }
    }
    .contentMargins(.horizontal, 16, for: .scrollContent)
    .navigationTitle(scrollOffset < -40 ? "Profile" : "")
    .navigationBarTitleDisplayMode(.inline)
    .animation(.easeInOut, value: scrollOffset)
    .enableInjection()
  }
}

#Preview {
  ProfileScreenView()
}
