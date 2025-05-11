import AVFoundation
import SwiftUI

struct AudioPlayerView: View {
  let audioFileName: String
  let audioFileExtension: String
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
          if player == nil,
            let url = Bundle.main.url(
              forResource: audioFileName, withExtension: audioFileExtension,
            )
          {
            do {
              player = try AVAudioPlayer(contentsOf: url)
              player?.prepareToPlay()
            } catch {
              print("Error initializing audio player: \(error.localizedDescription)")
            }
          }
          player?.play()
        }
        isPlaying.toggle()
      }) {
        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
          .resizable()
          .foregroundColor(.black)
          .frame(width: 20.0, height: 20.0)
      }
      .padding(.leading, 12)

      WaveformView(waveform: waveform).frame(maxWidth: .infinity, maxHeight: 32)
    }
    .padding(12)
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
        let barCount = Int(geometry.size.width / (barWidth + 2))
        ForEach(0..<barCount, id: \.self) { idx in
          Capsule()
            .fill(Color.gray)
            .frame(
              width: barWidth,
              height: max(geometry.size.height * waveform[idx % waveform.count], 2)
            )
        }
      }
      .frame(height: geometry.size.height, alignment: .center)
    }
    .frame(height: 32)
  }
}

#Preview {
  AudioPlayerView(audioFileName: "willas-intro", audioFileExtension: "m4a").padding()
}
