//
//  AlbumDetails.swift
//  Album Photos
//
//  Created by Benjamin Earley on 3/5/20.
//  Copyright © 2020 Benjamin Earley. All rights reserved.
//

import SwiftUI

struct AlbumDetailContainer: View {
    let album: Album
    @EnvironmentObject var store: AppStore

    var body: some View {
        let photos = Array(store.state.photos[album.id]?.prefix(10) ?? ArraySlice<Photo>())
        return AlbumDetail(
            title: album.title,
            photos: photos
        ).onAppear(perform: fetch)
    }

    private func fetch() {
        store.send(.getPhotos(album: album))
    }
}

struct AlbumDetail : View {
    let title: String
    let photos: [Photo]

    var body: some View {
        List {
            if photos.isEmpty {
                Text("Loading...")
            } else {
                ForEach(photos) { photo in
                    PhotoRow(photo: photo)
                }
            }
        }.navigationBarTitle(Text(title), displayMode: .inline)
    }
}

struct AlbumDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumDetail(title: albumData[0].title, photos: photoData)
    }
}
