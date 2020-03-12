//
//  Photo.swift
//  Album Photos
//
//  Created by Benjamin Earley on 3/6/20.
//  Copyright © 2020 Benjamin Earley. All rights reserved.
//

import SwiftUI

struct Photo: Hashable, Identifiable {
    var id: Int
    var albumId: Int
    var title: String
    var image: UIImage
}
