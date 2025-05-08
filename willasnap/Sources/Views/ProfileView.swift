//
//  StoryView.swift
//  willasnap
//
//  Created by Revanza Kurniawan on 07/05/25.
//

import SwiftUI

struct ProfileView: View {
  @State private var showStory = false

  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      HStack(alignment: .center, spacing: 16) {
        StoryAvatarView()
          .onTapGesture {
            showStory = true
          }
          .fullScreenCover(isPresented: $showStory) {
            StoryView()
          }
        VStack(alignment: .leading, spacing: 8) {
          Text("Willas Daniel Rorrong Lumban Tobing")
            .font(.title3)
            .frame(maxWidth: .infinity, alignment: .leading)
          Text("Machine Learning Enthusiast")
            .font(.subheadline)
            .foregroundColor(.gray)
        }
      }
      AudioPlayerView(audioURL: nil)
      Spacer()
    }
    .padding()
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}

#Preview {
  ProfileView()
}
