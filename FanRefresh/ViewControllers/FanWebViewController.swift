//
//  FanWebViewController.swift
//  FanRefresh
//
//  Created by 向阳凡 on 2017/4/10.
//  Copyright © 2017年 凡向阳. All rights reserved.
//

import UIKit

class FanWebViewController: UIViewController,UIWebViewDelegate {

    var fan_webView:UIWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.configUI()
        self.fanRefresh()
        
    }
    func configUI()  {
        self.view.backgroundColor=UIColor.white
        self.fan_webView = UIWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        self.view.addSubview(self.fan_webView!)
        self.fan_webView?.autoresizingMask = [.flexibleWidth,.flexibleHeight]

        self.fan_webView?.loadRequest(URLRequest(url: URL(string: "https://www.baidu.com")!))
    }
    func fanRefresh(){
        weak var weakWebView = self.fan_webView
        weakWebView?.delegate=self
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
    //MARK: - webViewDelegate
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.fan_webView?.scrollView.fan_header?.fan_endRefreshing()
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
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
