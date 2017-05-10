//
//  ProjectsListViewController.swift
//  IveCoin
//
//  Created by vlad on 5/7/17.
//  Copyright © 2017 com.hat. All rights reserved.
//

import UIKit
import ReSwift

class ProjectsListViewController: UIViewController, StoreSubscriber {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addProjectButton: UIButton!

    fileprivate var projects = [Project]()
    fileprivate var selectedProjectIdx: Int?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mainStore.subscribe(self) { state in
            state.select { $0.projectsState }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        mainStore.unsubscribe(self)
    }
    
    @IBAction func addProjectButtonTapped() {
        showProjectCreatorAlertController()
    }
    
    func showProjectCreatorAlertController() {
        let alertController = UIAlertController(title: "Your new project", message: "With name:", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Save", style: .default) { [unowned alertController] action in
            guard let nameText = alertController.textFields?[0].text, !nameText.isEmpty else { return }
            guard let priceText = alertController.textFields?[1].text, !priceText.isEmpty else { return }
            guard let price = Float(priceText) else { return }
            
            let newProject = Project(name: nameText, rateInCents: Int(price * 100))
            
            mainStore.dispatch(
                AddNewProjectAction(newProject: newProject)
            )
        })
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alertController.addTextField { textField in
            textField.placeholder = "Name"
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "Rate in $"
            textField.keyboardType = .decimalPad
        }
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: StoreSubscriber
    
    func newState(state projectState: AppState.ProjectsState) {
        projects = projectState.projects
        
        selectedProjectIdx = projectState.selectedIdx
        
        tableView.reloadData()
    }
}


extension ProjectsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mainStore.dispatch(
            SelectProjectAction(projectIndex: indexPath.row)
        )
        
        mainStore.dispatch(
            ShowTaskScreenFromListAction()
        )
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return [UITableViewRowAction(style: .destructive, title: "Delete") { action, indexPath in
            mainStore.dispatch(
                RemoveProjectAction(projectIndex: indexPath.row)
            )
        }]
    }
}


extension ProjectsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.lProjectCellId, for: indexPath) as? ProjectTableViewCell else {
            fatalError("incorrect cell")
        }
        
        cell.charge(withProject: projects[indexPath.row])
        cell.highlight(selectedProjectIdx == indexPath.row)
        
        return cell
    }
    
    
    enum Constants {
        static let lProjectCellId = "lProjectCellId"
    }
}
