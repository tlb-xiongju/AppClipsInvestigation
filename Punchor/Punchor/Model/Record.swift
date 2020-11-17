//
//  Record.swift
//  Punchor
//
//  Created by 熊 炬 on 2020/11/17.
//

import Foundation
import CoreLocation

struct Punch {
    enum State {
        case start(String), end(String)
    }
    
    let state: State
    let address: String
}

extension Punch: Codable {}
extension Punch.State: Codable {
    enum CodingKeys: String, CodingKey {
        case start
        case end
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .start(let value):
            try container.encode(value, forKey: .start)
        case .end(let value):
            try container.encode(value, forKey: .end)
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let value = try container.decodeIfPresent(String.self, forKey: .start) {
            self = .start(value)
        } else if let value = try container.decodeIfPresent(String.self, forKey: .end) {
            self = .end(value)
        } else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: container.codingPath, debugDescription: "Unknow case"))
        }
    }
}

struct Record {
    let startTime: String
    let endTime: String
    let address: String
}

struct MonthRecords {
    let monthYear: String
    let records: [Record]
}
