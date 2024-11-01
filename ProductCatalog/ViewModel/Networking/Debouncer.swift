//
//  Debouncer.swift
//  ProductCatalog
//
//  Created by Dmitriy Eliseev on 01.11.2024.
//

import Foundation

//один из способов ограничения частоты повторяющихся событий (в нашем случае при частом скролинге)
final class Debouncer {
    private var workItem: DispatchWorkItem?
    private let queue: DispatchQueue
    private let delay: TimeInterval
    
    init(delay: TimeInterval, queue: DispatchQueue = .main) {
        self.delay = delay
        self.queue = queue
    }
    
    func debounce(action: @escaping () -> Void) {
        workItem?.cancel()
        workItem = DispatchWorkItem { [weak self] in
            action()
            self?.workItem = nil
        }
        queue.asyncAfter(deadline: .now() + delay, execute: workItem!)
    }
}
