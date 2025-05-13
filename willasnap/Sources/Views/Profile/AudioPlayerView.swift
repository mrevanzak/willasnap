import AVFoundation
import SwiftUI

struct AudioPlayerView: View {
  let audioFileName: String
  let audioFileExtension: String
  @State private var isPlaying = false
  @State private var player: AVAudioPlayer?
  @State private var progress: Double = 0.0
  @State private var timer: Timer?

  // Example static waveform data
  let waveform: [CGFloat] = [
    0.3, 0.7, 0.5, 1.0, 0.6, 0.8, 0.4, 0.9, 0.5, 0.7, 0.3, 0.6, 0.8, 0.5, 0.7,
  ]

  var body: some View {
    HStack(spacing: 16) {
      Button(action: {
        if isPlaying {
          player?.pause()
          timer?.invalidate()
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
          startTimer()
        }
        isPlaying.toggle()
      }) {
        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
          .resizable()
          .foregroundColor(.primary)
          .frame(width: 20.0, height: 20.0)
      }

      WaveformView(waveform: waveform, progress: progress)
    }
    .padding(.horizontal, 16.0)
    .padding(.vertical, 8.0)
    .background(Color(.systemGray6))
    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    .onDisappear {
      timer?.invalidate()
      player?.stop()
    }
  }

  private func startTimer() {
    timer?.invalidate()
    timer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { _ in
      guard let player = player else { return }
      progress = player.duration > 0 ? player.currentTime / player.duration : 0
      if !player.isPlaying {
        isPlaying = false
        timer?.invalidate()
      }
    }
  }
}

struct WaveformView: View {
  let waveform: [CGFloat]
  var progress: Double = 0.0
  private let barWidth: CGFloat = 4

  var body: some View {
    GeometryReader { geometry in
      let barCount = Int(geometry.size.width / (barWidth + 2))
      let progressBars = Int(Double(barCount) * progress)
      HStack(alignment: .center, spacing: 2) {
        ForEach(0..<barCount, id: \.self) { idx in
          Capsule()
            .fill(idx < progressBars ? Color.secondary : Color.gray.opacity(0.4))
            .frame(
              width: barWidth,
              height: max(geometry.size.height * waveform[idx % waveform.count], 2)
            )
        }
      }
      .frame(height: geometry.size.height, alignment: .center)
    }
    .frame(height: 24)
  }
}

#Preview {
  AudioPlayerView(audioFileName: "willas-intro", audioFileExtension: "m4a").padding()
}
