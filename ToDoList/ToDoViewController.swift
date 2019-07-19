//
//  ToDoViewController.swift
//  ToDoList
//
//  Created by Владислав Павленко on 7/15/19.
//  Copyright © 2019 Владислав Павленко. All rights reserved.
//

import UIKit

class ToDoViewController: UITableViewController {
    
    @IBOutlet weak var isCompleteButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var dueDatePickerView: UIDatePicker!
    
    @IBOutlet weak var notesTextView: UITextView!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var isPickerHidden = true
    
    var toDo: ToDo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let toDo = toDo {
            navigationItem.title = "To-Do"
            titleTextField.text = toDo.title
            isCompleteButton.isSelected = toDo.isComplete
            dueDatePickerView.date = toDo.dueDate
            notesTextView.text = toDo.notes
        } else {
            dueDatePickerView.date = Date().addingTimeInterval(24 * 60 * 60)
        }
        
        updateSaveButtonState()
        updateDueDateLabel(date: dueDatePickerView.date)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let normalCellHeight = CGFloat(44)
        let largeCellHeight = CGFloat(200)
        
        switch indexPath {
        case [1, 0]:
            return isPickerHidden ? normalCellHeight : largeCellHeight
        case [2, 0]:
            return largeCellHeight
        default:
            return normalCellHeight
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        switch indexPath {
        case [1, 0]:
            isPickerHidden = !isPickerHidden
            
            tableView.beginUpdates()
            tableView.endUpdates()
        default:
            break
        }
    }
    
    @IBAction func isCompleteButtonTapped(_ sender: UIButton) {
        isCompleteButton.isSelected = !isCompleteButton.isSelected
    }
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    @IBAction func returnPressed(_ sender: UITextField) {
        titleTextField.resignFirstResponder()
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        updateDueDateLabel(date: dueDatePickerView.date)
    }
    
    func updateSaveButtonState() {
        let text = titleTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    func updateDueDateLabel(date: Date) {
        dueDateLabel.text = ToDo.dueDateFormatter.string(from: date)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == "saveUnwind" else { return }
        
        let title = titleTextField.text!
        let isComplete = isCompleteButton.isSelected
        let dueDate = dueDatePickerView.date
        let notes = notesTextView.text
        
        toDo = ToDo(title: title, isComplete: isComplete, dueDate: dueDate, notes: notes)
    }
}
