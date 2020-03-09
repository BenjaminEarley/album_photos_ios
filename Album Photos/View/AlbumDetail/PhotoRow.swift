//
//  PhotoRow.swift
//  Album Photos
//
//  Created by Benjamin Earley on 3/5/20.
//  Copyright © 2020 Benjamin Earley. All rights reserved.
//

import SwiftUI

struct PhotoRow: View {

    var photo: Photo

    var body: some View {
        Text(photo.title)
    }
}

struct PhotoRow_Previews: PreviewProvider {
    static var previews: some View {
        PhotoRow(photo: photoData[0])
    }
}
