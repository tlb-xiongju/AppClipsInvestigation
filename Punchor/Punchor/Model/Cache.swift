//
//  Cache.swift
//  Punchor
//
//  Created by 熊 炬 on 2020/11/17.
//

import Foundation

final class Cache {
    static let shared = Cache(fileName: "default")
    
    private let isQueue = DispatchQueue(label: "punchor.record.cache")
    private let callbackQueue = DispatchQueue.main
    private lazy var directory = try! FileManager.default.url(for: .libraryDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    
    private var fileName: String
    
    init(fileName: String) {
        self.fileName = fileName
    }
}

extension Cache {
    func add(record: Record) {
    }
}
