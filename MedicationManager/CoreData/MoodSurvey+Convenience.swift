//
//  MoodSurvey+Convenience.swift
//  MedicationManager
//
//  Created by Matthew Rawlings on 10/4/22.
//

import CoreData

extension MoodSurvey {
    @discardableResult convenience init(mentalState: String, date: Date, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.mentalState = mentalState
        self.date = date
    }
}
