//
//  RecordsViewController.swift
//  IveCoin
//
//  Created by vlad on 5/6/17.
//  Copyright © 2017 com.hat. All rights reserved.
//

import UIKit
import ReSwift

class RecordsViewController: UIViewController {
    let persistentStorageService = PersistentStorageService()
    
    @IBOutlet weak var recordsTopView: RecordsTopView!
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var billButton: UIButton!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mainStore.subscribe(self) { $0.select { $0.recordScreenState } }
        mainStore.subscribe(recordsTopView) { $0.select { $0.projectsState } }
        
        let navigationBar = navigationController?.navigationBar as? IveNavigationBar
        assert(navigationBar != nil)
        
        if let navigationBar = navigationBar {
            mainStore.subscribe(navigationBar) { $0.select { $0.projectsState } }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        mainStore.unsubscribe(self)
        mainStore.unsubscribe(recordsTopView)
        
        let navigationBar = navigationController?.navigationBar as? IveNavigationBar
        assert(navigationBar != nil)
        
        if let navigationBar = navigationBar {
            mainStore.unsubscribe(navigationBar)
        }
    }
    
    @IBAction func goButtonTapped() {
        mainStore.dispatch(
            GoButtonTappedAction()
        )
    }
    
    @IBAction func historyButtonTapped() {
        mainStore.dispatch(
            ShowTasksListScreenFromRecordsAction()
        )
    }
    
    @IBAction func noteButtonTapped() {
        mainStore.dispatch(
            ShowTaskScreenFromRecordsAction()
        )
    }
}


extension RecordsViewController: StoreSubscriber {
    func newState(state: AppState.RecordScreenState) {
        goButton.isSelected = state.recordingOn
        goButton.isEnabled = state.selectedIdx != nil
        
        billButton.isEnabled = state.selectedIdx != nil
        
        switch state.screen {
        case .taskCreator:
            performSegue(withIdentifier: Constants.lTaskCreatorSegueId, sender: nil)
        case .taskList:
            performSegue(withIdentifier: Constants.lTaskListSegueId, sender: nil)
        default:break
        }
    }
    
    enum Constants {
        static let lTaskListSegueId = "lTaskListSegueId"
        static let lTaskCreatorSegueId = "lTaskCreatorSegueId"
    }
}
