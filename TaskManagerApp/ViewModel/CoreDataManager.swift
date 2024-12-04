//
//  CoreDataManager.swift
//  TaskManagerApp
//
//  Created by BigOh on 03/12/24.
//

import Foundation
import CoreData
import UIKit

protocol TaskManagerProtocol {
    func saveTaskData(task: TaskModelData)
    func updateTaskData(id: UUID, updatedTask: TaskModelData)
    func deleteTaskData(id: UUID)
    func getTaskData() -> [TaskEntity]?
}

class CoreDataManager:TaskManagerProtocol {
    
    static let shared = CoreDataManager()
    
    private init () {}
    private var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    //MARK: Save data to Core Data
    
    func saveTaskData(task: TaskModelData) {
        let taskEntity = TaskEntity(context: context)
        
        taskEntity.id = task.id
        taskEntity.titleText = task.titleText
        taskEntity.descriptions = task.descriptions
        taskEntity.dueDate = task.dueDate
        taskEntity.isCompleted = task.isCompleted
        
        do {
            try context.save()
            print("Task saved successfully.")
        } catch {
            print("Failed to save task: \(error)")
        }
    }
    
    //MARK: Get Data From Core Data
    func getTaskData() -> [TaskEntity]? {
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "dueDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let tasks = try context.fetch(fetchRequest)
            print("Fetched tasks successfully.")
            return tasks
        } catch {
            print("Failed to fetch tasks: \(error)")
            return nil
        }
    }
    
    //MARK: Update Data on Core Data
    func updateTaskData(id: UUID, updatedTask: TaskModelData) {
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let tasks = try context.fetch(fetchRequest)
            if let taskToUpdate = tasks.first {
                
                taskToUpdate.titleText = updatedTask.titleText
                taskToUpdate.descriptions = updatedTask.descriptions
                taskToUpdate.dueDate = updatedTask.dueDate
                taskToUpdate.isCompleted = updatedTask.isCompleted
                
                try context.save()
                print("Task updated successfully.")
            } else {
                print("Task with id \(id) not found.")
            }
        } catch {
            print("Failed to update task: \(error)")
        }
    }
    
    //MARK: Delete Data From Core Data
    func deleteTaskData(id: UUID) {
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let tasks = try context.fetch(fetchRequest)
            if let taskToDelete = tasks.first {
                context.delete(taskToDelete)
                try context.save()
                print("Task with id \(id) deleted successfully.")
            } else {
                print("Task with id \(id) not found.")
            }
        } catch {
            print("Failed to delete task: \(error)")
        }
    }
    
    
    //MARK: Search Data by Title From Core Data
    func searchTasksByTitle(title: String) -> [TaskEntity]? {
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "titleText CONTAINS[cd] %@", title)
        
        do {
            let tasks = try context.fetch(fetchRequest)
            print("Tasks with title '\(title)' fetched successfully.")
            return tasks
        } catch {
            print("Failed to fetch tasks by title: \(error)")
            return nil
        }
    }
}


