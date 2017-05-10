//
//  Action.swift
//  IveCoin
//
//  Created by vlad on 5/7/17.
//  Copyright © 2017 com.hat. All rights reserved.
//

import Foundation
import ReSwift

struct AddNewProjectAction: Action {
    var newProject: Project
}

struct RemoveProjectAction: Action {
    var projectIndex: Int
}

struct SelectProjectAction: Action {
    var projectIndex: Int
}

struct RestoreStateAction: Action {
    var dictionary: [String: AnyObject]
}

struct SaveTaskAction: Action {
    var name: String
    var note: String?
}

struct SelectTaskAction: Action {
    var selectedTask: Task?
}

struct GoButtonTappedAction: Action {}
struct SaveStateAction: Action {}
