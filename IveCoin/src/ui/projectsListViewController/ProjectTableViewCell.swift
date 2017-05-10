//
//  ProjectTableViewCell.swift
//  IveCoin
//
//  Created by vlad on 5/7/17.
//  Copyright © 2017 com.hat. All rights reserved.
//

import UIKit

class ProjectTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var totalMoneyLabel: UILabel!
    
    func charge(withProject project: Project) {
        nameLabel.text = project.name
        rateLabel.text = project.rateIn$StringRepresentation
        totalMoneyLabel.text = project.earnedIn$StringRepresentation
    }
    
    func highlight(_ highlight: Bool) {
        contentView.backgroundColor = highlight ? .iveGreen : .clear
    }
}
