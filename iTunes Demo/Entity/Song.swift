//
//  SongModel.swift
//  iTunes Demo
//
//  Created by Egor Naberezhnov on 18.09.2024.
//

import Foundation

struct Song: Codable, Identifiable {
    var id: Int {
        trackId
    }
    let trackId: Int
    let trackName: String
    let artistName: String
    let artworkUrl100: String
    let previewUrl: String?
}

struct SearchResponse: Codable {
    let results: [Song]
}

