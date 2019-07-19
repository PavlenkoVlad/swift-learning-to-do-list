//
//  ToDoTableViewController.swift
//  ToDoList
//
//  Created by Владислав Павленко on 7/14/19.
//  Copyright © 2019 Владислав Павленко. All rights reserved.
//

import UIKit

class ToDoTableViewController: UITableViewController, ToDoCellDelegate {
    
    var todos = [ToDo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        if let savedToDos = ToDo.loadToDos() {
            todos = savedToDos
        } else {
            todos = ToDo.loadSampleToDos()
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell") as? ToDoCell else { fatalError("Could not dequeue a cell") }
        let todo = todos[indexPath.row]
        
        cell.titleLabel.text = todo.title
        cell.isCompleteButton.isSelected = todo.isComplete
        cell.delegate = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            todos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            ToDo.saveToDos(todos)
        }
    }
    
    func checkmarkTapped(sender: ToDoCell) {
        if let indexPath = tableView.indexPath(for: sender) {
            var todo = todos[indexPath.row]
            todo.isComplete = !todo.isComplete
            todos[indexPath.row] = todo
            tableView.reloadRows(at: [indexPath], with: .automatic)
            ToDo.saveToDos(todos)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            let toDoViewController = segue.destination as! ToDoViewController
            let selectedCellIndexPath = tableView.indexPathForSelectedRow!
            toDoViewController.toDo = todos[selectedCellIndexPath.row]
        }
    }
    
    @IBAction func unwindToToDoList(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind" else { return }
        let toDoViewController = segue.source as! ToDoViewController
        
        if let toDo = toDoViewController.toDo {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                todos[selectedIndexPath.row] = toDo
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                let newIndexPath = IndexPath(row: todos.count, section: 0)
                
                todos.append(toDo)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
        
        ToDo.saveToDos(todos)
    }
}
