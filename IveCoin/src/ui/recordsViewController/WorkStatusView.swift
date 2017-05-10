//
//  WorkStatusView.swift
//  IveCoin
//
//  Created by vlad on 5/7/17.
//  Copyright © 2017 com.hat. All rights reserved.
//

import UIKit
import ReSwift

class WorkStatusView: UIView, StoreSubscriber {
    @IBOutlet weak var workStatusLabel: UILabel!


    // MARK: StoreSubscriber
    
    func newState(state recordingOn: Bool) {
        if recordingOn {
            backgroundColor = UIColor(red:0.56, green:0.77, blue:0.29, alpha:1.00)
            workStatusLabel.text = "IveCoin 👨‍💻"
        } else {
            backgroundColor = UIColor(red:0.72, green:0.72, blue:0.72, alpha:1.00)
            workStatusLabel.text = "IveCoin 😴"
        }
    }
}
