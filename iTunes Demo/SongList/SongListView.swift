//
//  SongView.swift
//  iTunes Demo
//
//  Created by Egor Naberezhnov on 18.09.2024.
//

import SwiftUI

struct SongsListView: View {
    @ObservedObject var presenter: SongsPresenter
    @State private var searchText: String = ""

    var body: some View {
        NavigationView {
            VStack {
                // Поле для поиска
                TextField("Search for songs", text: $searchText, onCommit: {
                    presenter.searchSongs(with: searchText)
                })
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                
                List {
                    ForEach(presenter.songs) { song in
                        NavigationLink(destination: PlayerView(song: song)) {
                            SongRow(song: song)
                        }
                        .onAppear {
                            // Проверяем, если песня - последняя в списке, загружаем больше
                            if song == presenter.songs.last && !presenter.isLoading {
                                presenter.loadMoreSongs()
                            }
                        }
                    }
                    
                    // Показать индикатор загрузки при подгрузке новых данных
                    if presenter.isLoading {
                        HStack {
                            Spacer()
                            ProgressView("Loading more songs...")
                            Spacer()
                        }
                    }
                }
                .onAppear {
                    // Загружаем начальные данные при первом запуске
                    presenter.searchSongs(with: searchText)
                }
                .onChange(of: searchText) { newValue in
                    if newValue.count >= 3 {
                        presenter.searchSongs(with: newValue)
                    } else {
                        presenter.noSongs()
                    }
                }
            }
            .navigationTitle("Songs")
        }
    }
}

struct SongRow: View {
    let song: Song

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: song.artworkUrl100))
                .frame(width: 60, height: 60)
                .cornerRadius(8)
            VStack(alignment: .leading) {
                Text(song.trackName).font(.headline)
                Text(song.artistName).font(.subheadline).foregroundColor(.gray)
            }
        }
    }
}
