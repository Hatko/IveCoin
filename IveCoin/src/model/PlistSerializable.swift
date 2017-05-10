//
//  PlistSerializable.swift
//  IveCoin
//
//  Created by vlad on 5/8/17.
//  Copyright © 2017 com.hat. All rights reserved.
//

import Foundation
import ReSwift

protocol PlistSerializable {
    var dictionaryRepresentation: [String : AnyObject] { get }
    init?(dictionary: [String: AnyObject])
}

extension Array where Element == [String : AnyObject] {
    func deserializeAllValid<Serializable: PlistSerializable>() -> [Serializable] {
        var deserializedObjects = [Serializable]()
        
        for dict in self {
            if let project = Serializable(dictionary: dict) {
                deserializedObjects.append(project)
            }
        }
        
        return deserializedObjects
    }
}


extension AppState.ProjectsState: PlistSerializable {
    init?(dictionary: [String : AnyObject]) {
        currentSessionStartDate = dictionary["currentSessionStartDate"] as? Date
        selectedIdx = dictionary["selectedIdx"] as? Int
        
        guard let allProjectsDicts = dictionary["allProjects"] as? [[String: AnyObject]] else {
            return
        }
        
        projects = allProjectsDicts.deserializeAllValid()
    }
    
    var dictionaryRepresentation: [String : AnyObject] {
        var dict = [String: AnyObject]()
        
        if let currentSessionStartDate = currentSessionStartDate {
            dict["currentSessionStartDate"] = currentSessionStartDate as AnyObject
        }
        
        dict["allProjects"] = projects.map { $0.dictionaryRepresentation } as AnyObject
        
        if let selectedIdx = selectedIdx {
            dict["selectedIdx"] = selectedIdx as AnyObject
        }
        
        return dict
    }
}


extension Task: PlistSerializable {
    var dictionaryRepresentation: [String : AnyObject] {
        return ["name": name as AnyObject, "note": note as AnyObject, "spentTimeInSeconds": spentTimeInSeconds as AnyObject]
    }
    
    init?(dictionary: [String : AnyObject]) {
        guard let name = dictionary["name"] as? String, let note = dictionary["note"] as? String, let spentTimeInSeconds = dictionary["spentTimeInSeconds"] as? Int
            else {
                return nil
        }
        
        self.name = name
        self.note = note
        self.spentTimeInSeconds = spentTimeInSeconds
    }
}


extension Project: PlistSerializable {
    init?(dictionary: [String : AnyObject]) {
        guard let name = dictionary["name"] as? String, let rateInCents = dictionary["rateInCents"] as? Int, let totalTimeSpentInSeconds = dictionary["totalTimeSpentInSeconds"] as? Int, let tasksDicts = dictionary["tasks"] as? [[String : AnyObject]]
            else {
                return nil
        }
        
        self.name = name
        self.rateInCents = rateInCents
        self.totalTimeSpentInSeconds = totalTimeSpentInSeconds
        tasks = tasksDicts.deserializeAllValid()
    }
    
    var dictionaryRepresentation: [String : AnyObject] {
        let tasksDicts = tasks.map { $0.dictionaryRepresentation } as AnyObject
        
        return ["name": name as AnyObject, "rateInCents": rateInCents as AnyObject, "totalTimeSpentInSeconds": totalTimeSpentInSeconds as AnyObject, "tasks": tasksDicts]
    }
}
