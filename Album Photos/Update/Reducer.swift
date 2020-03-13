//
//  Update.swift
//  Album Photos
//
//  Created by Benjamin Earley on 3/10/20.
//  Copyright © 2020 Benjamin Earley. All rights reserved.
//

import Combine

typealias Reducer<State, Message, Environment> =
        (inout State, Message, Environment) -> AnyPublisher<Message, Never>

func appReducer(
        state: inout AppState,
        message: AppMessage,
        environment: World
) -> AnyPublisher<AppMessage, Never> {
    switch message {
    case let .album(albumMessage):
        return AlbumReducer(&state.album, albumMessage, environment).map {
            AppMessage.album(message: $0)
        }.eraseToAnyPublisher()
    case let .photo(photoMessage):
        return PhotoReducer(&state.photo, photoMessage, environment).map {
            AppMessage.photo(message: $0)
        }.eraseToAnyPublisher()
    }

}

func AlbumReducer(
        _ state: inout AlbumState,
        _ message: AlbumMessage,
        _ environment: World
) -> AnyPublisher<AlbumMessage, Never> {
    switch message {
    case .getAlbums:
        state.isLoading = true
        return environment.service
                .getAlbums(limit: 10)
                .map {
                    AlbumMessage.setAlbumResults(albums: $0)
                }
                .replaceError(with: AlbumMessage.setErrorResult(message: "Error Loading Photos"))
                .eraseToAnyPublisher()
    case let .setAlbumResults(albums):
        state.isLoading = false
        state.error = nil
        state.cache = albums
    case let .setErrorResult(message):
        state.isLoading = false
        state.error = message
    }
    return Empty().eraseToAnyPublisher()
}

func PhotoReducer(
        _ state: inout PhotoState,
        _ message: PhotoMessage,
        _ environment: World
) -> AnyPublisher<PhotoMessage, Never> {
    switch message {
    case let .getPhotos(album: album):
        state.isLoading = true
        return environment.service
                .getPhotos(album: album, limit: 10)
                .map {
                    PhotoMessage.setPhotoResults(album: album, photos: $0)
                }
                .replaceError(with: PhotoMessage.setErrorResult(message: "Error Loading Photos"))
                .eraseToAnyPublisher()
    case let .setPhotoResults(album, photos):
        state.isLoading = false
        state.error = nil
        state.cache.updateValue(photos, forKey: album.id)
    case let .setErrorResult(message):
        state.isLoading = false
        state.error = message
    }
    return Empty().eraseToAnyPublisher()
}
