//
//  TaskManager.swift
//  TaskManagerApp
//
//  Created by BigOh on 03/12/24.
//

import Foundation
import UIKit

class TaskManager:UIViewController,TaskManagerProtocol {
    
    var tasks: [TaskEntity] = []
    
    //MARK: Save data to Core Data
    func saveTaskData(task: TaskModelData) {
        CoreDataManager.shared.saveTaskData(task: task)
    }
    
    //MARK: Get Data From Core Data
    func getTaskData() -> [TaskEntity]? {
        guard let task = CoreDataManager.shared.getTaskData() else {
            return nil
        }
        self.tasks = task
        return tasks
    }
    
    //MARK: Update Data on Core Data
    func updateTaskData (id: UUID, updatedTask: TaskModelData) {
        CoreDataManager.shared.updateTaskData(id: id, updatedTask: updatedTask)
    }
    
    //MARK: Delete Data From Core Data
    func deleteTaskData(id: UUID) {
        CoreDataManager.shared.deleteTaskData(id: id)
    }
    
    func editTapped() {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddTaskViewController") as? AddTaskViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
