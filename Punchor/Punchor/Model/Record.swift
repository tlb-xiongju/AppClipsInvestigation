//
//  Record.swift
//  Punchor
//
//  Created by 熊 炬 on 2020/11/17.
//

import Foundation
import CoreLocation

struct Record {
    let start: Date
    let end: Date
    let longitude: Double
    let latitude: Double
    let address: String
}

struct MonthRecords {
    let monthYear: Date
    let records: [Record]
}
