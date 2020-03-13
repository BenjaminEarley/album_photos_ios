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
    @State var uuid: UUID? = nil
    @State private var query: String = ""

    var body: some View {
        let cache = store.state.photo.cache[album.id] ?? [Photo]()
        let photos = cache.filter {
            if query == "" {
                return true
            } else {
                return $0.title.localizedCaseInsensitiveContains(query)
            }
        }
        var isLoading = false
        var message: String = ""

        if (photos.isEmpty) {
            isLoading = store.state.photo.isLoading
            message = store.state.photo.error ?? "No Photos"
        }
        return AlbumDetail(
                title: album.title,
                isLoading: isLoading,
                message: message,
                photos: photos,
                query: $query
        )
                .onAppear {
                    self.uuid = self.fetch()
                }
                .onDisappear {
                    self.cancelFetch(byUuid: self.uuid)
                }
    }

    private func fetch() -> UUID {
        store.send(.photo(message: .getPhotos(album: album)))
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

    @Binding var query: String

    var body: some View {
        List {

            TextField("Search", text: $query)

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
        Group {
            AlbumDetail(title: "", isLoading: false, message: "", photos: photoData, query: Binding.constant(""))
                    .previewDisplayName("Loaded Photo Data")
            AlbumDetail(title: "", isLoading: false, message: "No Photos", photos: [Photo](), query: Binding.constant(""))
                    .previewDisplayName("Loaded Empty Photo Data")
            AlbumDetail(title: "", isLoading: true, message: "", photos: [], query: Binding.constant(""))
                    .previewDisplayName("Loading")
            AlbumDetail(title: "", isLoading: false, message: "Error", photos: [], query: Binding.constant(""))
                    .previewDisplayName("Error")
        }

    }
}
