//
//  MocStore.swift
//  IveCoin
//
//  Created by vlad on 5/7/17.
//  Copyright © 2017 com.hat. All rights reserved.
//

import Foundation
import ReSwift
@testable import IveCoin

class MocStore<T: StateType>: Store<T> {
    var subscribers = [AnyObject]()
    var unsubscribed = [AnyObject]()
    
    override func subscribe<SelectedState, S>(_ subscriber: S, transform: ((Subscription<T>) -> Subscription<SelectedState>)?) where S : StoreSubscriber, S.StoreSubscriberStateType == SelectedState {
        subscribers.append(subscriber)
        
        super.subscribe(subscriber, transform: transform)
    }
    
    override func unsubscribe(_ subscriber: AnyStoreSubscriber) {
        unsubscribed.append(subscriber)
        
        super.unsubscribe(subscriber)
    }
}

func mainReducerWithoutStoringState(action: Action, state: AppState?) -> AppState {
    switch action {
    case is ReSwiftInit, is SaveStateAction:
        return mainReducer(action: StandardAction(type: "TestAction"), state: state)
    default:
        return mainReducer(action: action, state: state)
    }
}

var mocStore: MocStore<AppState> {
    return mainStore as! MocStore<AppState>
}
