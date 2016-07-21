//
//  MasterViewController.swift
//  AutoLife
//
//  Created by 徐成 on 15/10/29.
//  Copyright © 2015年 徐成. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController ,MAMapViewDelegate,AMapSearchDelegate,SubMasterViewDelegate{
    
    var mapView:XuMapView!//MAMapView!
    var search:AMapSearchAPI!
    var userLocation:CLLocation!
    var mapDelegate = MasterMapDelegate()
    
    lazy var movement:CGFloat = 0
    var secview:SubMasterView?
    var blackCoverView:UIView?
    var trackButton:UIButton!
    var stepper:XuStepper?
    var subMasterRecoginzerPan:UIPanGestureRecognizer?
    var subMasterRecoginzerTap:UITapGestureRecognizer?
    private var annotations:NSArray?{
        didSet{
            
        }
    }
    
    //MARK: --func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initMapView()
        self.initNavigationItemView()
    }
    
    //MARK: --UIGestureRecognizer
    func creatOriginalSubMasterView() {
        blackCoverView = UIView(frame: UIScreen.mainScreen().bounds)
        blackCoverView?.backgroundColor = UIColor.blackColor()
        blackCoverView!.alpha = 0
        subMasterRecoginzerTap = UITapGestureRecognizer(target: self, action: #selector(MasterViewController.tapBlackView(_:)))
        blackCoverView!.addGestureRecognizer(subMasterRecoginzerTap!)
        
        self.navigationController?.view.addSubview(blackCoverView!)
        secview = SubMasterView()
        secview?.delegate = self
        subMasterRecoginzerPan = UIPanGestureRecognizer(target: self, action: #selector(MasterViewController.panSubMasterView(_:)))
        secview?.addGestureRecognizer(subMasterRecoginzerPan!)
        self.navigationController?.view.addSubview(secview!)
        secview!.center.x = -self.view.center.x
    }
    
    func panRecognizer(panRecognizer:UIPanGestureRecognizer) {
        let movementX = panRecognizer.translationInView(panRecognizer.view).x
        if movementX > 0 && secview == nil{
            self.creatOriginalSubMasterView()
        }
        guard secview != nil else {return}
        if movement < AlStyle.size.width * 2 / 3 {
            secview?.center.x += (movementX - movement)
            movement = movementX
            blackCoverView?.alpha = movement / self.view.frame.width
        }
        
        if panRecognizer.state == UIGestureRecognizerState.Ended {
            if secview != nil {
                if movement > AlStyle.size.width / 3 {
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        self.secview?.center.x = AlStyle.size.width / 6
                        self.blackCoverView?.alpha = 2/3
                        }, completion: { (_) -> Void in
                            self.movement = 0
                    })
                }else {
                    self.movement = 0
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        self.blackCoverView?.alpha = 0
                        self.secview?.center.x = -AlStyle.size.width/2
                        }, completion: { (_) -> Void in
                            self.subMasterViewDidDisAppear()
                    })
                }
            }
        }
    }
    
    func longPressRecoginzer(sender:UILongPressGestureRecognizer) {
        
    }
    
    func subMasterViewDidDisAppear() {
        self.blackCoverView?.removeFromSuperview()
        self.blackCoverView?.removeGestureRecognizer(self.subMasterRecoginzerTap!)
        self.secview?.removeFromSuperview()
        self.secview?.removeGestureRecognizer(self.subMasterRecoginzerPan!)
        self.blackCoverView = nil
        self.secview = nil
        self.movement = 0
    }
    
    func tapBlackView(recoginzer:UITapGestureRecognizer) {
        if self.blackCoverView != nil {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.blackCoverView?.alpha = 0
                self.secview?.center.x = -AlStyle.size.width/2
                }, completion: { (_) -> Void in
                    self.blackCoverView?.removeFromSuperview()
                    self.secview?.removeFromSuperview()
                    self.blackCoverView = nil
                    self.secview = nil
            })
        }
    }
    
    func panSubMasterView(sender:UIPanGestureRecognizer) {
        let moved = sender.translationInView(sender.view).x
        if moved < 0 {
            if secview != nil && blackCoverView != nil {
                secview?.center.x = AlStyle.size.width / 6 + moved
                blackCoverView?.alpha = 2 / 3 + moved / AlStyle.size.width
            }
        }
        if sender.state == UIGestureRecognizerState.Ended {
            if fabs(moved) > AlStyle.size.width / 6 {
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.blackCoverView?.alpha = 0
                    self.secview?.center.x = -AlStyle.size.width/2
                    }, completion: { (_) -> Void in
                        self.subMasterViewDidDisAppear()
                })
            }else {
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.secview?.center.x = AlStyle.size.width / 6
                    self.blackCoverView?.alpha = 2/3
                    }, completion: nil)
            }
        }
    }
    
    //MARK: --ControllerAction
    func showSubMasterView(sender:UIBarButtonItem) {
        self.creatOriginalSubMasterView()
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.blackCoverView?.alpha = 2 / 3
            self.secview?.center.x = AlStyle.size.width / 6
            }, completion: nil)
    }
    
    func showMessageView(sender:UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
//        let messageVC = MessageViewController()
//        self.navigationController?.pushViewController(messageVC, animated: true)
    }
    
    func hideSubMasterView(sender:NSObject) {
        self.subMasterViewDidDisAppear()
    }
    
    func parkingSearch(sender:UIButton) {   //周边搜索
        if mapView.annotations.count > 0 {
            mapView.removeAnnotations(mapView.annotations)
            return
        }
        AMapSearchServices.sharedServices().apiKey = XuAPIKey
        //let search = AMapSearchAPI()
        //search.delegate = self
        let request = AMapPOIAroundSearchRequest()
        request.location = AMapGeoPoint.locationWithLatitude(
            CGFloat(mapDelegate.userLocation.coordinate.latitude),
            longitude: CGFloat(mapDelegate.userLocation.coordinate.longitude))
        request.keywords = "停车场"
        request.types = "汽车服务"
        request.sortrule = 0
        request.requireExtension = true
        search.AMapPOIAroundSearch(request)
    }
    
    //加油站搜索
    func fuellingSearch(sender:UIButton) {
        
    }
    
    //MARK: --MAMapViewDelegate
    func mapView(mapView: MAMapView!, didChangeUserTrackingMode mode: MAUserTrackingMode, animated: Bool) {
        if trackButton != nil {
            if mode == MAUserTrackingMode.Follow {
                trackButton.setImage(UIImage(named: "track_on"), forState: UIControlState.Normal)
            }else if mode == MAUserTrackingMode.None {
                trackButton.setImage(UIImage(named: "track_off"), forState: UIControlState.Normal)
            }
        }
    }
    
    func mapView(mapView: MAMapView!, didUpdateUserLocation userLocation: MAUserLocation!, updatingLocation: Bool) {
        if updatingLocation {
            self.userLocation = userLocation.location
        }
    }
    
    //MARK: --AMapSearchDelegate
    func onPOISearchDone(request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        if response.pois.count == 0 { return }
        self.annotations = response.pois
        print(response.pois.count)
        print(response.suggestion.keywords)
        print(response.suggestion.cities)
        for ele in response.pois {
            if let poi = ele as? AMapPOI {
                print("name:\(poi.name)>>>>>>location:\(poi.location.latitude)")
            }
        }
    }
    
    func onRouteSearchDone(request: AMapRouteSearchBaseRequest!, response: AMapRouteSearchResponse!) {
        print(response.route)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MasterViewController.hideSubMasterView(_:)), name: NotificationOfHideSubMaster, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    //MARK: -- SubMasterViewDelegate
    func SubMasterClicked(index: Int) {
        switch index {
        case 0: self.navigationController?.pushViewController(PersonalViewController(), animated: true)
        case 1: self.navigationController?.pushViewController(PayViewController(), animated: true)
        case 2: self.navigationController?.pushViewController(ParkingRecordViewController(), animated: true)
        case 3: self.navigationController?.pushViewController(CarViewController(), animated: true)
        case 4: self.navigationController?.pushViewController(CarportViewController(), animated: true)
        case 5: self.navigationController?.pushViewController(ViolationViewController(), animated: true)
        case 6: self.navigationController?.pushViewController(InsuranceViewController(), animated: true)
        case 7: self.navigationController?.pushViewController(PersonalViewController(), animated: true)
        case 8: self.navigationController?.pushViewController(PersonalViewController(), animated: true)
        case 9: self.navigationController?.pushViewController(SettingViewController(), animated: true)
        default:break
        }
    }
    
    //MARK: --initview
    
    func initNavigationItemView() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "head_protraits"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(MasterViewController.showSubMasterView(_:)))   //head_protraits
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "message_off"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(MasterViewController.showMessageView(_:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "主页", style: .Plain, target: self, action: #selector(showMessageView(_:)))
        self.navigationItem.titleView = MapTitleView(city: "北京", text: "今日限行0/5")
        
        self.search = AMapSearchAPI()
        search.delegate = mapDelegate
        
        let view = UIView(frame: CGRectMake(0, 0, 50, mapView.frame.height - 100))
        view.backgroundColor = UIColor.clearColor()
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(MasterViewController.panRecognizer(_:)))
        view.addGestureRecognizer(panRecognizer)
        mapView.addSubview(view)
    }
    
    func initMapView() {
        self.mapView = XuMapView(frame: CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64))
        self.view.addSubview(mapView)
        mapView.delegate = mapDelegate
        mapDelegate.mapView = mapView
        mapView.showsUserLocation = true
        mapView.userTrackingMode = MAUserTrackingMode.Follow
        mapView.headingFilter = 5
        mapView.desiredAccuracy = kCLLocationAccuracyKilometer
        
