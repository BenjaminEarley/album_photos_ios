//
//  Message.swift
//  Album Photos
//
//  Created by Benjamin Earley on 3/9/20.
//  Copyright © 2020 Benjamin Earley. All rights reserved.
//

import SwiftUI

struct Message: View {
    let message: String

    var body: some View {
        Text(message)
    }
}

struct Message_Previews: PreviewProvider {
    static var previews: some View {
        Message(message: "Hello")
    }
}
