//
//  State.swift
//  Album Photos
//
//  Created by Benjamin Earley on 3/10/20.
//  Copyright © 2020 Benjamin Earley. All rights reserved.
//

struct AppState {
    var album: AlbumState = AlbumState.init()
    var photo: PhotoState = PhotoState.init()
}

struct AlbumState {
    var isLoading: Bool = false
    var error: String? = nil
    var cache: [Album] = []
}

struct PhotoState {
    var isLoading: Bool = false
    var error: String? = nil
    var cache: [Int: [Photo]] = [:]
}
