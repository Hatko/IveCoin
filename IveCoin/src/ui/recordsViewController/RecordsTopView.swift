//
//  RecordsTopView.swift
//  IveCoin
//
//  Created by vlad on 5/7/17.
//  Copyright © 2017 com.hat. All rights reserved.
//

import UIKit
import ReSwift

class RecordsTopView: UIView, StoreSubscriber {
    private var timer: Timer?
    private var currentSessionStartDate: Date?
    private var currentProject: Project?
    
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var projectRateLabel: UILabel!
    @IBOutlet weak var earnedOnProjectLabel: UILabel!
    @IBOutlet weak var spentOnProjectLabel: UILabel!
    
    func startRecord() {
        guard timer == nil else { return }
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
        
        RunLoop.main.add(timer!, forMode: .commonModes)
    }
    
    func stopRecord() {
        guard let timer = timer else { return }
        
        timer.invalidate()
        self.timer = nil
    }
    
    @objc func tick() {
        guard currentProject != nil else { return }
        
        currentProject!.totalTimeSpentInSeconds += 1
        
        updateCounters()
    }
    
    func updateInfo() {
        projectNameLabel.text = currentProject?.name
        projectRateLabel.text = currentProject?.rateIn$StringRepresentation
    }
    
    func updateCounters() {
        spentOnProjectLabel.text = currentProject?.timeInHrsStringRepresentation
        earnedOnProjectLabel.text = currentProject?.earnedIn$StringRepresentation
    }
    
    
    // MARK: StoreSubscriber
    
    func newState(state recordedProject: AppState.ProjectsState) {
        var project = recordedProject.selectedProject
        
        if let currentSessionStartDate = recordedProject.currentSessionStartDate {
            self.currentSessionStartDate = currentSessionStartDate
            
            project?.totalTimeSpentInSeconds += Int(Date().timeIntervalSince(currentSessionStartDate))

            startRecord()
        } else {
            stopRecord()
        }
        
        currentProject = project
        
        updateInfo()
        updateCounters()
    }
}
