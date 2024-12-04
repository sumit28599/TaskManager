//
//  AddTaskViewController.swift
//  TaskManagerApp
//
//  Created by BigOh on 03/12/24.
//

import UIKit

class AddTaskViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var submitBtnText: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    let taskmanager = TaskManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView ()
        submitBtnText.addTarget(self, action: #selector(submitBtnClick), for: .touchUpInside)
    }
    

    func setUpView () {
        submitBtnText.layer.cornerRadius = 10
        submitBtnText.layer.masksToBounds = true
        descriptionTextView.layer.cornerRadius = 10
        descriptionTextView.layer.masksToBounds = true 
    }
    
    @objc func submitBtnClick() {
        let task = TaskModelData(id: UUID(), titleText: titleTextField.text!, descriptions: descriptionTextView.text!, dueDate: Date(), isCompleted: false)
        taskmanager.saveTaskData(task: task)
        self.navigationController?.popViewController(animated: true)
    }
   
}
