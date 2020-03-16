//
//  Update.swift
//  Album Photos
//
//  Created by Benjamin Earley on 3/10/20.
//  Copyright © 2020 Benjamin Earley. All rights reserved.
//

import Combine

typealias Reducer<State, Message, Environment> =
        (inout State, Message, Environment) -> AnyPublisher<Message, Never>

func appReducer(
        state: inout AppState,
        message: AppMessage,
        environment: World
) -> AnyPublisher<AppMessage, Never> {
    switch message {
    case let .album(albumMessage):
        return AlbumListReducer(&state.album, albumMessage, environment).map {
            AppMessage.album(message: $0)
        }.eraseToAnyPublisher()
    case let .photo(photoMessage):
        return AlbumDetailReducer(&state.photo, photoMessage, environment).map {
            AppMessage.photo(message: $0)
        }.eraseToAnyPublisher()
    }

}
