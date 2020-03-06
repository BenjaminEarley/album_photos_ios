//
//  AlbumService.swift
//  Album Photos
//
//  Created by Benjamin Earley on 3/5/20.
//  Copyright © 2020 Benjamin Earley. All rights reserved.
//
    
import Combine

protocol AlbumService {
    func getAlbums() -> AnyPublisher<[Album], Error>
    func getPhotos(album: Album) -> AnyPublisher<[Photo], Error>
}
