//
//  Date+YearMonthDay.swift
//  ArcwindResume
//
//  Created by Marcel Dierkes on 10.02.23.
//

import Foundation

extension Date {
    init(year: Int, month: Int? = nil, day: Int? = nil, calendar: Calendar = .current) {
        let components = DateComponents(year: year, month: month, day: day)
        guard let date = calendar.date(from: components) else {
            fatalError("Invalid date components")
        }
        self = date
    }
}
