//
//  MockAlbumService.swift
//  Album Photos
//
//  Created by Benjamin Earley on 3/6/20.
//  Copyright © 2020 Benjamin Earley. All rights reserved.
//

import SwiftUI
import Combine

struct MockWorld: World {
    var service: AlbumService = MockAlbumService()
}

class MockAlbumService: AlbumService {
    func getAlbums(limit: Int) -> AnyPublisher<[Album], Error> {
        Just(albumData).setFailureType(to: Error.self).eraseToAnyPublisher()
    }

    func getPhotos(album: Album, limit: Int) -> AnyPublisher<[Photo], Error> {
        Just(photoData).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}
