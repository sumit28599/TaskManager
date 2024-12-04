//
//  ViewController.swift
//  TaskManagerApp
//
//  Created by BigOh on 03/12/24.
//


import UIKit

class TaskViewController: UIViewController {
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var addBtnText: UIButton!
    @IBOutlet weak var taskTableView: UITableView!
    
    
    let taskmanager = TaskManager()
    var filteredNames: [TaskEntity] = []
    var tasks: [TaskEntity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.fetchTasks()
        setUpTableView()
        searchTextField.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
        filteredNames = tasks
        addBtnText.addTarget(self, action: #selector(addTaskBtnClick), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchTasks()
        taskTableView.reloadData()
        
    }
    
    func setUpTableView() {
        taskTableView.delegate = self
        taskTableView.dataSource = self
        let nib = UINib(nibName: "TaskCell", bundle: nil)
        self.taskTableView.register(nib, forCellReuseIdentifier: "TaskCell")
        taskTableView.rowHeight = 100
        taskTableView.backgroundColor = .clear
    }
    @objc func searchTextChanged() {
        guard let searchText = searchTextField.text, !searchText.isEmpty else {
            tasks = filteredNames
            taskTableView.reloadData()
            return
        }
        
        let task =  CoreDataManager.shared.searchTasksByTitle(title: searchText)
        tasks = task ?? []
        taskTableView.reloadData()
    }
    
    @objc func addTaskBtnClick() {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddTaskViewController") as? AddTaskViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    func fetchTasks() {
        guard let task = taskmanager.getTaskData() else { return}
        tasks = task
    }
    
    func editButtonTapped(_ index: IndexPath) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController
        vc?.indexvalue = index.row
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
}

extension TaskViewController: UITableViewDelegate ,UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell") as! TaskCell
        let task = tasks[indexPath.row]
        cell.editBtnText.tag = indexPath.row
        cell.configureCell(with: task)
        cell.editAction = { [weak self] in
            self?.editButtonTapped(indexPath)
        }
        cell.backgroundColor = .clear
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.editButtonTapped(indexPath)
    }
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let taskToDelete = tasks[indexPath.row]
            guard let taskId = taskToDelete.id else {
                return
            }
            CoreDataManager.shared.deleteTaskData(id: taskId)
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
}


