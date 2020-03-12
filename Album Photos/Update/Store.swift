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

final class Store<State, Message, Environment>: ObservableObject {
    @Published private(set) var state: State
    private let reducer: Reducer<State, Message, Environment>
    private let environment: Environment

    private var effectCancellables: Dictionary<UUID, AnyCancellable> = [:]

    init(
            initialState: State,
            reducer: @escaping Reducer<State, Message, Environment>,
            environment: Environment
    ) {
        self.state = initialState
        self.reducer = reducer
        self.environment = environment
    }

    @discardableResult
    func send(_ message: Message) -> UUID {
        let uuid = UUID()
        send(message, uuid: uuid)
        return uuid
    }

    private func send(_ message: Message, uuid: UUID) {
        let effect = reducer(&state, message, environment)

        var didComplete = false
        var cancellable: AnyCancellable

        cancellable = effect
                .receive(on: DispatchQueue.main)
                .sink(
                        receiveCompletion: { [weak self] _ in
                            didComplete = true
                            self?.effectCancellables.removeValue(forKey: uuid)

                        }, receiveValue: { [weak self] message in
                    self?.send(message, uuid: uuid)
                })
        if !didComplete {
            effectCancellables.updateValue(cancellable, forKey: uuid)
        }
    }

    func clearSideEffect(byUuid: UUID) {
        effectCancellables[byUuid]?.cancel()
    }
}
