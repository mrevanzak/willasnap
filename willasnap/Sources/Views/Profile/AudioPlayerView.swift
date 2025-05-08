import AVFoundation
import SwiftUI

struct AudioPlayerView: View {
  let audioURL: URL?
  @State private var isPlaying = false
  @State private var player: AVAudioPlayer?

  // Example static waveform data
  let waveform: [CGFloat] = [
    0.3, 0.7, 0.5, 1.0, 0.6, 0.8, 0.4, 0.9, 0.5, 0.7, 0.3, 0.6, 0.8, 0.5, 0.7,
  ]

  var body: some View {
    HStack(spacing: 16) {
      Button(action: {
        if isPlaying {
          player?.pause()
        } else {
          if player == nil, let url = audioURL {
            player = try? AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
          }
          player?.play()
        }
        isPlaying.toggle()
      }) {
        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
          .resizable()
		  .foregroundColor(.black)
		  .frame(width: /*@START_MENU_TOKEN@*/20.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/20.0/*@END_MENU_TOKEN@*/)
      }
      .padding(.leading, 12)

      WaveformView(waveform: waveform)
        .frame(maxWidth: .infinity)
	}
	.padding(12)
	.frame(maxWidth: .infinity, maxHeight: 56)
    .background(Color.gray.opacity(0.2))
    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
  }
}

struct WaveformView: View {
  let waveform: [CGFloat]
  private let barWidth: CGFloat = 4

  var body: some View {
    GeometryReader { geometry in
      HStack(alignment: .center, spacing: 2) {
        ForEach(0..<Int(geometry.size.width / (barWidth + 2)), id: \.self) { idx in
          Capsule()
            .fill(Color.gray)
            .frame(
              width: barWidth,
              height: 32 * waveform[idx % waveform.count]
            )
        }
      }
      .frame(maxWidth: .infinity)
    }
  }
}

#Preview {
	AudioPlayerView(audioURL: nil).padding()
}
