//
//  NetworkAlbumService.swift
//  Album Photos
//
//  Created by Benjamin Earley on 3/6/20.
//  Copyright © 2020 Benjamin Earley. All rights reserved.
//

import UIKit
import Combine

protocol AlbumService {
    func getAlbums(limit: Int) -> AnyPublisher<[Album], Error>
    func getPhotos(album: Album, limit: Int) -> AnyPublisher<[Photo], Error>
}

struct NetworkPhoto: Codable, Hashable, Identifiable {
    var id: Int
    var albumId: Int
    var title: String
    var thumbnailUrl: String
}

struct NetworkUrlPhoto: Codable, Hashable, Identifiable {
    var id: Int
    var albumId: Int
    var title: String
    var thumbnailUrl: URL
}

class NetworkAlbumService: AlbumService {
    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared, decoder: JSONDecoder = .init()) {
        self.session = session
        self.decoder = decoder
    }

    func getAlbums(limit: Int) -> AnyPublisher<[Album], Error> {
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
                .map {
                    Array($0.prefix(limit))
                }
                .eraseToAnyPublisher()
    }

    func getPhotos(album: Album, limit: Int) -> AnyPublisher<[Photo], Error> {
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
                .decode(type: [NetworkPhoto].self, decoder: decoder)
                .map {
                    $0.compactMap { networkPhoto in
                        URLComponents(string: networkPhoto.thumbnailUrl)?.url.map { url in
                            NetworkUrlPhoto(id: networkPhoto.id, albumId: networkPhoto.albumId, title: networkPhoto.title, thumbnailUrl: url)
                        }
                    }
                }
                .map {
                    Array($0.prefix(limit))
                }
                .flatMap(maxPublishers: .max(limit + 1)) { (networkUrlPhotos: [NetworkUrlPhoto]) -> AnyPublisher<[Photo], Error> in
                    let initialValue = networkUrlPhotos.map {
                        Photo(id: $0.id, albumId: $0.albumId, title: $0.title, image: UIImage())
                    }
                    return Publishers
                            .MergeMany(networkUrlPhotos.map { networkUrlPhotos in
                                self.session
                                        .dataTaskPublisher(for: networkUrlPhotos.thumbnailUrl)
                                        .mapError {
                                            $0 as Error
                                        }
                                        .map {
                                            Photo(
                                                    id: networkUrlPhotos.id,
                                                    albumId: networkUrlPhotos.albumId,
                                                    title: networkUrlPhotos.title,
                                                    image: imageFromData($0.data)
                                            )
                                        }
                            })
                            .scan(initialValue) { photos, newPhoto in
                                update(photos, with: newPhoto)
                            }
                            .prepend(initialValue)
                            .eraseToAnyPublisher()
                }
                .eraseToAnyPublisher()
    }
}

func imageFromData(_ data: Data) -> UIImage {
    UIImage(data: data) ?? UIImage()
}

func update<T: Identifiable>(_ list: [T], with newItem: T) -> [T] {
    let index = list.firstIndex(where: { $0.id == newItem.id })!
    var mutatedList = list
    mutatedList[index] = newItem
    return mutatedList
}
