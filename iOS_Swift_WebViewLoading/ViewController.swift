//
//  ViewController.swift
//  iOS_Swift_WebViewLoading
//
//  Created by Mr nie on 16/5/17.
//  Copyright © 2016年 程序猿:NiePlus   博客地址:http://nieplus.blog.com. All rights reserved.
//

import UIKit
import ReachabilitySwift


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 本地html路径
        let path:String = NSBundle.mainBundle().pathForResource("xml2", ofType: "html")!
        // 转换路径为请求url
        let url = NSURL.fileURLWithPath(path)
        
        let frame:CGRect = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height)
        let webView:UIWebView = UIWebView(frame: frame)
        self.view.addSubview(webView)
        
        // 实例Reachability
        let reachability: Reachability
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            print("Unable to create Reachability")
            return
        }
        
        // 有网络状态
        reachability.whenReachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            dispatch_async(dispatch_get_main_queue()) {
                if reachability.isReachableViaWiFi() {
                    print("Reachable via WiFi")
                } else {
                    print("Reachable via Cellular")
                }
                let webUrl = NSURL(string: "https://www.baidu.com/")
                // 加载网络url
                webView.loadRequest(NSURLRequest(URL: webUrl!))
            }
        }
        
        // 无网络状态
        reachability.whenUnreachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            dispatch_async(dispatch_get_main_queue()) {
                print("Not reachable")
                // 加载本地html
                webView.loadRequest(NSURLRequest(URL: url))
            }
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        reachability.stopNotifier()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

