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
    var album: AlbumState = AlbumState(albums: [])
    var photo: PhotoState = PhotoState(photos: [:])
}

struct AlbumState {
    var albums: [Album] = []
}

struct PhotoState {
    var photos: [Int: [Photo]] = [:]
}

enum AppAction {
   case album(action: AlbumAction)
   case photo(action: PhotoAction)
}

enum AlbumAction {
    case setAlbumResults(albums: [Album])
    case getAlbums
}

enum PhotoAction {
    case setPhotoResults(album: Album, photos: [Photo])
    case getPhotos(album: Album)
}

func appReducer(
    state: inout AppState,
    action: AppAction,
    environment: World
) -> AnyPublisher<AppAction, Never> {
    switch action {
    case let .album(albumAction):
        return AlbumReducer(&state.album, albumAction, environment).map { AppAction.album(action: $0) }.eraseToAnyPublisher()
    case let .photo(photoAction):
        return PhotoReducer(&state.photo, photoAction, environment).map { AppAction.photo(action: $0) }.eraseToAnyPublisher()
    }
 
}

func AlbumReducer(
    _ state: inout AlbumState,
    _ action: AlbumAction,
    _ environment: World
    ) -> AnyPublisher<AlbumAction, Never> {
    switch action {
        case let .setAlbumResults(albums: albums):
            state.albums = albums
        case .getAlbums:
            return environment.service
                .getAlbums()
                .replaceError(with: [])
                .map { AlbumAction.setAlbumResults(albums: $0) }
                .eraseToAnyPublisher()
    }
    return Empty().eraseToAnyPublisher()
}

func PhotoReducer(
    _ state: inout PhotoState,
    _ action: PhotoAction,
    _ environment: World
    ) -> AnyPublisher<PhotoAction, Never> {
    switch action {
    case let .setPhotoResults(album, photos):
        state.photos.updateValue(photos, forKey: album.id)
    case let .getPhotos(album: album):
        return environment.service
            .getPhotos(album: album)
            .replaceError(with: [])
            .map { .setPhotoResults(album: album, photos: $0) }
            .eraseToAnyPublisher()
    }
    return Empty().eraseToAnyPublisher()
}
