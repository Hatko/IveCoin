//
//  ProjectReducer.swift
//  IveCoin
//
//  Created by vlad on 5/10/17.
//  Copyright © 2017 com.hat. All rights reserved.
//

import Foundation
import ReSwift

func projectsReducer(action: Action, state: AppState.ProjectsState?) -> AppState.ProjectsState {
    var state = state ?? AppState.ProjectsState()
    
    switch action {
    case is RespondToStatusAction:
        // TODO: find a better approach
        state.status = .defaultStatus
    case is GoButtonTappedAction:
        if let currentSessionStartDate = state.currentSessionStartDate {
            if let selectedIdx = state.selectedIdx {
                state.projects[selectedIdx].totalTimeSpentInSeconds += Int(Date().timeIntervalSince(currentSessionStartDate))
            }
            
            state.currentSessionStartDate = nil
        } else {
            state.currentSessionStartDate = Date()
        }
    case let action as SaveTaskAction:
        if let selectedIdx = state.selectedIdx {
            let timeSpentOnTask = state.timeInSecondsSpentOnCurrentTask
            
            if timeSpentOnTask == 0 {
                state.status = .noTimeToLog
            } else {
                let task = Task(name: action.name, note: action.note, spentTimeInSeconds: timeSpentOnTask)
                
                state.projects[selectedIdx].tasks.append(task)
                
                state.status = .taskLogged
            }
        }
    case let action as AddNewProjectAction:
        guard (state.projects.first { $0.name == action.newProject.name }) == nil else {
            break
        }
        
        state.projects.append(action.newProject)
        
        // first project
        if state.projects.count == 1 {
            state.selectedIdx = 0
        }
    case let action as RestoreStateAction:
        if let newState = AppState.ProjectsState(dictionary: action.dictionary) {
            state = newState
        }
    case let action as RemoveProjectAction:
        if let selectedIdx = state.selectedIdx {
            switch selectedIdx {
            case action.projectIndex:
                // remove selected project
                state.selectedIdx = nil
                state.currentSessionStartDate = nil
            case _ where selectedIdx > action.projectIndex:
                state.selectedIdx = selectedIdx - 1
                break
            default:
                break
            }
        }
        state.projects.remove(at: action.projectIndex)
    case let action as SelectProjectAction:
        if state.selectedIdx != action.projectIndex {
            if let currentSessionStartDate = state.currentSessionStartDate, let selectedIdx = state.selectedIdx {
                state.projects[selectedIdx].totalTimeSpentInSeconds += Int(Date().timeIntervalSince(currentSessionStartDate))
            }
            
            state.selectedIdx = action.projectIndex
            state.currentSessionStartDate = nil
        }
    default:
        break
    }
    
    return state
}
