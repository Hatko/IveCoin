//
//  TaskCreatorViewController.swift
//  IveCoin
//
//  Created by vlad on 5/8/17.
//  Copyright © 2017 com.hat. All rights reserved.
//

import UIKit
import ReSwift

class TaskCreatorViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textView: UITextView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        textField.becomeFirstResponder()
        
        mainStore.subscribe(self) { $0.select { $0.taskCreatorScreenState } }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        mainStore.unsubscribe(self)
    }
    
    @IBAction func cancelButtonTapped() {
        mainStore.dispatch(
            PopTaskCreatorScreenAction()
        )
    }
    
    @IBAction func saveMilestoneButtonTapped() {
        guard let name = textField.text, !name.isEmpty else { return }
        
        mainStore.dispatch(
            SaveTaskAction(name: name, note: textView.text)
        )
    }
}


extension TaskCreatorViewController: StoreSubscriber, ErrorPresenter {
    func newState(state taskCreatorScreenState: AppState.TaskCreatorScreenState) {
        switch taskCreatorScreenState.projectStateStatus {
        case .taskLogged:
            // TODO: find a better way
            mainStore.dispatch(
                RespondToStatusAction()
            )
            mainStore.dispatch(
                PopTaskCreatorScreenAction()
            )
        case .noTimeToLog:
            showErrorMessage("No reason to create a record with an empty time label") {
                mainStore.dispatch(
                    RespondToStatusAction()
                )
            }
        default:
            break
        }
        
        if taskCreatorScreenState.screen != .taskCreator {
            assert(navigationController != nil)
            
            navigationController?.popViewController(animated: true)
        }
    }
}
