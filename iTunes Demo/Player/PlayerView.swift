////
////  PlayerView.swift
////  iTunes Demo
////
////  Created by Egor Naberezhnov on 18.09.2024.
////
//
//import SwiftUI
//import AVKit
//
//struct PlayerView: View {
//    let song: Song
//    @State private var isPlaying: Bool = false
//    @State private var player: AVPlayer?
//    @State private var currentTime: Double = 0    
//    
//    var body: some View {
//        ZStack {
//            Color(red: 0.7, green: 0.85, blue: 1.0)
//                .ignoresSafeArea()
//            
//            VStack {
//                AsyncImage(url: URL(string: song.artworkUrl100)) { phase in
//                    if let image = phase.image {
//                        image.resizable()
//                            .scaledToFill()
//                            .frame(width: 200, height: 200)
//                            .cornerRadius(8)
//                    } else {
//                        Image("noImage")
//                            .scaledToFill()
//                            .frame(width: 200, height: 200)
//                            .cornerRadius(8)
//                    }
//                }
//                .padding()
//                
//                Text(song.trackName)
//                    .font(.title)
//                    .lineLimit(3)
//                    .padding(.top)
//                
//                Text(song.artistName)
//                    .font(.headline)
//                    .foregroundColor(.gray)
//                    .lineLimit(3)
//                
//                Slider(value: $currentTime, in: 0 ... song.trackDurationInSeconds)
//                    .padding()
//                    .accentColor(.blue) // Цвет прогресс-бара
//                    .onAppear {
//                        customizeSliderThumb()
//                    }
//                
//                HStack {
//                    // Лейбл для текущего времени
//                    Text(formatTime(seconds: currentTime))
//                        .foregroundColor(.white)
//                    
//                    // Лейбл для оставшегося времени
//                    Spacer()
//                    
//                    Text(formatTime(seconds: song.trackDurationInSeconds))
//                        .foregroundColor(.white)
//                }
//                .padding(.horizontal)
//                
//                // Кнопка Play/Pause с анимацией
//                Button(action: {
//                    togglePlayPause()
//                }) {
//                    ZStack {
//                        Circle()
//                            .fill(Color.white)
//                            .frame(width: 70, height: 70)
//                            .scaleEffect(isPlaying ? 1.0 : 1.0)
//                        
//                        Image(systemName: isPlaying ? "pause" : "play.fill")
//                            .foregroundColor(Color(red: 0.7, green: 0.85, blue: 1.0))
//                            .font(.system(size: 30, weight: .bold))
//                    }
//                }
//            }
//        }
//        .onAppear {
//            setupPlayer()
//        }
//        .onReceive(Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()) { _ in
//            DispatchQueue.main.async {
//                updateProgress()
//            }
//        }
//        .onDisappear {
//            stopPlayer() // Останавливаем плеер при уходе с экрана
//        }
//    }
//    
//    // Установка AVPlayer и мониторинг прогресса
//    func setupPlayer() {
//        guard player == nil else { return }
//        guard let url = URL(string: song.previewUrl ?? "") else { return }
//        let playerItem = AVPlayerItem(url: url)
//        player = AVPlayer(playerItem: playerItem)
//        DispatchQueue.main.async {
//            currentTime = player?.currentItem?.currentTime().seconds ?? 0.0
//        }
//    }
//    
//    // Останавливаем плеер
//    func stopPlayer() {
//        player?.pause()
//        player = nil
//        isPlaying = false
//    }
//    
//    private func updateProgress() {
//        guard let player = player else { return }
//        currentTime = player.currentItem?.currentTime().seconds ?? 0
//    }
//    
//    // Управление воспроизведением/паузой
//    func togglePlayPause() {
//        if isPlaying {
//            player?.pause()
//        } else {
//            player?.play()
//        }
//        withAnimation(.easeInOut(duration: 0.1)) {
//            isPlaying.toggle()
//        }
//    }
//    
//    func customizeSliderThumb() {
//        UISlider.appearance().thumbTintColor = UIColor.blue
//        UISlider.appearance().setThumbImage(UIImage(systemName: "circle.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 12)), for: .normal)
//    }
//    
//    func formatTime(seconds: Double) -> String {
//        let minutes = Int(seconds) / 60
//        let seconds = Int(seconds) % 60
//        return String(format: "%d:%02d", minutes, seconds)
//    }
//}

import SwiftUI

struct PlayerView: View {
    @StateObject private var presenter: PlayerPresenter
    
    init(song: Song) {
        _presenter = StateObject(wrappedValue: PlayerPresenter(song: song))
    }
    
    var body: some View {
        ZStack {
            Color(red: 0.7, green: 0.85, blue: 1.0)
                .ignoresSafeArea()
            
            VStack {
                AsyncImage(url: URL(string: presenter.song.artworkUrl100)) { phase in
                    if let image = phase.image {
                        image.resizable()
                            .scaledToFill()
                            .frame(width: 200, height: 200)
                            .cornerRadius(8)
                    } else {
                        Image("noImage")
                            .scaledToFill()
                            .frame(width: 200, height: 200)
                            .cornerRadius(8)
                    }
                }
                .padding()
                
                Text(presenter.song.trackName)
                    .font(.title)
                    .lineLimit(3)
                    .padding(.top)
                
                Text(presenter.song.artistName)
                    .font(.headline)
                    .foregroundColor(.gray)
                    .lineLimit(3)
                
                Slider(value: $presenter.currentTime, in: 0 ... presenter.song.trackDurationInSeconds)
                    .padding()
                    .accentColor(.blue)
                    .onAppear {
                        customizeSliderThumb()
                    }
                
                HStack {
                    Text(presenter.formatTime(seconds: presenter.currentTime))
                        .foregroundColor(.white)
                    Spacer()
                    Text(presenter.formatTime(seconds: presenter.song.trackDurationInSeconds))
                        .foregroundColor(.white)
                }
                .padding(.horizontal)
                
                Button(action: {
                    presenter.togglePlayPause()
                }) {
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 70, height: 70)
                        
                        Image(systemName: presenter.isPlaying ? "pause" : "play.fill")
                            .foregroundColor(Color(red: 0.7, green: 0.85, blue: 1.0))
                            .font(.system(size: 30, weight: .bold))
                    }
                }
            }
        }
        .onDisappear {
            presenter.stopPlayer()
        }
    }
    
    func customizeSliderThumb() {
        UISlider.appearance().thumbTintColor = UIColor.blue
        UISlider.appearance().setThumbImage(UIImage(systemName: "circle.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 12)), for: .normal)
    }
    

}
