//
//  State.swift
//  Album Photos
//
//  Created by Benjamin Earley on 3/10/20.
//  Copyright © 2020 Benjamin Earley. All rights reserved.
//

struct AppState {
    var albumSelected: Album?
    var album: AlbumState = AlbumState.init()
    var photo: PhotoState = PhotoState.init()
}

struct AlbumState {
    var network: Result<[Album]> = .Uninitialized
    var cache: [Album] = []
}

struct PhotoState {
    var network: Result<[Photo]> = .Uninitialized
    var cache: [Int: [Photo]] = [:]
}
