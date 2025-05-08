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
    StoryAvatarView(username: "Willas")
      .onTapGesture {
        showStory = true
      }
      .fullScreenCover(isPresented: $showStory) {
        StoryView()
      }
  }
}

#Preview {
  ProfileView()
}
