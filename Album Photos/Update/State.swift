//
//  State.swift
//  Album Photos
//
//  Created by Benjamin Earley on 3/10/20.
//  Copyright © 2020 Benjamin Earley. All rights reserved.
//

struct AppState {
    var album: AlbumListState = AlbumListState.init()
    var photo: AlbumDetailState = AlbumDetailState.init()
}
