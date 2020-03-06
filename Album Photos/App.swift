//
//  App.swift
//  Album Photos
//
//  Created by Benjamin Earley on 3/5/20.
//  Copyright © 2020 Benjamin Earley. All rights reserved.
//

import Foundation
import Combine

protocol World {
    var service: AlbumService { get set }
}

struct AppWorld: World {
    var service: AlbumService = NetworkAlbumService()
}

typealias AppStore = Store<AppState, AppAction, World>

struct AppState {
    var albums: [Album] = []
    var photos: [Int: [Photo]] = [:]
}

enum AppAction {
    case setAlbumResults(albums: [Album])
    case getAlbums
    case setPhotoResults(album: Album, photos: [Photo])
    case getPhotos(album: Album)
}

func appReducer(
    state: inout AppState,
    action: AppAction,
    environment: World
) -> AnyPublisher<AppAction, Never> {
    switch action {
    case let .setAlbumResults(albums):
        state.albums = albums
    case .getAlbums:
        return environment.service
            .getAlbums()
            .replaceError(with: [])
            .map { AppAction.setAlbumResults(albums: $0) }
            .eraseToAnyPublisher()
    case let .setPhotoResults(album, photos):
        state.photos.updateValue(photos, forKey: album.id)
    case let .getPhotos(album):
        return environment.service
            .getPhotos(album: album)
            .replaceError(with: [])
            .map { AppAction.setPhotoResults(album: album, photos: $0) }
            .eraseToAnyPublisher()
    }
    return Empty().eraseToAnyPublisher()
}
