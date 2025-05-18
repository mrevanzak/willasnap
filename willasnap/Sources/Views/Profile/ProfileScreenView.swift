//
//  StoryView.swift
//  willasnap
//
//  Created by Revanza Kurniawan on 07/05/25.
//

import AVFoundation
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
  let location = "Palu, Indonesia"
  let interests = ["AI", "Coding", "Photography", "Chess"]
  let favoriteQuote = "Stay curious, keep learning."
  let socialLinks: [(icon: String, url: String)] = [
    ("link", "https://linkedin.com/in/willasdaniel"),
    ("logo.github", "https://github.com/willasdaniel"),
  ]

  var normalizedProgress: CGFloat {
    let dynamicIslandDistance: CGFloat = -25.0
    let calculatedOffset = min(0, max(scrollOffset, dynamicIslandDistance))
    return abs(calculatedOffset / dynamicIslandDistance)
  }
  // Sample data for new sections
  let aboutMe =
    "Hi! I'm Willas, passionate about AI, coding, and sharing knowledge. I love building things that make life easier and more fun. When I'm not coding, you'll find me exploring new tech, playing chess, or capturing moments with my camera."
  let education = "Informatics @Universitas Ciputra Surabaya"
  let languages = "Indonesian, English"

  let skills = [
    "MachineLearning", "Swift", "Python", "iOS", "Photography", "Chess", "PublicSpeaking",
  ]
  let contactEmail = "willytobs@gmail.com"
  let contactPhone = "+62 822 5967 2632"
  let instagram = "@willastobing"
  let linkedin = "www.linkedin.com/in/willastobing"

  var body: some View {
    NavigationStack {
      ZStack {
        LinearGradient(
          gradient: Gradient(stops: [
            .init(color: Color.black, location: 0.05),
            .init(color: Color(red: 0.10, green: 0.18, blue: 0.40), location: 0.3),  // deep blue top
            .init(color: Color(red: 0.18, green: 0.32, blue: 0.70), location: 0.7),  // ultra blue mid
            .init(color: Color(red: 0.36, green: 0.54, blue: 0.98), location: 1.0),  // electric blue bottom
          ]),
          startPoint: .top,
          endPoint: .bottom
        )
        .blur(radius: 90, opaque: true)
        .ignoresSafeArea()

        ScrollView {
          VStack(alignment: .center, spacing: 24) {
            // Profile Image + Name
            VStack(alignment: .center, spacing: 10) {
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
              Button(action: {
                withAnimation { showFullName.toggle() }
                typingTimer?.invalidate()
                if showFullName {
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
              }) {
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                  Text(displayedName)
                    .lineLimit(1)
                    .font(.title2.bold())
                    .foregroundStyle(
                      LinearGradient(
                        colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing)
                    )
                  if !showFullName {
                    Image(systemName: "ellipsis")
                      .font(.caption)
                      .foregroundColor(.secondary)
                  }
                }
              }
              .buttonStyle(.borderless)
              .accessibilityLabel("Toggle full name")
              Text("Machine Learning Enthusiast")
                .font(.subheadline)
                .foregroundColor(.gray)
            }

            // Audio Intro
            AudioPlayerView(audioFileName: "willas-intro", audioFileExtension: "m4a")
              .background(
                RoundedRectangle(cornerRadius: 16)
                  .fill(Color(.systemGray6).opacity(0.95))
              )

            // About Me
            VStack(alignment: .leading, spacing: 8) {
              Text("About Me")
                .font(.headline)
              Text(aboutMe)
                .font(.body)
                .foregroundColor(.primary)
            }
            .padding()
            .background(
              RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray6).opacity(0.95))
            )

            // Personal Info
            VStack(alignment: .leading, spacing: 10) {
              Text("Personal Info")
                .font(.headline)
              HStack {
                Image(systemName: "birthday.cake").foregroundColor(.blue).frame(width: 20)
                Text("Date of Birth:").font(.subheadline).foregroundColor(.secondary)
                Spacer()
                Text("16 April 2005").font(.subheadline)
              }
              HStack {
                Image(systemName: "mappin.and.ellipse").foregroundColor(.red).frame(width: 20)
                Text("Hometown:").font(.subheadline).foregroundColor(.secondary)
                Spacer()
                Text(location).font(.subheadline)
              }
              HStack {
                Image(systemName: "graduationcap").foregroundColor(.purple).frame(width: 20)
                Text("Education:").font(.subheadline).foregroundColor(.secondary)
                Spacer()
                Text(education).font(.subheadline).multilineTextAlignment(.trailing)
              }
              HStack {
                Image(systemName: "globe").foregroundColor(.green).frame(width: 20)
                Text("Languages:").font(.subheadline).foregroundColor(.secondary)
                Spacer()
                Text(languages).font(.subheadline)
              }
            }
            .padding()
            .background(
              RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray6).opacity(0.95))
            )

            // Skills / Tags
            VStack(alignment: .leading, spacing: 8) {
              Text("Skills / Tags")
                .font(.headline)
              WrapHStack(tags: skills)
            }
            .padding()
            .background(
              RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray6).opacity(0.95))
            )

            // Contact / Social
            VStack(alignment: .leading, spacing: 8) {
              Text("Contact / Social")
                .font(.headline)
              HStack(spacing: 12) {
                Image(systemName: "envelope").foregroundColor(.blue)
                Spacer()
                Text(contactEmail).font(.subheadline)
              }
              HStack(spacing: 12) {
                Image(systemName: "phone").foregroundColor(.green)
                Text(contactPhone).font(.subheadline)
              }
              HStack(spacing: 12) {
                Image(systemName: "camera").foregroundColor(.purple)
                Text(instagram).font(.subheadline)
              }
              HStack(spacing: 12) {
                Image(systemName: "link").foregroundColor(.blue)
                Link(linkedin, destination: URL(string: "https://" + linkedin)!)
                  .font(.subheadline)
              }
            }
            .padding()
            .background(
              RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray6).opacity(0.95))
            )
          }
          .padding(.vertical, 16)
        }
        .coordinateSpace(name: "scroll")
      }
      .overlay(alignment: .top) {
        Rectangle()
          .fill(Color.black)
          .frame(height: 15)
          .ignoresSafeArea()
      }
      .contentMargins(.horizontal, 16, for: .scrollContent)
      .navigationTitle(fullName)
      .navigationBarTitleDisplayMode(.inline)
      .toolbar(scrollOffset > -140 ? .hidden : .visible, for: .navigationBar)
      .animation(.easeInOut, value: scrollOffset)
    }
  }
}

#Preview {
  ProfileScreenView()
}

// MARK: - Tag Wrapping Helper
struct WrapHStack: View {
  let tags: [String]
  var body: some View {
    var width = CGFloat.zero
    var height = CGFloat.zero
    return GeometryReader { geometry in
      ZStack(alignment: .topLeading) {
        ForEach(tags, id: \.self) { tag in
          Text("#" + tag)
            .font(.caption)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(Color.blue.opacity(0.15))
            .clipShape(Capsule())
            .padding([.horizontal, .vertical], 2)
            .alignmentGuide(.leading) { d in
              if abs(width - d.width) > geometry.size.width {
                width = 0
                height -= d.height
              }
              let result = width
              if tag == tags.last! {
                width = 0  // Last item
              } else {
                width -= d.width
              }
              return result
            }
            .alignmentGuide(.top) { _ in
              let result = height
              if tag == tags.last! {
                height = 0  // Last item
              }
              return result
            }
        }
      }
    }
    .frame(height: 40)
  }
}
