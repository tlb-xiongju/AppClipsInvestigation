//
//  DateFormatter+.swift
//  Punchor
//
//  Created by 熊 炬 on 2020/11/17.
//

import Foundation
import CoreLocation

extension DateFormatter {
    
    static var fullDate: DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = .init(identifier: .gregorian)
        formatter.dateStyle = .full
        return formatter
    }
    
    static var shortTime: DateFormatter {
        let timeFormatter = DateFormatter()
        timeFormatter.calendar = .init(identifier: .gregorian)
        timeFormatter.dateFormat = "HH:mm"
        return timeFormatter
    }
}

extension CLPlacemark {
    var adderss: String? {
        "\(administrativeArea ?? "")\(locality ?? "")\(subLocality ?? "")"
    }
}


