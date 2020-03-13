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
        let albums = store.state.album.cache
        var isLoading = false
        var message: String = ""

        if (albums.isEmpty) {
            isLoading = store.state.album.isLoading
            message = store.state.album.error ?? "No Albums"
        }

        return AlbumList(
                isLoading: isLoading,
                message: message,
                albums: albums
        ).onAppear(perform: fetch)
    }

    private func fetch() {
        store.send(.album(message: .getAlbums))
    }
}

struct AlbumList: View {
    let isLoading: Bool
    let message: String
    let albums: [Album]

    var body: some View {
        List {
            if !albums.isEmpty {
                ForEach(albums) { album in
                    NavigationLink(destination: AlbumDetailContainer(album: album)) {
                        AlbumRow(album: album)
                    }
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
            AlbumList(isLoading: false, message: "", albums: albumData)
                    .previewDisplayName("Loaded Album Data")
            AlbumList(isLoading: false, message: "No Albums", albums: [Album]())
                    .previewDisplayName("Loaded Empty Album Data")
            AlbumList(isLoading: true, message: "", albums: [])
                    .previewDisplayName("Loading")
            AlbumList(isLoading: false, message: "Error", albums: [])
                    .previewDisplayName("Error")
        }

    }
}

