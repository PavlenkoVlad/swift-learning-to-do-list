//
//  ToDo.swift
//  ToDoList
//
//  Created by Владислав Павленко on 7/14/19.
//  Copyright © 2019 Владислав Павленко. All rights reserved.
//

import Foundation

struct ToDo: Codable {
    var title: String
    var isComplete: Bool
    var dueDate: Date
    var notes: String?
    
    static let DocumentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentDirectory.appendingPathComponent("todos").appendingPathExtension("plist")
    
    static let dueDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    static func loadToDos() -> [ToDo]? {
        guard let todosData = try? Data(contentsOf: ArchiveURL) else { return nil }
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Array<ToDo>.self, from: todosData)
    }
    
    static func saveToDos(_ todos: [ToDo]) {
        let propertyListEncoder = PropertyListEncoder()
        let todosData = try? propertyListEncoder.encode(todos)
        try? todosData?.write(to: ArchiveURL, options: .noFileProtection)
    }
    
    static func loadSampleToDos() -> [ToDo] {
        return [
            ToDo(title: "ToDo One", isComplete: false, dueDate: Date(), notes: "Notes 1"),
            ToDo(title: "ToDo Two", isComplete: false, dueDate: Date(), notes: "Notes 2"),
            ToDo(title: "ToDo Three", isComplete: false, dueDate: Date(), notes: "Notes 3")
        ]
    }
}
