//
//  NotificationScheduler.swift
//  MedicationManager
//
//  Created by Matthew Rawlings on 10/6/22.
//

import UIKit
import UserNotifications

class NotificationScheduler {
    func scheduleNotifications(for medication: Medication) {
        guard let id = medication.id else { return }
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = "It's time to take your \(medication.name ?? "")"
        content.sound = .default
        content.userInfo = ["medicationID":id]
        content.categoryIdentifier = Strings.notificationCategoryIdentifier
        
        let fireDateComponents = Calendar.current.dateComponents([.hour, .minute], from: medication.timeOfDay ?? Date())
        let trigger = UNCalendarNotificationTrigger(dateMatching: fireDateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Unable to add notification request \(error.localizedDescription)")
            }
        }
    }
    func cancelNotifications(for medication: Medication) {
        guard let id = medication.id else { return }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }
}
