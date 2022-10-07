//
//  MedicationListViewController.swift
//  MedicationManager
//
//  Created by Matthew Rawlings on 10/3/22.
//

import UIKit

class MedicationListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var moodSurveyButton: UIButton!
    
    // you MUST add and REMOVE self as observer to avoid memory leaks
    // more crucial on other VC's that actually deinit
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MedicationController.shared.fetchMedications()
        
        // telling 'self' to observe for the notification.name that was given
        NotificationCenter.default.addObserver(self, selector: #selector(reminderFired), name: NSNotification.Name(rawValue: Strings.medicationReminderReceived), object: nil)
        
        // are these being called at the right spot?
        tableView.delegate = self
        tableView.dataSource = self
        
        guard let survey = MoodSurveyController.shared.fetchTodaysSurveys() else { return }
        moodSurveyButton.setTitle(survey.mentalState, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func surveyButtonTapped(_ sender: UIButton) {
        guard let moodSurveyViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Strings.moodSurveyViewControllerIdentifier) as? MoodSurveyViewController else { return }
        
        moodSurveyViewController.delegate = self
        navigationController?.present(moodSurveyViewController, animated: true, completion: nil)
    }
    
    @objc private func reminderFired() {
        tableView.backgroundColor = .systemRed
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.tableView.backgroundColor = .white
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Strings.medicationDetailsSegueIdentifier,
        let indexPath = tableView.indexPathForSelectedRow,
        let destination = segue.destination as? MedicationDetailViewController {
            let medication = MedicationController.shared.sections[indexPath.section][indexPath.row]
            destination.medication = medication
        } else if segue.identifier == "toNewMedication" {
            
        }
    }
}

extension MedicationListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return MedicationController.shared.sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MedicationController.shared.sections[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "medicationCell", for: indexPath) as? MedicationTableViewCell else { return UITableViewCell()}
        
        let medication = MedicationController.shared.sections[indexPath.section][indexPath.row]
        
        cell.configure(with: medication)
        cell.delegate = self // cell saying that it will be the delegate for the protocol from the TableViewCell
        
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return MedicationController.shared.sections[section].isEmpty ? nil : "Not Taken"
        } else if section == 1 {
            return MedicationController.shared.sections[section].isEmpty ? nil : "Taken"
        } else {
            return nil
        }
    }
    

}
extension MedicationListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let medication = MedicationController.shared.sections[indexPath.section][indexPath.row]
            MedicationController.shared.deleteMedication(medication: medication)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension MedicationListViewController: MedicationTableViewCellDelegate {
    func medicationWasTakenButtonTapped(medication: Medication, wasTaken: Bool) {
        MedicationController.shared.markMedication(medication: medication, wasTaken: wasTaken)
        tableView.reloadData()
    }
}

extension MedicationListViewController: MoodSurveyViewControllerDelegate {
    func moodButtonTapped(withEmoji: String) {
        MoodSurveyController.shared.didTapMoodEmoji(withEmoji)
        moodSurveyButton.setTitle(withEmoji, for: .normal)
    }
}
