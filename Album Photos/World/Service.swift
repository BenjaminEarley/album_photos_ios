//
//  NetworkAlbumService.swift
//  Album Photos
//
//  Created by Benjamin Earley on 3/6/20.
//  Copyright © 2020 Benjamin Earley. All rights reserved.
//

import SwiftUI
import Combine

protocol AlbumService {
    func getAlbums() -> AnyPublisher<[Album], Error>
    func getPhotos(album: Album) -> AnyPublisher<[Photo], Error>
}

class NetworkAlbumService: AlbumService {
    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared, decoder: JSONDecoder = .init()) {
        self.session = session
        self.decoder = decoder
    }

    func getAlbums() -> AnyPublisher<[Album], Error> {
        guard
                let urlComponents = URLComponents(string: "https://jsonplaceholder.typicode.com/albums")
                else {
            preconditionFailure("Can't create url components...")
        }

        guard
                let url = urlComponents.url
                else {
            preconditionFailure("Can't create url from url components...")
        }

        return session
                .dataTaskPublisher(for: url)
                .map {
                    $0.data
                }
                .decode(type: [Album].self, decoder: decoder)
                .eraseToAnyPublisher()
    }

    func getPhotos(album: Album) -> AnyPublisher<[Photo], Error> {
        guard
                let urlComponents = URLComponents(string: "https://jsonplaceholder.typicode.com/albums/\(album.id)/photos")
                else {
            preconditionFailure("Can't create url components...")
        }

        guard
                let url = urlComponents.url
                else {
            preconditionFailure("Can't create url from url components...")
        }

        return session
                .dataTaskPublisher(for: url)
                .map {
                    $0.data
                }
                .decode(type: [Photo].self, decoder: decoder)
                .eraseToAnyPublisher()
    }

}
