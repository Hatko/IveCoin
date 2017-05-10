//
//  PersistentStorageService.swift
//  IveCoin
//
//  Created by vlad on 5/8/17.
//  Copyright © 2017 com.hat. All rights reserved.
//

import UIKit
import ReSwift

class PersistentStorageService: NSObject, StoreSubscriber {
    private var projectsPath: URL {
        let fileURLs = FileManager.default.urls(
            for: .documentDirectory, in: .userDomainMask)
        guard let documentURL = fileURLs.first else {
            fatalError("can't access documents url")
        }
        return documentURL.appendingPathComponent("Projects.plist")
    }
    
    override init() {
        super.init()
        
        mainStore.subscribe(self) { state in
            state.select { $0 }
        }
        
        guard let dictionary = NSDictionary(contentsOf: projectsPath) as? [String: AnyObject] else { return }
        
        mainStore.dispatch(
            RestoreStateAction(dictionary: dictionary)
        )
    }
    
    
    // MARK: StoreSubscriber
    
    func newState(state: AppState) {
        guard state.terminating else { return }
            
        let projectDict = state.projectsState.dictionaryRepresentation
            
        do {
            let plistData = try PropertyListSerialization.data(fromPropertyList: projectDict, format: PropertyListSerialization.PropertyListFormat.xml, options: PropertyListSerialization.WriteOptions(0)
            )
            try plistData.write(to: projectsPath, options: Data.WritingOptions.atomic)
        } catch {
            assertionFailure("\(error)")
        }
    }
}
