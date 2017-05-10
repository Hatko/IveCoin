//
//  AppState.swift
//  IveCoin
//
//  Created by vlad on 5/6/17.
//  Copyright © 2017 com.hat. All rights reserved.
//

import Foundation
import ReSwift

struct AppState: StateType {
    enum Screen {
        case records, taskCreator, taskList, taskView
    }
    
    struct ProjectsState {
        enum Status {
            case defaultStatus, noTimeToLog, taskLogged
        }
        
        var status = Status.defaultStatus
        
        var projects = [Project]()
        var selectedIdx: Int? = nil
        
        var currentSessionStartDate: Date?
        
        var recordingOn: Bool {
            return currentSessionStartDate != nil
        }
        
        var selectedProject: Project? {
            get {
                guard let selectedIdx = selectedIdx, projects.count > selectedIdx else { return nil }
                
                return projects[selectedIdx]
            }
        }
        
        var timeInSecondsSpentOnCurrentTask: Int {
            guard let selectedIdx = selectedIdx else { return 0 }
            
            let currentProject = projects[selectedIdx]
            
            var timeSpentOnProject = currentProject.totalTimeSpentInSeconds
            
            if let currentSessionStartDate = currentSessionStartDate {
                timeSpentOnProject += Int(Date().timeIntervalSince(currentSessionStartDate))
            }
            
            return timeSpentOnProject - currentProject.tasks.reduce(0) { $0 + $1.spentTimeInSeconds }
        }
    }
    
    var terminating: Bool
    var projectsState: ProjectsState
    var screen: Screen
    var selectedTask: Task?
}


extension AppState {
    struct RecordScreenState {
        var selectedIdx: Int?
        var recordingOn: Bool
        var screen: Screen
    }
    
    var recordScreenState: RecordScreenState {
        return RecordScreenState(selectedIdx: projectsState.selectedIdx, recordingOn: projectsState.recordingOn, screen: screen)
    }
}


extension AppState {
    struct TaskViewScreenState {
        var screen: Screen
        var task: Task?
    }
    
    var taskViewScreenState: TaskViewScreenState {
        return TaskViewScreenState(screen: screen, task: selectedTask)
    }
}


extension AppState {
    struct TaskCreatorScreenState {
        var screen: Screen
        var projectStateStatus: ProjectsState.Status
    }
    
    var taskCreatorScreenState: TaskCreatorScreenState {
        return TaskCreatorScreenState(screen: screen, projectStateStatus: projectsState.status)
    }
}
