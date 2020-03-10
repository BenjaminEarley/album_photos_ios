//
//  Store.swift
//  Album Photos
//
//  Created by Benjamin Earley on 3/5/20.
//  Copyright © 2020 Benjamin Earley. All rights reserved.
//

import SwiftUI
import Combine

typealias AppStore = Store<AppState, AppMessage, World>

final class Store<State, Message: Hashable, Environment>: ObservableObject {
    @Published private(set) var state: State
    private let reducer: Reducer<State, Message, Environment>
    private let environment: Environment

    private var effectCancellables: Dictionary<Message, Set<AnyCancellable>> = [:]

    init(
            initialState: State,
            reducer: @escaping Reducer<State, Message, Environment>,
            environment: Environment
    ) {
        self.state = initialState
        self.reducer = reducer
        self.environment = environment
    }

    func send(_ message: Message) {
        let effect = reducer(&state, message, environment)

        var didComplete = false
        var cancellable: AnyCancellable?

        cancellable = effect
                .receive(on: DispatchQueue.main)
                .sink(
                        receiveCompletion: { [weak self] _ in
                            didComplete = true
                            if let c = cancellable {
                                self?.effectCancellables[message]?.remove(c)
                            }
                        }, receiveValue: send)
        if !didComplete, let cancellable = cancellable {
            effectCancellables[message, default: []].insert(cancellable)
        }
    }

    func clearEffects(byMessage: Message) {
        effectCancellables[byMessage]?.forEach { $0.cancel() }
    }
}
