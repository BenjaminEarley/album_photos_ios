//
//  Album.swift
//  Album Photos
//
//  Created by Benjamin Earley on 3/6/20.
//  Copyright © 2020 Benjamin Earley. All rights reserved.
//

struct Album: Decodable, Identifiable {
    var id: Int
    var userId: Int
    var title: String
}
