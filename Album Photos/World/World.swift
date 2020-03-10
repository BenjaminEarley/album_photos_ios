//
//  World.swift
//  Album Photos
//
//  Created by Benjamin Earley on 3/10/20.
//  Copyright © 2020 Benjamin Earley. All rights reserved.
//

protocol World {
    var service: AlbumService { get set }
}

struct AppWorld: World {
    var service: AlbumService = NetworkAlbumService()
}
