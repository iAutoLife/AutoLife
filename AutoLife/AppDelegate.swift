//
//  AppDelegate.swift
//  AutoLife
//
//  Created by 徐成 on 16/1/14.
//  Copyright © 2016年 徐成. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var parkingVC : ParkingViewController?
    var token:String?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        registerForPushNotifications(application)
        
        WXApi.registerApp("wxdd6af3fdcbde0c2a", withDescription: "iAuto-Life")
        MAMapServices.sharedServices().apiKey = XuAPIKey
        AMapSearchServices.sharedServices().apiKey = XuAPIKey
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.backgroundColor = UIColor.grayColor()
        let mainVC = MainViewController()
        self.window?.rootViewController = mainVC
        self.window?.makeKeyAndVisible()
        if let data = launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey]?["NEWS_CATEGORY"] {
            mainVC.notification.0 = JSON.init(data!)
        }
        
        if XuRegularExpression.isVaild(XuKeyChain.get(XuCurrentUser), fortype: XuRegularType.phone) {
        }
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        application.applicationIconBadgeNumber = 0
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        print(#function + "\n" + options.description)
        if url.host == "safepay" {
            AlipaySDK.defaultService().processOrderWithPaymentResult(url, standbyCallback: { (resultDic) -> Void in
                print("AppDelegate result = \(resultDic)")
            })
            return true
        }
        return WXApi.handleOpenURL(url, delegate: WXApiManager.sharedManager)
    }
    
    //MARK:-- NOTIFICATION
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != .None {
            application.registerForRemoteNotifications()
        }
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        print(#function + deviceToken.description)
        let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
        var tokenString = ""
        for i in 0..<deviceToken.length {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        setTokenValue(tokenString)
        
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("Failed to register:",error)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        print(#function + "\n" + userInfo.description)
        let js = JSON.init(userInfo["NEWS_CATEGORY"]!)
        parkingVC = ParkingViewController()
        let showedVC = Assistant.getShowedViewController()
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(500 * NSEC_PER_MSEC)), dispatch_get_main_queue()) {
            if js["master"]["OutTime"] {
                print(js)
                let paymentVC = PaymentViewController()
                paymentVC.json = js["master"]
                showedVC.presentViewController(UINavigationController.init(rootViewController: paymentVC), animated: true, completion: nil)
            }else {
                print("hhh")
                self.parkingVC!.json = js
                showedVC.presentViewController(UINavigationController.init(rootViewController: self.parkingVC!), animated: true, completion: nil)
            }
        }
    
        /*
        let alertVC = UIAlertController(title: "通知", message: "您有新消息", preferredStyle: .Alert)
        alertVC.addAction(UIAlertAction(title: "好的", style: .Cancel, handler: nil))
        alertVC.addAction(UIAlertAction(title: "查看", style: .Default, handler: {(_) in
            if js["master"]["OutTime"] {
                print(js)
                let paymentVC = PaymentViewController()
                paymentVC.json = js["master"]
                showedVC.presentViewController(UINavigationController.init(rootViewController: paymentVC), animated: true, completion: nil)
            }else {
                print("hhh")
                self.parkingVC!.json = js
                showedVC.presentViewController(UINavigationController.init(rootViewController: self.parkingVC!), animated: true, completion: nil)
            }
            }))
        showedVC.presentViewController(alertVC, animated: true, completion: nil)*/
    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
        print(#function + "\n" + userInfo.description)
    }
    
    func registerForPushNotifications(application: UIApplication) {
        let viewAction = UIMutableUserNotificationAction()
        viewAction.identifier = "VIEW_IDENTIFIER1"
        viewAction.title = "忽略"
        //当点击的时候不启动程序，在后台处理
        viewAction.activationMode = .Background
        //需要解锁才能处理(意思就是如果在锁屏界面收到通知，并且用户设置了屏幕锁，用户点击了赞不会直接进入我们的回调进行处理，而是需要用户输入屏幕锁密码之后才进入我们的回调)，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        viewAction.authenticationRequired = false
        /*
         destructive属性设置后，在通知栏或锁屏界面左划，按钮颜色会变为红色
         如果两个按钮均设置为YES，则均为红色（略难看）
         如果两个按钮均设置为NO，即默认值，则第一个为蓝色，第二个为浅灰色
         如果一个YES一个NO，则都显示对应的颜色，即红蓝双色 (CP色)。
         */
        viewAction.destructive = false
        
        let viewAction1 = UIMutableUserNotificationAction()
        viewAction1.identifier = "VIEW_IDENTIFIER2"
        viewAction1.title = "查看"
        viewAction1.activationMode = .Background
        viewAction1.authenticationRequired = true
        viewAction1.destructive = false
        //设置了behavior属性为 UIUserNotificationActionBehaviorTextInput 的话，则用户点击了该按钮会出现输入框供用户输入
        viewAction1.behavior = .TextInput
        viewAction1.parameters = [UIUserNotificationTextInputActionButtonTitleKey:"评论"]
        
        
        let newsCategory = UIMutableUserNotificationCategory()
        newsCategory.identifier = "NEWS_CATEGORY"
        //最多支持两个，如果添加更多的话，后面的将被忽略
        newsCategory.setActions([viewAction,viewAction1], forContext: .Minimal)
        let notificationSettings = UIUserNotificationSettings(forTypes: [.Badge, .Sound, .Alert], categories: [newsCategory])
        //        application.registerForRemoteNotifications()
        application.registerUserNotificationSettings(notificationSettings)
    }
    
    static var shareApplication = {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }()
    
    func setTokenValue(tokenString:String?) {
        token = tokenString
        if tokenString != nil {
            if let phone = XuKeyChain.get(XuCurrentUser) {      //如果已登录，则发送token到服务器记录
                guard phone != "" else {return}
                XuAlamofire.postParameters(AlStyle.uHeader + "applogin/setToken", parameters: ["phone":phone,"tokenString":tokenString!], successWithString: { (result) in
                    print(result)
                    }, failed: nil)
            }
        }
    }
}

