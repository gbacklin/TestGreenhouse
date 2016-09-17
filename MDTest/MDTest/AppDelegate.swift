//
//  AppDelegate.swift
//  MDTest
//
//  Created by Gene Backlin on 9/16/16.
//  Copyright © 2016 Gene Backlin. All rights reserved.
//

/***************************************************
 **           Code Signing with Travis            **
 ***************************************************
 **
 ** http://stackoverflow.com/questions/27671854/travis-ci-fails-to-build-with-a-code-signing-error
 **
 ***************************************************

.travis.yml
 
 language: objective-c
 osx_image: xcode8
 script:
 - xcodebuild -workspace TestGreenhouse.xcworkspace -scheme Release ONLY_ACTIVE_ARCH=NO
 before_script:
 - chmod a+x ./scripts/add-key.sh
 - sh ./scripts/add-key.sh
 # safelist
 branches:
 only:
 - Swift-3.0
 #This sends a slack notificatio to just me, you can configure easily
 notifications:
 slack: pathfindersoftware:rsq2vyDTwHR6wg54iVIpuH2u

 ***************************************************
 
 add-key.sh:
 
 #!/bin/sh
 # Create a custom keychain
 security create-keychain -p travis ios-build.keychain
 
 # Make the custom keychain default, so xcodebuild will use it for signing
 security default-keychain -s ios-build.keychain
 
 # Unlock the keychain
 security unlock-keychain -p travis ios-build.keychain
 
 # Set keychain timeout to 1 hour for long builds
 # see http://www.egeek.me/2013/02/23/jenkins-and-xcode-user-interaction-is-not-allowed/
 security set-keychain-settings -t 3600 -l ~/Library/Keychains/ios-build.keychain
 
 # Add certificates to keychain and allow codesign to access them
 security import ./scripts/certs/DeveloperCertificates.p12 -k ~/Library/Keychains/ios-build.keychain -P Password123 -T /usr/bin/codesign
 
 # Put the provisioning profile in place
 mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
 cp "./scripts/profile/MDTest_Dev_Prov_Profile.mobileprovision" ~/Library/MobileDevice/Provisioning\ Profiles/

 *************************************************/

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let splitViewController = self.window!.rootViewController as! UISplitViewController
        let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as! UINavigationController
        navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
        splitViewController.delegate = self
        return true
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

    // MARK: - Split view

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController else { return false }
        if topAsDetailController.detailItem == nil {
            // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
            return true
        }
        return false
    }

}

