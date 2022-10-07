//
//  DateFormatter.swift
//  MedicationManager
//
//  Created by Matthew Rawlings on 10/3/22.
//

import Foundation

extension DateFormatter {
    static let medicationTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
}
