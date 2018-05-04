//
//  AppDelegate.swift
//  CallKitSample
//
//  Created by lcs-developer on 2018/05/04.
//  Copyright © 2018年 takapika. All rights reserved.
//

import UIKit
import CallKit  // add

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var callObserver: CXCallObserver!   // add
    var bgTask = UIBackgroundTaskIdentifier()   // add
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // add
        callObserver = CXCallObserver()
        callObserver.setDelegate(self, queue: nil)
        // callObserver.setDelegate(self, queue: DispatchQueue(label: "com.taka2488.app.queue1"))    // 画面キャプチャを取る場合はメインスレッドじゃないとダメ
        // add
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

        self.bgTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            UIApplication.shared.endBackgroundTask(self.bgTask)
            self.bgTask = UIBackgroundTaskInvalid
        })

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
    
    
    private func getScreenShot() -> UIImage {
        let rect = self.window?.bounds
        UIGraphicsBeginImageContextWithOptions((rect?.size)!, false, 0.0)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        self.window?.layer.render(in: context)
        let capturedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return capturedImage
    }
    
}

// add
extension AppDelegate: CXCallObserverDelegate {
    func callObserver(_ callObserver: CXCallObserver, callChanged call: CXCall) {
        if call.hasEnded == true {
            print("Disconnected")

            // capture
            let captureImage = getScreenShot() as UIImage
            print("capture image")
  
            //キャプチャ画像をフォトアルバムへ保存
            UIImageWriteToSavedPhotosAlbum(captureImage, nil, nil, nil);
        }
        if call.isOutgoing == true && call.hasConnected == false {
            print("Dialing")
        }
        if call.isOutgoing == false && call.hasConnected == false && call.hasEnded == false {
            print("Incoming")
            
            // capture
            let captureImage = getScreenShot() as UIImage
            print("capture image")
            
            //キャプチャ画像をフォトアルバムへ保存
            UIImageWriteToSavedPhotosAlbum(captureImage, nil, nil, nil);

        }
        if call.hasConnected == true && call.hasEnded == false {
            print("Connected")
        }
    }
}
// add
