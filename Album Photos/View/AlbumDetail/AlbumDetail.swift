//
//  AlbumDetails.swift
//  Album Photos
//
//  Created by Benjamin Earley on 3/5/20.
//  Copyright © 2020 Benjamin Earley. All rights reserved.
//

import SwiftUI

struct AlbumDetailContainer: View {
    @EnvironmentObject var store: AppStore
    @State var uuid: UUID? = nil

    @ViewBuilder
    var body: some View {
        
        guard let album = store.state.albumSelected else {
            return Text("Error")
        }
        
        let photos = Array(store.state.photo.cache[album.id]?.prefix(10) ?? ArraySlice<Photo>())
        var isLoading = false
        var message: String = ""
        switch store.state.photo.network {
        case .Loading, .Uninitialized:
            if (photos.isEmpty) {
                isLoading = true
            }
        case .Error(let reason):
            if (photos.isEmpty) {
                message = reason
            }
        case .Success(_):
            if (photos.isEmpty) {
                message = "No Photos"
            }
        }
        return AlbumDetail(
                title: album.title,
                isLoading: isLoading,
                message: message,
                photos: photos
        )
            .onAppear {
                self.uuid = self.fetch(album: self.album)
            }
            .onDisappear {
                self.cancelFetch(byUuid: self.uuid)
            }
    }

    private func fetch(album: Album) -> UUID {
        return store.send(.photo(message: .getPhotos(album: album)))
    }
    private func cancelFetch(byUuid uuid: UUID?) {
        guard let id = uuid else {
            return
        }
        store.clearSideEffect(byUuid: id)
    }
}

struct AlbumDetail: View {
    let title: String
    let isLoading: Bool
    let message: String
    let photos: [Photo]

    var body: some View {
        List {
            if !photos.isEmpty {
                ForEach(photos) { photo in
                    PhotoRow(photo: photo)
                }
            } else if isLoading {
                Loading()
            } else if message != "" {
                Text(message)
            }
        }.navigationBarTitle(Text(title), displayMode: .inline)
    }
}

struct AlbumDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumDetail(title: albumData[0].title, isLoading: false, message: "", photos: photoData)
    }
}
