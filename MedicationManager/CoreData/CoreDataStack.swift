//
//  CoreDataStack.swift
//  MedicationManager
//
//  Created by Matthew Rawlings on 10/3/22.
//

import Foundation
import CoreData

enum CoreDataStack {
    static let container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Strings.appName)
        container.loadPersistentStores() { (storeDescription, error) in // this will load saved files in persistent storage
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    // get access to context which are models that aren't permanently saved yet
    static var context: NSManagedObjectContext { return container.viewContext }

    static func saveContext() {
        do {
            try context.save()
        } catch {
            NSLog("Error saving context \(error)")
        }
    }
}


