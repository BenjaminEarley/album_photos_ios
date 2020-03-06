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
        let albums = Array(store.state.albums.prefix(10))
        return AlbumList(
            albums: albums
        ).onAppear(perform: fetch)
    }

    private func fetch() {
        store.send(.getAlbums)
    }
}

struct AlbumList : View {
    let albums: [Album]

    var body: some View {
        List {
            if albums.isEmpty {
                Text("Loading...")
            } else {
                ForEach(albums) { album in
                    NavigationLink(destination: AlbumDetailContainer(album: album)) {
                        AlbumRow(album: album)
                    }
                }
            }
        }.navigationBarTitle("Albums")
    }
}

struct AlbumListView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumList(albums: albumData)
    }
}

