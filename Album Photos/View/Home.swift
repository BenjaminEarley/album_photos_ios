//
//  Home.swift
//  Album Photos
//
//  Created by Benjamin Earley on 3/6/20.
//  Copyright © 2020 Benjamin Earley. All rights reserved.
//

import SwiftUI

struct Home: View {
    var body: some View {
        NavigationView {
            AlbumListContainer()
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        let store = AppStore(initialState: .init(), reducer: appReducer, environment: MockWorld())
        return Home().environmentObject(store)
    }
}
