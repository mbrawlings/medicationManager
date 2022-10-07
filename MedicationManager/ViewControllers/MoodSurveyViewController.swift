//
//  MoodSurveyViewController.swift
//  MedicationManager
//
//  Created by Matthew Rawlings on 10/4/22.
//

import UIKit

protocol MoodSurveyViewControllerDelegate: AnyObject {
    func moodButtonTapped(withEmoji: String)
}

class MoodSurveyViewController: UIViewController {
    
    weak var delegate: MoodSurveyViewControllerDelegate?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(reminderFired), name: NSNotification.Name(rawValue: Strings.medicationReminderReceived), object: nil)
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func emojiTapped(_ sender: UIButton) {
        guard let emoji = sender.titleLabel?.text else {return}
        delegate?.moodButtonTapped(withEmoji: emoji)
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func reminderFired() {
        self.view.backgroundColor = .systemRed
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.view.backgroundColor = .systemPurple
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
