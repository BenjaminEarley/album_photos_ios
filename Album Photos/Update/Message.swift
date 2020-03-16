//
//  App.swift
//  Album Photos
//
//  Created by Benjamin Earley on 3/5/20.
//  Copyright © 2020 Benjamin Earley. All rights reserved.
//

import Foundation

enum AppMessage {
    case album(message: AlbumListMessage)
    case photo(message: AlbumDetailMessage)
}
