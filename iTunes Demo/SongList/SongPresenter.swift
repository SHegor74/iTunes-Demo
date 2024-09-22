//
//  SongPresenter.swift
//  iTunes Demo
//
//  Created by Egor Naberezhnov on 18.09.2024.
//

import Foundation
import Combine

class SongsPresenter: ObservableObject {
    @Published var songs: [Song] = []
    @Published var isLoading: Bool = false
    private let interactor: SongsInteractorProtocol
    private var currentPage = 0
    private var currentKeyword = ""
    
    init(interactor: SongsInteractorProtocol) {
        self.interactor = interactor
    }
    
    func searchSongs(with keyword: String) {
        guard keyword.count >= 3 else { return }
        isLoading = true
        currentPage = 0
        currentKeyword = keyword
        interactor.fetchSongs(for: keyword, page: currentPage) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let songs):
                    self?.songs = songs
                case .failure(let error):
                    print("Error fetching songs: \(error)")
                }
            }
        }
    }
    
    func noSongs() {
        songs = []
    }
    
    func loadMoreSongs() {
        guard !isLoading, currentKeyword.count >= 3 else { return }
        isLoading = true
        currentPage += 1
        interactor.fetchSongs(for: currentKeyword, page: currentPage) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let moreSongs):
                    for song in moreSongs {
                        if !(self?.songs.contains(where: { $0.trackId == song.trackId }) ?? false) {
                            self?.songs.append(song)
                        }
                    }
                case .failure(let error):
                    print("Error fetching more songs: \(error)")
                }
            }
        }
    }
}
