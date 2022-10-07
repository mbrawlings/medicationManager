//
//  TakenDate+Convenience.swift
//  MedicationManager
//
//  Created by Matthew Rawlings on 10/4/22.
//

import CoreData

extension TakenDate {
    @discardableResult convenience init(date: Date, medication: Medication, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.date = date
        self.medication = medication
    }
}
