//
//  ContentView.swift
//  Album Photos
//
//  Created by Benjamin Earley on 3/5/20.
//  Copyright © 2020 Benjamin Earley. All rights reserved.
//

import SwiftUI

struct AlbumListContainer: View {
    @EnvironmentObject var store: AppStore

    var body: some View {
        let albums = Array(store.state.album.cache.prefix(10))
        var isLoading = false
        var message: String = ""
        switch store.state.album.network {
        case .Loading, .Uninitialized:
            if (albums.isEmpty) {
                isLoading = true
            }
        case .Error(let reason):
            if (albums.isEmpty) {
                message = reason
            }
        case .Success(_):
            if (albums.isEmpty) {
                message = "No Photos"
            }
        }
        return AlbumList(
                isLoading: isLoading,
                message: message,
                albums: albums
        ) { album in
            self.openDetail(album: album)
        }.onAppear(perform: fetch)
    }

    private func fetch() {
        store.send(.album(message: .getAlbums))
    }
    
    private func openDetail(album: Album) {
        store.send(.selectedAlbum(album: album))
    }
}

struct AlbumList: View {
    let isLoading: Bool
    let message: String
    let albums: [Album]
    let onTap: (Album) -> Void

    var body: some View {
        List {
            if !albums.isEmpty {
                ForEach(albums) { album in
                    AlbumRow(album: album)
                        .onTapGesture { self.onTap(album) }
                }
            } else if isLoading {
                Loading()
            } else if message != "" {
                Text(message)
            }
        }.navigationBarTitle("Albums")
    }
}

struct AlbumListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AlbumList(isLoading: false, message: "", albums: albumData, onTap: { _ in })
                    .previewDisplayName("Loaded Album Data")
            AlbumList(isLoading: true, message: "", albums: [], onTap: { _ in })
                    .previewDisplayName("Loading")
            AlbumList(isLoading: false, message: "Error", albums: [], onTap: { _ in })
                    .previewDisplayName("Error")
        }

    }
}

