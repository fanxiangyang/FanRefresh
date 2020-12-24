//
//  FanWebViewController.swift
//  FanRefresh
//
//  Created by 向阳凡 on 2017/4/10.
//  Copyright © 2017年 凡向阳. All rights reserved.
//

import UIKit
import WebKit

class FanWebViewController: UIViewController,WKNavigationDelegate {

    var fan_webView:WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.configUI()
        self.fanRefresh()
        if #available(iOS 11.0, *) {
            //automatic 会跳动下，偶尔会上移
            self.fan_webView?.scrollView.contentInsetAdjustmentBehavior = .automatic
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets=false;
        }
    
    }
    func configUI()  {
        self.view.backgroundColor=UIColor.white
        self.fan_webView = WKWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        self.view.addSubview(self.fan_webView!)
        self.fan_webView?.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        
        self.fan_webView?.load(URLRequest(url: URL(string: "https://www.baidu.com")!))
    }
    func fanRefresh(){
        weak var weakWebView = self.fan_webView
        weakWebView?.navigationDelegate=self
        weak var weakScrollView = self.fan_webView?.scrollView
//        weakScrollView?.fan_header = FanRefreshHeaderDefault.headerRefreshing(refreshingBlock: {
//            weakWebView?.reload()
//        })
        
        //还可以简写成这样的回调
        weakScrollView?.fan_header = FanRefreshHeaderDefault.headerRefreshing {
            weakWebView?.reload()
        }
        
        weakScrollView?.fan_header?.fan_beginRefreshing()

    }
    //MARK: - WKNavigationDelegate
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        //开始加载
    }
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        //内容准备完毕
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //加载完成
        self.fan_webView?.scrollView.fan_header?.fan_endRefreshing()
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        //加载失败
        self.fan_webView?.scrollView.fan_header?.fan_endRefreshing()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
