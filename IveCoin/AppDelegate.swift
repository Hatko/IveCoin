//
//  AppDelegate.swift
//  IveCoin
//
//  Created by vlad on 5/6/17.
//  Copyright © 2017 com.hat. All rights reserved.
//

import UIKit
import ReSwift

var mainStore = Store<AppState>(reducer: mainReducer, state: nil)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        mainStore.dispatch(
            SaveStateAction()
        )
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        mainStore.dispatch(
            ApplicationDidBecomeActiveAction()
        )
    }
}

