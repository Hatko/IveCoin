//
//  IveNavigationBar.swift
//  IveCoin
//
//  Created by vlad on 5/10/17.
//  Copyright © 2017 com.hat. All rights reserved.
//

import UIKit
import ReSwift

class IveNavigationBar: UINavigationBar, StoreSubscriber {
    weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .darkGray
        addSubview(titleLabel)
        self.titleLabel = titleLabel
        
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
    func newState(state projectState: AppState.ProjectsState) {
        if projectState.recordingOn {
            backgroundColor = UIColor(red:0.56, green:0.77, blue:0.29, alpha:1.00)
            
            if let name = projectState.selectedProject?.name {
                titleLabel.text = "\(name) 👨‍💻"
            } else {
                titleLabel.text = "IveCoin"
            }
        } else {
            backgroundColor = UIColor(red:0.72, green:0.72, blue:0.72, alpha:1.00)
            if let name = projectState.selectedProject?.name {
                titleLabel.text = "\(name) 😴"
            } else {
                titleLabel.text = "IveCoin"
            }
        }
    }
}
