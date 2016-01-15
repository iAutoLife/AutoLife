//
//  MessageViewController.swift
//  AutoLife
//
//  Created by 徐成 on 16/1/15.
//  Copyright © 2016年 徐成. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = XuColorWhite
        self.navigationItem.title = "消息"
        
        self.initView()
    }
    
    func initView() {
        let webView = UIWebView(frame: self.view.frame)
        webView.loadRequest(NSURLRequest(URL: NSURL(string: "http://www.baidu.com")!))
        self.view.addSubview(webView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
