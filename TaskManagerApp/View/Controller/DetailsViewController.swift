//
//  DetailsViewController.swift
//  TaskManagerApp
//
//  Created by BigOh on 03/12/24.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var idTextLbl: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var updateBtnText: UIButton!
    
    var indexvalue = 0
    var tasks: [TaskEntity] = []
    let taskmanager = TaskManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTasks()
        setUpView()
        setUpValue()
        updateBtnText.addTarget(self, action: #selector(submitBtnClick), for: .touchUpInside)
    }
    
    func setUpView() {
        descriptionTextView.layer.cornerRadius = 8
        descriptionTextView.layer.masksToBounds = true
        updateBtnText.layer.cornerRadius = 10
        updateBtnText.layer.masksToBounds = true
    }
    
    func setUpValue() {
        let task = tasks[indexvalue]
        titleTextField.text = task.titleText
        descriptionTextView.text = task.descriptions
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        let dueDateString = formatter.string(from: task.dueDate ?? Date())
        idTextLbl.text = "Date: \(dueDateString)"
    }
    
    func fetchTasks() {
        guard let task = taskmanager.getTaskData() else { return}
        tasks = task
    }

    @objc func submitBtnClick() {
        let task = TaskModelData(id: UUID(),titleText: titleTextField.text!, descriptions: descriptionTextView.text!, dueDate: Date(), isCompleted: true)
        taskmanager.updateTaskData(id: tasks[indexvalue].id!, updatedTask: task)
        self.navigationController?.popViewController(animated: true)
    }
    
}
