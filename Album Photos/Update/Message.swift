//
//  App.swift
//  Album Photos
//
//  Created by Benjamin Earley on 3/5/20.
//  Copyright © 2020 Benjamin Earley. All rights reserved.
//

import Foundation

enum AppMessage {
    case selectedAlbum(album: Album?)
    case album(message: AlbumMessage)
    case photo(message: PhotoMessage)
}

enum AlbumMessage {
    case setAlbumResults(albums: [Album])
    case setErrorResult(message: String)
    case getAlbums
}

enum PhotoMessage {
    case setPhotoResults(album: Album, photos: [Photo])
    case setErrorResult(message: String)
    case getPhotos(album: Album)
}


