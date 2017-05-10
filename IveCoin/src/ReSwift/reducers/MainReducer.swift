//
//  MainReducer.swift
//  IveCoin
//
//  Created by vlad on 5/6/17.
//  Copyright © 2017 com.hat. All rights reserved.
//

import Foundation
import ReSwift

func mainReducer(action: Action, state: AppState?) -> AppState {
    return AppState(terminating: terminatingReducer(action: action, state: state?.terminating),
                    projectsState: projectsReducer(action: action, state: state?.projectsState),
                    screen: screenReducer(action: action, state: state?.screen),
                    selectedTask: selectedTaskReducer(action: action, state: state?.selectedTask))
}


func terminatingReducer(action: Action, state terminating: Bool?) -> Bool {
    var terminating = terminating ?? false
    
    switch action {
    case is SaveStateAction:
        terminating = true
    default:
        break
    }
    
    return terminating
}


func selectedTaskReducer(action: Action, state task: Task?) -> Task? {
    var task = task
    
    switch action {
    case let action as SelectTaskAction:
        task = action.selectedTask
    default:
        break
    }
    
    return task
}


func screenReducer(action: Action, state: AppState.Screen?) -> AppState.Screen {
    var state = state ?? AppState.Screen.records
    
    switch action {
    case is ShowTaskScreenFromRecordsAction:
        state = .taskCreator
    case is PopTaskCreatorScreenAction, is PopTasksListScreenAction:
        state = .records
    case is ShowTasksListScreenFromRecordsAction, is PopTaskViewScreenAction:
        state = .taskList
    case is ShowTaskScreenFromListAction:
        state = .taskView
    default:
        break
    }
    
    return state
}

