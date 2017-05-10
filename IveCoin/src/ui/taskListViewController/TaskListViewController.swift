//
//  TaskListViewController.swift
//  IveCoin
//
//  Created by vlad on 5/9/17.
//  Copyright © 2017 com.hat. All rights reserved.
//

import UIKit
import ReSwift

class TaskListViewController: UIViewController, StoreSubscriber {
    @IBOutlet var taskListDataSource: TaskListDataSource!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        mainStore.subscribe(self) { $0.select { $0.screen } }
        mainStore.subscribe(taskListDataSource) { $0.select { $0.projectsState.projects } }
        
        mainStore.dispatch(
            SelectTaskAction(selectedTask: nil)
        )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        mainStore.unsubscribe(self)
        mainStore.unsubscribe(taskListDataSource)
    }
    
    @IBAction func closeButtonTapped() {
        mainStore.dispatch(
            PopTasksListScreenAction()
        )
    }
    
    
    // MARK: StoreSubscriber
    
    func newState(state screen: AppState.Screen) {
        switch screen {
        case .taskView:
            performSegue(withIdentifier: Constants.lTaskSegueId, sender: nil)
        case .records:
            assert(navigationController != nil)
            
            navigationController?.popViewController(animated: true)
        default:
            break
        }
    }
    
    
    enum Constants {
        static let lTaskSegueId = "lTaskSegueId"
    }
}


class TaskListDataSource: NSObject, UITableViewDataSource, UITableViewDelegate, StoreSubscriber {
    @IBOutlet weak var tableView: UITableView?
    
    private var projects = [Project]()
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mainStore.dispatch(
            SelectTaskAction(selectedTask: projects[indexPath.section].tasks[indexPath.row])
        )
    
        mainStore.dispatch(
            ShowTaskScreenFromListAction()
        )
    }
    
    
    // MARK: StoreSubscriber
    
    func newState(state projects: [Project]) {
        self.projects = projects
        
        tableView?.reloadData()
    }
    
    
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return projects.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects[section].tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.lTaskInfoCellId, for: indexPath) as? TaskTableViewCell else { fatalError("incorrect cell") }
        
        cell.charge(withTask: projects[indexPath.section].tasks[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return projects[section].name
    }
    
    
    enum Constants {
        static let lTaskInfoCellId = "lTaskInfoCellId"
    }
}
