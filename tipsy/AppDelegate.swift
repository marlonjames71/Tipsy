//
//  AppDelegate.swift
//  tipTester
//
//  Created by Marlon Raskin on 6/2/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

// TODO: Add functionality to share app

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?


	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		DefaultsManager.migrateDefaults()
		addShortcuts(application: application)
		return true
	}

	func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
		switch shortcutItem.type {
		case "Marlon-Raskin.tipsy.reviewAction":
			let settingsVC = SettingsTableViewController()
			settingsVC.navigateToComposeAppStoreRating()
		case "Marlon-Raskin.tipsy.shareAction":
			let appID = "1486290417"
			let urlStr = "https://itunes.apple.com/app/id\(appID)"
			let items = [URL(string: urlStr)!]
			let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
			window?.rootViewController?.present(ac, animated: true)
		case "Marlon-Raskin.tipsy.openSettingsAction":
			let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
			let settingsVC = storyboard.instantiateViewController(withIdentifier: "SettingsTableViewController")
			if let navController = window?.rootViewController as? UINavigationController {
				for vc in navController.viewControllers where vc is SettingsTableViewController {
					return
				}
				navController.pushViewController(settingsVC, animated: true)
			}
		default:
			break
		}
	}

	func addShortcuts(application: UIApplication) {
		let icon = UIApplicationShortcutIcon(systemImageName: "gear")
		let settingsShortcut = UIMutableApplicationShortcutItem(type: "Marlon-Raskin.tipsy.openSettingsAction", localizedTitle: "Open Settings", localizedSubtitle: nil, icon: icon, userInfo: nil)
		application.shortcutItems = [settingsShortcut]

	}

	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}


}

