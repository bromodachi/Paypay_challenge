//
//  AppDelegate.swift
//  CurrencyExchange
//
//  Created by Conrado Uraga on 2019/04/13.
//  Copyright © 2019 Conrado Uraga. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //MARK: Setup window.
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        
        let controller = CurrencyCheckerVC()
        controller.view.backgroundColor = UIColor.white
        let navigationController = UINavigationController(rootViewController: controller)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        return true
    }
}

