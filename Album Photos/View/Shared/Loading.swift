//
//  Loading.swift
//  Album Photos
//
//  Created by Benjamin Earley on 3/9/20.
//  Copyright © 2020 Benjamin Earley. All rights reserved.
//

import SwiftUI

struct Loading: View {
    var body: some View {
        Text("Loading...")
    }
}

struct Loading_Previews: PreviewProvider {
    static var previews: some View {
        Loading()
                .previewLayout(.fixed(width: 300, height: 70))
    }
}
