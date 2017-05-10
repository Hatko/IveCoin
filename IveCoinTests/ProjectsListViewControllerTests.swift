//
//  ProjectsListViewControllerTests.swift
//  IveCoin
//
//  Created by vlad on 5/7/17.
//  Copyright © 2017 com.hat. All rights reserved.
//

import XCTest
import ReSwift
@testable import IveCoin

class ProjectsListViewControllerTests: XCTestCase {
    var sut: ProjectsListViewController!
    
    override func setUp() {
        super.setUp()
        
        sut = ProjectsListViewController.storyboardController()
        
        mainStore = MocStore<AppState>(reducer: mainReducerWithoutStoringState, state: nil)
    }
    
    func test_subscribeToStore_onWillAppear() {
        sut.beginAppearanceTransition(true, animated: false)
        
        XCTAssert(mocStore.subscribers.contains { $0 as? NSObject == sut })
    }
    
    func test_unsubscribeToStore_onWillDisappear() {
        sut.beginAppearanceTransition(false, animated: false)
        
        XCTAssert(mocStore.unsubscribed.contains { $0 as? NSObject == sut })
    }
    
    func test_displayAllProjects_fromState() {
        let projects = setSutAndReturnProjects()
        
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), projects.count)
    }
    
    func test_addNewProjectToStore_onAction() {
        var addedProject: Project?
        
        func mocMainReducer(action: Action, state: AppState?) -> AppState {
            let appState = mainReducerWithoutStoringState(action: action, state: state)
            
            addedProject = appState.projectsState.projects.first
            
            return appState
        }
        
        mainStore = Store<AppState>(reducer: mocMainReducer, state: nil)
        
        let testProject = Project(name: "Test project", rateInCents: 35)
        
        mainStore.dispatch(
            AddNewProjectAction(newProject: testProject)
        )
        
        XCTAssertEqual(testProject, addedProject)
    }
    
    func test_ramoveProjectFromStore_onAction() {
        var allProjects = [Project]()
        
        let testProject1 = Project(name: "Test project1", rateInCents: 35)
        let testProject2 = Project(name: "Test project2", rateInCents: 35)
        
        func mocMainReducer(action: Action, state: AppState?) -> AppState {
            let appState = mainReducerWithoutStoringState(action: action, state: state)
            
            allProjects = appState.projectsState.projects
            
            return appState
        }
        
        mainStore = Store<AppState>(reducer: mocMainReducer, state: nil)
        
        mainStore.dispatch(
            AddNewProjectAction(newProject: testProject1)
        )
        
        mainStore.dispatch(
            AddNewProjectAction(newProject: testProject2)
        )
        
        mainStore.dispatch(
            RemoveProjectAction(projectIndex: 1)
        )
        
        XCTAssertEqual(allProjects, [testProject1])
    }
    
    func test_sendSelectAction_onDidSelectRow() {
        var action: Action = StandardAction(type: "")
        
        mainStore.dispatchFunction = { action = $0 }
        
        _ = sut.view
        
        let projectIdx = 2
        
        sut.tableView(sut.tableView, didSelectRowAt: IndexPath(row: projectIdx, section: 0))
        
        guard let selectAction = action as? SelectProjectAction else {
            XCTFail("incorrect message sent, or no message")
            return
        }
        
        XCTAssertEqual(selectAction.projectIndex, projectIdx)
    }
    
    func test_cellChargedWithCorrectObject() {
        class MocProjectTableViewCell: ProjectTableViewCell {
            var project: Project?
            
            override func charge(withProject p: Project) {
                project = p
            }
        }
        
        class MocTableView: UITableView {
            var testCell: MocProjectTableViewCell!
            
            override func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell {
                return testCell
            }
        }
        
        let projects = setSutAndReturnProjects()
        
        let testCell = MocProjectTableViewCell()
        let mocTableView = MocTableView()
        mocTableView.dataSource = sut.tableView.dataSource
        mocTableView.testCell = testCell
        
        sut.tableView = mocTableView
        
        // force tableView dequeue cell
        _ = sut.tableView(mocTableView, cellForRowAt: IndexPath(row: 0, section: 0))
        
        guard let project = testCell.project else {
            XCTFail("project is nil - didn't set")
            return
        }
        XCTAssertEqual(projects[0], project)
    }
}


extension ProjectsListViewControllerTests {
    func setSutAndReturnProjects() -> [Project] {
        let projects = [Project(name: "test", rateInCents: 10, totalTimeSpentInSeconds: 10)]
        
        func mocMainReducer(action: Action, state: AppState?) -> AppState {
            var appState = mainReducerWithoutStoringState(action: action, state: state)
            
            appState.projectsState.projects = projects
            
            return appState
        }
        
        mainStore = Store<AppState>(reducer: mocMainReducer, state: nil)
        
        _ = sut.view
        
        sut.beginAppearanceTransition(true, animated: false)
        
        return projects
    }
}
