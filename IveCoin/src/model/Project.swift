//
//  Project.swift
//  IveCoin
//
//  Created by vlad on 5/7/17.
//  Copyright © 2017 com.hat. All rights reserved.
//

import Foundation

struct Project: Equatable {
    init(name: String, rateInCents: Int, totalTimeSpentInSeconds: Int = 0) {
        self.name = name
        self.rateInCents = rateInCents
        self.totalTimeSpentInSeconds = totalTimeSpentInSeconds
    }
    
    var name: String
    var rateInCents: Int
    var totalTimeSpentInSeconds: Int
    var tasks = [Task]()
    
    public static func ==(lhs: Project, rhs: Project) -> Bool {
        return lhs.name == rhs.name && lhs.rateInCents == rhs.rateInCents && lhs.totalTimeSpentInSeconds == rhs.totalTimeSpentInSeconds
    }
}

struct Task {
    var name: String
    var note: String?
    var spentTimeInSeconds: Int
}

extension Task: StringRepresentable {
    var timeInSeconds: Int { return spentTimeInSeconds }
}

extension Project: StringRepresentable {
    var timeInSeconds: Int { return totalTimeSpentInSeconds }
    
    var rateIn$StringRepresentation: String {
        return String(format: "%g$", Float(rateInCents) / 100)
    }
    
    var earnedIn$StringRepresentation: String {
        let rateForSecond = Float(rateInCents) / 3600
        
        let earnedIn$ = rateForSecond * Float(totalTimeSpentInSeconds) / 100
        
        return String(format: "%02.02f$", earnedIn$)
    }
}

protocol StringRepresentable {
    var timeInSeconds: Int { get }
}

extension StringRepresentable {
    var timeInHrsStringRepresentation: String {
        let hrs = timeInSeconds / 3600
        
        let remainedSeconds = timeInSeconds % 3600
        
        let minutes = remainedSeconds / 60
        let seconds = remainedSeconds % 60
        
        return String(format: "%02i:%02i:%02i", hrs, minutes, seconds)
    }
}
