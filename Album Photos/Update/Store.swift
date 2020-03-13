//
//  Store.swift
//  Album Photos
//
//  Created by Benjamin Earley on 3/5/20.
//  Copyright © 2020 Benjamin Earley. All rights reserved.
//

import UIKit
import Combine

typealias AppStore = Store<AppState, AppMessage, World>

final class Store<State, Message, Environment>: ObservableObject {
    @Published private(set) var state: State
    private let reducer: Reducer<State, Message, Environment>
    private let environment: Environment

    private var rootUuids: Dictionary<UUID, Set<UUID>> = [:]
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
        rootUuids.updateValue(Set<UUID>(), forKey: uuid)
        send(message, uuid: uuid, rootUuid: uuid)
        return uuid
    }

    private func send(_ message: Message, uuid: UUID, rootUuid: UUID) {
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
                    self?.send(message, uuid: UUID(), rootUuid: rootUuid)
                })
        if !didComplete {
            let ids = rootUuids[rootUuid]
            if var _ids = ids {
                _ids.insert(uuid)
                rootUuids.updateValue(_ids, forKey: rootUuid)
            }
            effectCancellables.updateValue(cancellable, forKey: uuid)
        }
    }

    func clearSideEffect(byUuid: UUID) {
        let ids = rootUuids[byUuid]
        ids?.forEach {
            effectCancellables[$0]?.cancel()
        }
    }
}
