/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Helpers for loading images and data.
*/

import UIKit
import SwiftUI
import CoreLocation

let albumData: [Album] = [
    Album(id: 0, userId: 0, title: "Album Example 1"),
    Album(id: 1, userId: 1, title: "Album Example 2"),
    Album(id: 2, userId: 2, title: "Album Example 3")
]
let photoData: [Photo] = [
    Photo(id: 0, albumId: 0, title: "Photo Example 1", image: UIImage()),
    Photo(id: 1, albumId: 0, title: "Photo Example 2", image: UIImage()),
    Photo(id: 2, albumId: 0, title: "Photo Example 3", image: UIImage()),
    Photo(id: 3, albumId: 1, title: "Photo Example 4", image: UIImage()),
    Photo(id: 4, albumId: 1, title: "Photo Example 5", image: UIImage()),
    Photo(id: 5, albumId: 2, title: "Photo Example 6", image: UIImage())
]


