//
//  albumRow.swift
//  Album Photos
//
//  Created by Benjamin Earley on 3/5/20.
//  Copyright © 2020 Benjamin Earley. All rights reserved.
//

import SwiftUI

struct AlbumRow: View {

    var album: Album

    var body: some View {
        Text(album.title)
    }
}

struct albumRow_Previews: PreviewProvider {
    static var previews: some View {
        AlbumRow(album: albumData[0])
    }
}
