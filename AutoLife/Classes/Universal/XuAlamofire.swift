//
//  XuAlamofire.swift
//  AutoLife
//
//  Created by xubupt218 on 16/1/18.
//  Copyright © 2016年 徐成. All rights reserved.
//

import UIKit
import Alamofire

class XuAlamofire: NSObject {
    
    class func getString(url:String,success:(String?)->Void,failed:(NSError)->Void) {
        let request = Alamofire.request(.GET, url)
        request.responseString { (xRe) -> Void in
            if xRe.result.error != nil {
                failed(xRe.result.error!)
                return
            }
            success(xRe.result.value)
        }
    }
    
    class func getJSON(url:String,success:(JSON?)->Void,failed:(NSError)->Void) {
        let request = Alamofire.request(.GET, url)
        request.responseJSON { (xRe) -> Void in
            if xRe.result.error != nil {
                failed(xRe.result.error!)
                return
            }
            if xRe.result.value != nil {
                success(JSON(xRe.result.value!))
            }
        }
    }
    
    class func postParameters(url:String,parameters:[String:AnyObject]?,reString success:(String?)->Void,failed:(NSError)->Void?) {
        let request = Alamofire.request(.POST, url, parameters: parameters)
        request.responseString(encoding: NSUTF8StringEncoding) { (xRe) -> Void in
            if xRe.result.error != nil {
                failed(xRe.result.error!)
                return
            }
            success(xRe.result.value)
        }
    }
    
    class func postParameters(url:String,parameters:[String:AnyObject]?,reJSON success:(JSON?)->Void,failed:(NSError)->Void?) {
        let request = Alamofire.request(.POST, url, parameters: parameters)
        request.responseJSON(options: NSJSONReadingOptions.AllowFragments) { (xRe) -> Void in
            if xRe.result.error != nil {
                failed(xRe.result.error!)
                return
            }
            if xRe.result.value != nil {
                success(JSON(xRe.result.value!))
            }
        }
    }
    
    class func postData(url:String,
        multipartFormData:MultipartFormData->Void,
        progress:(Int64,Int64)->Void,
        reJSON success:JSON->Void,
        failed:(ErrorType)->Void,
        outTime:()->Void?) {
        Alamofire.upload(.POST, url, multipartFormData: multipartFormData) { (xResult) -> Void in
            switch xResult {
            case .Success(let xupload, _, _):
                xupload.progress {(_,writen,totalExpectedToWrite) in
                    progress(writen, totalExpectedToWrite)
                }
                xupload.responseJSON(completionHandler: { (xRe) -> Void in
                    success(xRe.result.value as! JSON)
                })
            case .Failure(let xError):
                print(xError)
                failed(xError)
            }
        }
    }

}

extension UIImageView {
    func setImageWithURL(urlString:String?,placeholderImage:UIImage) {
        self.image = placeholderImage.resize(CGSizeMake(25,25))
        if urlString == "" || urlString == nil {
            return
        }
        dispatch_async(dispatch_get_global_queue(0, 0)) { () -> Void in
            Alamofire.request(.GET,uHeader +  urlString!).responseData { (xRe) -> Void in
                if xRe.result.value != nil {
                    print(xRe.result.value?.length)
                    self.image = UIImage(data: xRe.result.value!)!.resize(CGSizeMake(25,25))
                    return
                }
            }
        }
    }
}
