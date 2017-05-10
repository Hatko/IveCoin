//
//  TaskViewControllerTests.swift
//  IveCoin
//
//  Created by vlad on 5/10/17.
//  Copyright © 2017 com.hat. All rights reserved.
//

import XCTest
import ReSwift
@testable import IveCoin

class TaskViewControllerTests: XCTestCase {
    var sut: TaskCreatorViewController!
    var navigationController: UINavigationController?
    
    override func setUp() {
        super.setUp()
        
        sut = TaskCreatorViewController.storyboardController()
        
        navigationController = UINavigationController(rootViewController: sut)
        
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
}
