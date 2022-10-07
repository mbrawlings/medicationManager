//
//  MedicationDetailViewController.swift
//  MedicationManager
//
//  Created by Matthew Rawlings on 10/3/22.
//

import UIKit

class MedicationDetailViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var medication: Medication?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let medication = medication,
           let timeOfDay = medication.timeOfDay {
            title = "Medication Details"
            nameTextField.text = medication.name
            datePicker.date = timeOfDay
        } else {
            title = "Add Medication"
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(reminderFired), name: NSNotification.Name(rawValue: Strings.medicationReminderReceived), object: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = nameTextField.text,
              !name.isEmpty
        else { return }
        let timeOfDay = datePicker.date
        
        if let medication = medication {
            MedicationController.shared.updateMedication(medication: medication, name: name, timeOfDay: timeOfDay)
        } else {
            MedicationController.shared.create(name: name, timeOfDay: timeOfDay)
        }
        MedicationController.shared.fetchMedications()
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func reminderFired() {
        self.view.backgroundColor = .systemRed
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.view.backgroundColor = .systemOrange
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
