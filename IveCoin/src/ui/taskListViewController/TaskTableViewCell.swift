//
//  TaskTableViewCell.swift
//  IveCoin
//
//  Created by vlad on 5/9/17.
//  Copyright © 2017 com.hat. All rights reserved.
//

import Foundation
import UIKit

class TaskTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var spentTimeLabel: UILabel!
    
    
    
    func charge(withTask task: Task) {
        nameLabel.text = task.name
        spentTimeLabel.text = task.timeInHrsStringRepresentation
    }
}
