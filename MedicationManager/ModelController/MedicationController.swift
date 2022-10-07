//
//  MedicationController.swift
//  MedicationManager
//
//  Created by Matthew Rawlings on 10/3/22.
//

import Foundation
import CoreData

class MedicationController {
    
    static let shared = MedicationController()
    let notificationScheduler = NotificationScheduler()
    
    private init() {
        fetchMedications()
    }
    
    private lazy var fetchRequest: NSFetchRequest<Medication> = {
        let request = NSFetchRequest<Medication>(entityName: "Medication")
        request.predicate = NSPredicate(value: true)
        return request
    }()
    
    var sections: [[Medication]] {[notTakenMeds,takenMeds]}
    var notTakenMeds: [Medication] = []
    var takenMeds: [Medication] = []
    
    // CRUD
    func create(name: String, timeOfDay: Date) {
        let medication = Medication(name: name, timeOfDay: timeOfDay)
        notTakenMeds.append(medication)
        CoreDataStack.saveContext()
        
        //Schedule notifications
        notificationScheduler.scheduleNotifications(for: medication)
    }

    func fetchMedications() {
        let medications = (try? CoreDataStack.context.fetch(self.fetchRequest)) ?? []
        takenMeds = medications.filter( { $0.wasTakenToday() })
        notTakenMeds = medications.filter( { !$0.wasTakenToday() })
    }

    func updateMedication(medication: Medication, name: String, timeOfDay: Date) {
        medication.name = name
        medication.timeOfDay = timeOfDay
        CoreDataStack.saveContext()
        
        //need to get rid of old notification that was attached to this med
        notificationScheduler.cancelNotifications(for: medication)
        //then add again with updated time
        notificationScheduler.scheduleNotifications(for: medication)
    }
    
    func markMedication(medication: Medication, wasTaken: Bool) {
        if wasTaken {
            TakenDate(date: Date(), medication: medication)
            if let index = notTakenMeds.firstIndex(of: medication) {
                notTakenMeds.remove(at: index)
                takenMeds.append(medication)
            }
        } else {
            let mutableTakenDates = medication.mutableSetValue(forKey: "takenDates")
            if let takenDate = (mutableTakenDates as? Set<TakenDate>)?.first(where: { takenDate in
                guard let date = takenDate.date else { return false }
                
                return Calendar.current.isDate(date, inSameDayAs: Date())
            }) {
                mutableTakenDates.remove(takenDate)
                if let index = takenMeds.firstIndex(of: medication) {
                    takenMeds.remove(at: index)
                    notTakenMeds.append(medication)
                }
            }
        }
        CoreDataStack.saveContext()
    }
    
    func markMedicationTaken(withID id: String) {
        guard let medication = notTakenMeds.first(where: {$0.id == id}) else { return }
        
        markMedication(medication: medication, wasTaken: true)
    }

    func deleteMedication(medication: Medication) {
        //removing from array
        if let index = notTakenMeds.firstIndex(of: medication) {
            notTakenMeds.remove(at: index)
        } else if let index = takenMeds.firstIndex(of: medication) {
            takenMeds.remove(at: index)
        }
        //removing from storage
        CoreDataStack.context.delete(medication)
        //save your changes
        CoreDataStack.saveContext()
        // Cancel Notification
        notificationScheduler.cancelNotifications(for: medication)
    }
}