//        let searchBar = UISearchBar(frame: CGRectMake(0,0,AlStyle.size.width,40))
//        searchBar.searchBarStyle = UISearchBarStyle.Minimal
//        //searchBar.translucent = true
//        searchBar.placeholder = "搜索"
//        mapView.addSubview(searchBar)
        
        mapView.compassOrigin = CGPointMake(10, 35)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(MasterViewController.longPressRecoginzer(_:)))
        mapView.addGestureRecognizer(longPress)
        
        for i in 0 ..< 2 {
            let imageName = (i == 0 ? "parking" : "fuelling")
            let selector:Selector = (i == 0 ? #selector(MasterViewController.parkingSearch(_:)) : #selector(MasterViewController.fuellingSearch(_:)))
            let button = UIButton(type: UIButtonType.Custom)
            button.frame = CGRectMake(mapView.frame.width - 45, mapView.frame.height - 300 + CGFloat(i) * 45, 40, 40)
            button.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
            button.addTarget(self, action: selector, forControlEvents: UIControlEvents.TouchUpInside)
            mapView.addSubview(button)
        }
        
        let carMaster = CarMaster(logo: UIImage(named: "fute")!, plate: "京P23C8", timesOfViolation: 1, scoresOfViolation: 6, timeParking: "9:20:20", revenue: 25.00)
        let footView = FootMenuView(carmaster: carMaster)
        footView.center = CGPointMake(mapView.center.x, mapView.frame.height - 40)
        self.mapView.addSubview(footView)
        footView.footerViewClicked = {
            (type) in
            switch type {
            case .brand:
                let carVC = CarViewController()
                self.navigationController?.pushViewController(carVC, animated: true)
            case .violation:
                let violationVC = ViolationViewController()
                self.navigationController?.pushViewController(violationVC, animated: true)
            case .parkTime:
                self.navigationController?.pushViewController(ParkStateViewController(), animated: true)
            case .revenue:
                let carportVC = CarportShareViewController()
                self.navigationController?.pushViewController(carportVC, animated: true)
            }
        }
    }
}

class MapTitleView: UIView {
    var locaBtn:UIButton!
    var titleLabel:UILabel!
    
    init(city:String,text:String) {
        super.init(frame: CGRectMake(0, 0, 100, 44))
        locaBtn = UIButton(type: .Custom)
        locaBtn.frame = CGRectMake(0, 0, 100, 20)
        locaBtn.buttonWithLeft(city, right: UIImage(named: "drop"))
        self.addSubview(locaBtn)
        locaBtn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        locaBtn.titleLabel?.font = AlStyle.font.big
        
        let label = UILabel(frame: CGRectMake(0,22,100,20))
        label.font = AlStyle.font.normal
        label.textAlignment = NSTextAlignment.Center
        label.text = text
        self.addSubview(label)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
