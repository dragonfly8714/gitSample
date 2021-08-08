//
//  AppDelegate.swift
//  gitSample
//
//  Created by admin on 2021/08/07.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let navi = UINavigationController()
        navi.isNavigationBarHidden = true
        window?.rootViewController = navi
        let vc = SearchViewController()
        navi.pushViewController(vc, animated: false)
        return true
    }
}
