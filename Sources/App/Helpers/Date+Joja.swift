//
//  File.swift
//  
//
//  Created by Andrew on 2023/1/16.
//

import Foundation

extension ISO8601DateFormatter {
    convenience init(_ formatOptions: Options, timeZone: TimeZone? = TimeZone(identifier: "Asia/Taipei")) {
        self.init()
        self.formatOptions = formatOptions
        self.timeZone = timeZone
    }
}

extension Formatter {
    static let iso8601 = ISO8601DateFormatter([.withFullDate, .withFullTime])
}

extension Date {
    var iso8601: String {
        return Formatter.iso8601.string(from: self)
    }
    
    func after(component: Calendar.Component, value: Int) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        guard let expiryDate = calendar.date(byAdding: component, value: value, to: Date()) else {
            return Date()
        }
        return expiryDate
    }
}

extension String {
    var iso8601: Date? {
        return Formatter.iso8601.date(from: self)
    }
}

extension JSONDecoder.DateDecodingStrategy {
    static let iso8601joja = custom {
        let container = try $0.singleValueContainer()
        let string = try container.decode(String.self)
        guard let date = Formatter.iso8601.date(from: string) else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Cannot decode date string: " + string)
        }
        return date
    }
}

extension JSONEncoder.DateEncodingStrategy {
    static let iso8601joja = custom {
        var container = $1.singleValueContainer()
        try container.encode(Formatter.iso8601.string(from: $0))
    }
}
