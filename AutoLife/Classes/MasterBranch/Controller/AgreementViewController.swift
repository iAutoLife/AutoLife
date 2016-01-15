//
//  AgreementViewController.swift
//  AutoLife
//
//  Created by 徐成 on 16/1/14.
//  Copyright © 2016年 徐成. All rights reserved.
//

import UIKit


class AgreementViewController: UIViewController {
    
    var previousVC:UIViewController?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = XuColorWhite
        self.navigationItem.title = "协议"
        
        self.initView()
        
        if self.previousVC != nil {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: UIBarButtonItemStyle.Plain, target: self, action: "backPreviousVC:")
        }
    }
    
    func initView() {
        let webView = UIWebView(frame: self.view.frame)
        webView.loadRequest(NSURLRequest(URL: NSURL(string: "http://www.baidu.com")!))
        self.view.addSubview(webView)
    }
    
    func backPreviousVC(sender:NSObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
