//
//  Record.swift
//  Punchor
//
//  Created by 熊 炬 on 2020/11/17.
//

import Foundation
import CoreLocation

struct Record {
    let start: String
    let end: String
    let address: String
}

struct MonthRecords {
    let monthYear: String
    let records: [Record]
}
