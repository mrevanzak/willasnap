//
//  StoryView.swift
//  willasnap
//
//  Created by Revanza Kurniawan on 07/05/25.
//

import SwiftUI

struct StoryScreenView: View {
  @Environment(\.dismiss) private var dismiss

  var body: some View {
    GeometryReader { geometry in
      GrainyGradientView(gradientColors: [Color.purple.opacity(0.8), Color.blue.opacity(0.6)])
        .ignoresSafeArea()

      VStack {
        // Story header
        HStack(spacing: 16) {
          Circle()
            .fill(.white.opacity(0.2))
            .frame(width: 32, height: 32)

          Text("Your Story")
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(.white)

          Spacer()

          Button(action: { dismiss() }) {
            Image(systemName: "xmark")
              .foregroundColor(.white)
              .font(.system(size: 20, weight: .semibold))
          }
        }
        .padding()

        Spacer()
      }
    }
  }
}

#Preview {
  StoryScreenView()
}
