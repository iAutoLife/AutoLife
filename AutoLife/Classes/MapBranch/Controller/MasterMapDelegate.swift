//
//  MasterMapDelegate.swift
//  AutoLife
//
//  Created by 徐成 on 16/1/15.
//  Copyright © 2016年 徐成. All rights reserved.
//

import UIKit

class MasterMapDelegate: NSObject ,AMapSearchDelegate,MAMapViewDelegate{
    
    private var userAnnotationView:MAAnnotationView?
    var userLocation = CLLocation(latitude: 39.990459, longitude: 116.481476)
    private var poi:NSArray?
    var mapView:XuMapView?
    private var xAnnotations:NSArray?
    
    //MARK: --MAMapViewDelegate
    func mapView(mapView: MAMapView!, didChangeUserTrackingMode mode: MAUserTrackingMode, animated: Bool) {
        guard let mv = mapView as? XuMapView else {return}
        if mode == MAUserTrackingMode.Follow {
            mv.trackButton?.setImage(UIImage(named: "track_on"), forState: UIControlState.Normal)
        }else if mode == MAUserTrackingMode.None {
            mv.trackButton?.setImage(UIImage(named: "track_off"), forState: UIControlState.Normal)
        }
    }
    
    func mapView(mapView: MAMapView!, regionDidChangeAnimated animated: Bool) {
        self.mapView?.stepper?.value = mapView.zoomLevel
    }
    
    func mapView(mapView: MAMapView!, didUpdateUserLocation userLocation: MAUserLocation!, updatingLocation: Bool) {
        if userLocation.heading != nil {
            self.userAnnotationView?.transform = CGAffineTransformMakeRotation(CGFloat(userLocation.heading.trueHeading * M_PI / 180))
        }
        if updatingLocation {
            self.userLocation = userLocation.location
        }
    }
    
    func mapView(mapView: MAMapView!, viewForAnnotation annotation: MAAnnotation!) -> MAAnnotationView! {
        switch annotation {
        case is MAUserLocation:
            print("update user")
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("user")
            if annotationView == nil {
                annotationView = MAAnnotationView(annotation: annotation, reuseIdentifier: "user")
            }
            annotationView?.image = UIImage(named: "user_location")
            self.userAnnotationView = annotationView
            return annotationView
        case is XuPointAnnotation:
            let reuseIdentifier = "point"
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseIdentifier) as? XuAnnotationView
            if annotationView == nil {
                annotationView = XuAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            }
            annotationView?.image = UIImage(named: "location_red")
            let k = self.xAnnotations?.indexOfObject(annotation as! XuPointAnnotation)
            annotationView?.setAnnotationIndex("\(k! + 1)")
            return annotationView
        default:break
        }
        return MAAnnotationView()
    }
    
    func mapView(mapView: MAMapView!, didSelectAnnotationView view: MAAnnotationView!) {
        print(self.xAnnotations?.indexOfObject(view.annotation as! XuPointAnnotation))
        guard let annoation = view.annotation as? XuPointAnnotation else {return}
        mapView.setCenterCoordinate(CLLocationCoordinate2D(latitude:
            CLLocationDegrees((annoation.poi?.location.latitude)!), longitude: CLLocationDegrees((annoation.poi?.location.longitude)!)), animated: true)
        switch view {
        //case is MAAnnotationView:break
        default:break
        }
    }
    
    //MARK: --AMapSearchDelegate
    func onPOISearchDone(request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        if response.pois.count == 0 { return }
        self.poi = response.pois
        print(response.pois.count)
        let annotations:NSMutableArray = []
        for ele in response.pois {
            if let poi = ele as? AMapPOI {
                //print("name:\(poi.name)>>>>>>location:\(poi.location.latitude)")
               // if poi.hasIndoorMap {
                    
                    annotations.addObject(XuPointAnnotation(poi: poi))
               // }
            }
            //if annotations.count == 10 {break}
        }
        self.setAnnotations(annotations)
    }
    
    func onRouteSearchDone(request: AMapRouteSearchBaseRequest!, response: AMapRouteSearchResponse!) {
        print(response.route)
    }
    
    //MARK: --func
    func setAnnotations(xarray:NSArray) {
        if self.xAnnotations?.count > 0 {
            self.mapView?.removeAnnotations(self.xAnnotations as! [AnyObject])
            self.xAnnotations = NSArray()
        }
        self.xAnnotations = xarray
        self.mapView?.addAnnotations(self.xAnnotations as! [AnyObject])
    }
    
    //MARK: --init
//    override init() {
//        super.init()
//        var onceToken:dispatch_once_t = 0
//        dispatch_once(&onceToken) { () -> Void in
//            let after = dispatch_time(DISPATCH_TIME_NOW, Int64(5 * NSEC_PER_USEC))
//            dispatch_after(after, dispatch_get_main_queue(), { () -> Void in
//                guard let vc = XuAssistantSwift.getCurrentViewController() as? MasterViewController else {return}
//                self.currentVC = vc
//            })
//        }
//    }
}
