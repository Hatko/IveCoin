//
//  TaskViewController.swift
//  IveCoin
//
//  Created by vlad on 5/10/17.
//  Copyright © 2017 com.hat. All rights reserved.
//

import UIKit
import ReSwift

class TaskViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textView: UITextView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        textField.becomeFirstResponder()
        
        mainStore.subscribe(self) { $0.select { $0.taskViewScreenState } }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        mainStore.unsubscribe(self)
    }
    
    @IBAction func cancelButtonTapped() {
        mainStore.dispatch(
            PopTaskViewScreenAction()
        )
    }
}


extension TaskViewController: StoreSubscriber {
    func newState(state taskViewScreenState: AppState.TaskViewScreenState) {
        if taskViewScreenState.screen != .taskView {
            assert(navigationController != nil)
            
            navigationController?.popViewController(animated: true)
        }
        
        assert(taskViewScreenState.task != nil, "Task must be selected before pushing this VC")
        
        textField.text = taskViewScreenState.task?.name
        textView.text = taskViewScreenState.task?.note
    }
}
