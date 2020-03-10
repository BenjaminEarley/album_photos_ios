//
//  Photo.swift
//  Album Photos
//
//  Created by Benjamin Earley on 3/6/20.
//  Copyright © 2020 Benjamin Earley. All rights reserved.
//

struct Photo: Codable, Hashable, Identifiable {
    var id: Int
    var albumId: Int
    var title: String
    var url: String
    var thumbnailUrl: String
}
