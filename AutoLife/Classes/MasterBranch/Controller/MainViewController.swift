//
//  MainViewController.swift
//  iAutoLife
//
//  Created by XuBupt on 16/4/24.
//  Copyright © 2016年 xubupt218. All rights reserved.
//

import UIKit

extension UIViewController {
    func setTabBarItemWith(title title: String?, image: UIImage?, selectedImage: UIImage?) {
        self.tabBarItem.image = image
        self.tabBarItem.selectedImage = selectedImage
        self.title = title
    }
}

class MainViewController: UITabBarController ,UITabBarControllerDelegate{
    
    var notification:(JSON,Bool) = (JSON.null,false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initTabBar()
    }
    
    //含UITabBarController时，子VC下的viewDidAppear不会被调用
    override func viewDidAppear(animated: Bool) {
        guard !notification.1 else {return}
        notification.1 = true
        if notification.0 != nil {
            let vc = Assistant.getShowedViewController()
            if self.notification.0["master"]["OutTime"] {
                let paymentVC = PaymentViewController()
                paymentVC.json = self.notification.0["master"]
                if vc.navigationController != nil {
                    vc.navigationController?.pushViewController(paymentVC, animated: true)
                }else {
                    self.presentViewController(UINavigationController.init(rootViewController: paymentVC), animated: true, completion: nil)
                }
            }else {
                AppDelegate.shareApplication.parkingVC = ParkingViewController()
                AppDelegate.shareApplication.parkingVC!.json = self.notification.0
                if vc.navigationController != nil {
                    vc.navigationController!.pushViewController(AppDelegate.shareApplication.parkingVC!, animated: true)
                }else {
                    self.presentViewController(UINavigationController.init(rootViewController: AppDelegate.shareApplication.parkingVC!), animated: true, completion: nil)
                }
            }
            
        }
    }
    
    func initTabBar() {
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        vc1.setTabBarItemWith(title: "车辆", image: UIImage(named: "vehicle"), selectedImage: nil)
        let vc2 = UINavigationController(rootViewController: UIViewController())
        vc2.setTabBarItemWith(title: "车位", image: UIImage(named: "carports"), selectedImage: nil)
        let vc3 = UINavigationController(rootViewController:InsuranceViewController())
        vc3.setTabBarItemWith(title: "保险", image: UIImage(named: "insurances"), selectedImage: nil)
        let vc4 = UINavigationController(rootViewController: UIViewController())
        vc4.setTabBarItemWith(title: "我的", image: UIImage(named: "mine"), selectedImage: nil)
        
        self.viewControllers = [vc1,vc2,vc3,vc4]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
