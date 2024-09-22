//
//  NetworkService.swift
//  iTunes Demo
//
//  Created by Egor Naberezhnov on 18.09.2024.
//

import Foundation

protocol SongsInteractorProtocol {
    func fetchSongs(for keyword: String, page: Int, completion: @escaping (Result<[SongModel], Error>) -> Void)
}

class SongsInteractor: SongsInteractorProtocol {
    func fetchSongs(for keyword: String, page: Int = 1, completion: @escaping (Result<[SongModel], Error>) -> Void) {
        guard let url = URL(string: "https://itunes.apple.com/search?term=\(keyword)&entity=musicTrack&limit=20&offset=\(page * 20)") else {
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else { return }

            do {
                let searchResult = try JSONDecoder().decode(SearchResponse.self, from: data)
                completion(.success(searchResult.results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

struct SearchResponse: Codable {
    let results: [SongModel]
}
