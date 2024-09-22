//
//  PlayerPresenter.swift
//  iTunes Demo
//
//  Created by Egor Naberezhnov on 22.09.2024.
//

import AVKit

class PlayerPresenter: ObservableObject {
    @Published var isPlaying: Bool = false
    @Published var currentTime: Double = 0
    private var player: AVPlayer?
    
    let song: Song

    init(song: Song) {
        self.song = song
        setupPlayer()
    }
    
    private func setupPlayer() {
        guard player == nil else { return }
          guard let url = URL(string: song.previewUrl ?? "") else { return }
          let playerItem = AVPlayerItem(url: url)
          player = AVPlayer(playerItem: playerItem)
          DispatchQueue.main.async {
              self.currentTime = self.player?.currentItem?.currentTime().seconds ?? 0.0
          }
    }
    
    func togglePlayPause() {
        if isPlaying {
            player?.pause()
        } else {
            player?.play()
        }
        isPlaying.toggle()
    }
    
    func stopPlayer() {
        player?.pause()
        player = nil
        isPlaying = false
    }
    
    func formatTime(seconds: Double) -> String {
        let minutes = Int(seconds) / 60
        let seconds = Int(seconds) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}
