//
//  ToDoCell.swift
//  ToDoList
//
//  Created by Владислав Павленко on 7/15/19.
//  Copyright © 2019 Владислав Павленко. All rights reserved.
//

import UIKit

protocol ToDoCellDelegate {
    func checkmarkTapped(sender: ToDoCell)
}

class ToDoCell: UITableViewCell {
    @IBOutlet weak var isCompleteButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    var delegate: ToDoCellDelegate?
    
    @IBAction func completeButtonTapped(_ sender: UIButton) {
        delegate?.checkmarkTapped(sender: self)
    }
}
