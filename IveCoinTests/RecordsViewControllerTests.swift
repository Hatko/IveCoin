//
//  RecordsViewControllerTests.swift
//  IveCoin
//
//  Created by vlad on 5/6/17.
//  Copyright © 2017 com.hat. All rights reserved.
//

import XCTest
import ReSwift
@testable import IveCoin

class RecordsViewControllerTests: XCTestCase {
    var sut: RecordsViewController!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        let navigationController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController") as! UINavigationController
        
        sut = navigationController.topViewController as! RecordsViewController
        
        _ = sut.view
        
        mainStore = MocStore<AppState>(reducer: mainReducerWithoutStoringState, state: nil)
    }
    
    func test_subscribeToStore_onWillAppear() {
        sut.beginAppearanceTransition(true, animated: false)
        
        XCTAssert(mocStore.subscribers.contains { $0 as? NSObject == sut.recordsTopView })
        XCTAssert(mocStore.subscribers.contains { $0 as? NSObject == sut })
        XCTAssert(mocStore.subscribers.contains { $0 as? NSObject == sut.navigationController!.navigationBar })
    }
    
    func test_unsubscribeToStore_onWillDisappear() {
        sut.beginAppearanceTransition(false, animated: false)
        
        XCTAssert(mocStore.unsubscribed.contains { $0 as? NSObject == sut.recordsTopView })
        XCTAssert(mocStore.unsubscribed.contains { $0 as? NSObject == sut })
        XCTAssert(mocStore.unsubscribed.contains { $0 as? NSObject == sut.navigationController!.navigationBar })
    }
    
    func test_sendStartRecordingAction_onNotSelectedGoButtonPressed() {
        _ = sut.view
        
        let goButton = sut.goButton!
        
        var action: Action = StandardAction(type: "")
        
        mainStore.dispatchFunction = { action = $0 }
        
        goButton.sendActions(for: .touchUpInside)
        
        XCTAssert(action is GoButtonTappedAction)
    }
}
