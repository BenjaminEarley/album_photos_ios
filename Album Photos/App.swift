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
    var album: AlbumState = AlbumState(network: .Loading)
    var photo: PhotoState = PhotoState(network: .Loading)
}

struct AlbumState {
    var network: Result<[Album]> = .Loading
    var cache: [Album] = []
}

struct PhotoState {
    var network: Result<[Photo]> = .Loading
    var cache: [Int: [Photo]] = [:]
}

enum AppAction {
    case album(action: AlbumAction)
    case photo(action: PhotoAction)
}

enum AlbumAction {
    case setAlbumResults(albums: [Album])
    case setErrorResult(message: String)
    case getAlbums
}

enum PhotoAction {
    case setPhotoResults(album: Album, photos: [Photo])
    case setErrorResult(message: String)
    case getPhotos(album: Album)
}

func appReducer(
        state: inout AppState,
        action: AppAction,
        environment: World
) -> AnyPublisher<AppAction, Never> {
    switch action {
    case let .album(albumAction):
        return AlbumReducer(&state.album, albumAction, environment).map {
            AppAction.album(action: $0)
        }.eraseToAnyPublisher()
    case let .photo(photoAction):
        return PhotoReducer(&state.photo, photoAction, environment).map {
            AppAction.photo(action: $0)
        }.eraseToAnyPublisher()
    }

}

func AlbumReducer(
        _ state: inout AlbumState,
        _ action: AlbumAction,
        _ environment: World
) -> AnyPublisher<AlbumAction, Never> {
    switch action {
    case .getAlbums:
        state.network = Result.Loading
        return environment.service
                .getAlbums()
                .map {
                    AlbumAction.setAlbumResults(albums: $0)
                }
                .replaceError(with: AlbumAction.setErrorResult(message: "Error Loading Photos"))
                .eraseToAnyPublisher()
    case let .setAlbumResults(album):
        state.network = .Success(value: album)
        state.cache = album
    case let .setErrorResult(message):
        state.network = .Error(reason: message)
    }
    return Empty().eraseToAnyPublisher()
}

func PhotoReducer(
        _ state: inout PhotoState,
        _ action: PhotoAction,
        _ environment: World
) -> AnyPublisher<PhotoAction, Never> {
    switch action {
    case let .getPhotos(album: album):
        state.network = Result.Loading
        return environment.service
                .getPhotos(album: album)
                .map {
                    PhotoAction.setPhotoResults(album: album, photos: $0)
                }
                .replaceError(with: PhotoAction.setErrorResult(message: "Error Loading Photos"))
                .eraseToAnyPublisher()
    case let .setPhotoResults(album, photos):
        state.network = .Success(value: photos)
        state.cache.updateValue(photos, forKey: album.id)
    case let .setErrorResult(message):
        state.network = .Error(reason: message)
    }
    return Empty().eraseToAnyPublisher()
}
