//
//  XuPointAnnotation.swift
//  AutoLife
//
//  Created by 徐成 on 15/12/14.
//  Copyright © 2015年 徐成. All rights reserved.
//

import UIKit

class XuPointAnnotation: MAPointAnnotation {
    
    var poi:AMapPOI?
    
    init(poi:AMapPOI) {
        super.init()
        self.coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(poi.location.latitude), CLLocationDegrees(poi.location.longitude))
        self.title = poi.name
        self.subtitle = "\(poi.enterLocation)"
        print(poi.uid)
        print(poi.location)
    }

}
