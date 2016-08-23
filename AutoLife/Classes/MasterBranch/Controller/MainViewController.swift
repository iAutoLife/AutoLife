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
        let tabBar = XuTabBar(frame: CGRectZero)
        tabBar.selectedAction = { [weak self] in
            self?.selectedIndex = 2
        }
        self.setValue(tabBar, forKey: "tabBar")
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
        let vc1 = UINavigationController(rootViewController: CarViewController())
        vc1.setTabBarItemWith(title: "车辆", image: UIImage(named: "vehicle"), selectedImage: nil)
        let vc2 = UINavigationController(rootViewController: CarportViewController())
        vc2.setTabBarItemWith(title: "车位", image: UIImage(named: "carports"), selectedImage: nil)
        let vc3 = UINavigationController(rootViewController:HomeViewController())
        vc3.setTabBarItemWith(title: nil, image: nil, selectedImage: nil)
        let vc4 = UINavigationController(rootViewController:InsuranceViewController())
        vc4.setTabBarItemWith(title: "保险", image: UIImage(named: "insurances"), selectedImage: nil)
        let vc5 = UINavigationController(rootViewController: PersonalViewController())
        vc5.setTabBarItemWith(title: "我的", image: UIImage(named: "mine"), selectedImage: nil)
        
        self.viewControllers = [vc1,vc2,vc3,vc4,vc5]
        self.selectedIndex = 2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

class XuTabBar: UITabBar {
    
    let roundButton = UIButton.init(type: .Custom)
    var selectedAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        shadowImage = UIImage.init()
        backgroundImage = UIImage.init()
        self.insertSubview(drawBgImage(), atIndex: 0)
        self.opaque = true
        roundButton.frame = frame
        backgroundColor = UIColor.whiteColor()
        roundButton.setBackgroundImage(UIImage.init(named: "tabHome"), forState: .Normal)
//        roundButton.setBackgroundImage(UIImage.init(named: "tabHome"), forState: .Normal)
        roundButton.addTarget(self, action: #selector(roundBtnClicked(_:)), forControlEvents: .TouchUpInside)
        roundButton.adjustsImageWhenHighlighted = false
        self.addSubview(roundButton)
    }
    
    func roundBtnClicked (sender:UIButton) {
        selectedAction?()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let centerX = bounds.size.width * 0.5
        let centerY = bounds.size.height * 0.5
        roundButton.frame = CGRectMake(centerX - 32.5, centerY - 40, 65, 65)
        var index = 0
        let tabWidth = bounds.size.width / 5.0
        for view in subviews {
            print(object_getClass(view))
            let classes:AnyClass = NSClassFromString("UITabBarButton")!
            guard view.isKindOfClass(classes) else {return}
            var rect = view.frame
            rect.origin.x = CGFloat(index) * tabWidth
            view.frame = rect
            index += 1
            if index == 1 {
                index += 1
            }
        }
    }
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        if !hidden {
            if  touchPointInsideCircle(roundButton.center, radius: 30, point: point){
                return roundButton
            }
        }
        return super.hitTest(point, withEvent: event)
    }
    
    func touchPointInsideCircle(center:CGPoint, radius:CGFloat, point:CGPoint) -> Bool {
        let dict = sqrtf(Float((point.x - center.x) * (point.x - center.x) + (point.y - center.y) * (point.y - center.y)))
        return dict <= Float(radius)
    }
    
    func drawBgImage() -> UIImageView {
        let radius:CGFloat = 30
        let standOutHeight:CGFloat = 12
        let allFloat = (pow(Double(radius), 2) - pow((Double(radius) - Double(standOutHeight)), 2))
        let ww = CGFloat(sqrtf(Float(allFloat)))
        let imageView = UIImageView(frame: CGRectMake(0, -CGFloat(standOutHeight), UIScreen.mainScreen().bounds.width, self.frame.height + CGFloat(standOutHeight)))
        let size = imageView.frame.size
        let layer = CAShapeLayer()
        let path = UIBezierPath()
        path.moveToPoint(CGPointMake(size.width / 2 - ww, standOutHeight))
        print(ww)
        let angleH = (radius - standOutHeight) / radius * 0.5
        let startAngle = (1 + angleH) * CGFloat(M_PI)
        let endAngle = (2 - angleH) * CGFloat(M_PI)
        path.addArcWithCenter(CGPointMake(size.width / 2, radius), radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        path.addLineToPoint(CGPointMake(size.width / 2 + ww, standOutHeight))
        path.addLineToPoint(CGPointMake(size.width, standOutHeight))
        path.addLineToPoint(CGPointMake(size.width, size.height))
        path.addLineToPoint(CGPointMake(0, size.height))
        path.addLineToPoint(CGPointMake(0, standOutHeight))
        path.addLineToPoint(CGPointMake(size.width / 2 - ww, standOutHeight))
        layer.path = path.CGPath
        layer.fillColor = backgroundColor?.CGColor
        layer.strokeColor = UIColor(white: 0.765, alpha: 1).CGColor
        layer.lineWidth = 0.5
        imageView.layer.addSublayer(layer)
        return imageView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
