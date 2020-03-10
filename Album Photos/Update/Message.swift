//
//  App.swift
//  Album Photos
//
//  Created by Benjamin Earley on 3/5/20.
//  Copyright © 2020 Benjamin Earley. All rights reserved.
//

import Foundation

protocol Message: Hashable {
}

enum AppMessage: Message {
    case album(message: AlbumMessage)
    case photo(message: PhotoMessage)
}

extension AppMessage: Hashable {
    public static func == (lhs: AppMessage, rhs: AppMessage) -> Bool {
        switch (lhs, rhs) {
        case let (.album(l), .album(r)): return l == r
        case let (.photo(l), .photo(r)): return l == r
        default: return false
        }
    }

    public func hash(into hasher: inout Hasher) {
        let val: Int
        switch self {
        case .album: val = 0
        case .photo: val = 1
        }
        hasher.combine(val)
    }
}

enum AlbumMessage {
    case setAlbumResults(albums: [Album])
    case setErrorResult(message: String)
    case getAlbums
}

extension AlbumMessage: Hashable {
    public static func == (lhs: AlbumMessage, rhs: AlbumMessage) -> Bool {
        switch (lhs, rhs) {
        case let (.setAlbumResults(l), .setAlbumResults(r)): return l == r
        case let (.setErrorResult(l), .setErrorResult(r)): return l == r
        case (.getAlbums, .getAlbums): return true
        default: return false
        }
    }

    public func hash(into hasher: inout Hasher) {
        let val: Int
        switch self {
        case .setAlbumResults: val = 0
        case .setErrorResult: val = 1
        case .getAlbums: val = 2
        }
        hasher.combine(val)
    }
}

enum PhotoMessage {
    case setPhotoResults(album: Album, photos: [Photo])
    case setErrorResult(message: String)
    case getPhotos(album: Album)
}

extension PhotoMessage: Hashable {
    public static func == (lhs: PhotoMessage, rhs: PhotoMessage) -> Bool {
        switch (lhs, rhs) {
        case let (.setPhotoResults(l), .setPhotoResults(r)): return l == r
        case let (.setErrorResult(l), .setErrorResult(r)): return l == r
        case (.getPhotos, .getPhotos): return true
        default: return false
        }
    }

    public func hash(into hasher: inout Hasher) {
        let val: Int
        switch self {
        case .setPhotoResults: val = 0
        case .setErrorResult: val = 1
        case .getPhotos: val = 2
        }
        hasher.combine(val)
    }
}


