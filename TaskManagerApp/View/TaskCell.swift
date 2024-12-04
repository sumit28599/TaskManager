//
//  TaskCell.swift
//  TaskManagerApp
//
//  Created by BigOh on 03/12/24.
//

import UIKit

class TaskCell: UITableViewCell {
    @IBOutlet weak var taskTitlelbl: UILabel!
    @IBOutlet weak var taskDueDatelbl: UILabel!
    @IBOutlet weak var taskStatuslbl: UILabel!
    @IBOutlet weak var editBtnText: UIButton!
    @IBOutlet weak var taskView: UIView!
    
    var editAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        editBtnText.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        taskView.layer.cornerRadius = 10
        taskView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @objc private func editButtonTapped() {
        editAction?()
    }
    
    func configureCell(with task: TaskEntity) {
        taskTitlelbl.text = task.titleText
        taskStatuslbl.text = "Task is Completed: \(task.isCompleted)"
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        let dueDateString = formatter.string(from: task.dueDate ?? Date())
        taskDueDatelbl.text = "Date \(dueDateString)"
        if task.isCompleted {
            taskView.backgroundColor = .gray
        } else {
            taskView.backgroundColor = .white
        }
    }
}


