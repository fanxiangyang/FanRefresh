//
//  FanRefreshFooter.swift
//  FanRefresh
//
//  Created by 向阳凡 on 2017/3/30.
//  Copyright © 2017年 凡向阳. All rights reserved.
//

import UIKit

/// 不放任何UI控件，只处理逻辑，一个footer的基类，所有具体实现UI类，都继承此类
class FanRefreshFooter: FanRefreshComponent {
    
    //MARK: - 初始化方法
    
    class func footerRefreshing(refreshingBlock:@escaping FanRefreshComponentRefreshingBlock)->(Self){
        let refreshComponent=self.init()
        refreshComponent.fan_refreshingBlock=refreshingBlock
        return refreshComponent
    }
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        if (newSuperview != nil) {
            if self.isHidden == false {
                self.superScrollView?.fan_insetBottom += self.fan_height
            }
            self.fan_y = (self.superScrollView?.fan_contentHeight)!
            
            if (self.superScrollView is UITableView) || (self.superScrollView is UICollectionView) {
                self.superScrollView?.fan_reloadDataBlock = { totalDataCount in
                    //回调处理显示和隐藏
                    if self.fan_automaticallyFooterHidden {
                        self.isHidden = (totalDataCount == 0)
                    }else{
                        self.isHidden = false
                    }
                }
            }
        }else{
            if self.isHidden == false {
                self.superScrollView?.fan_insetBottom -= self.fan_height
            }
        }
    }
    //MARK: - 成员变量

    //FIXME:  属性调试中,还是不使用或者外部直接调用为空方法（不安全，以后可能废弃）
    //建议使用nomoreData状态代替自动隐藏，
    /// 是否自动隐藏该控件=否 (根据数据有无显示)---开启true必须把停止刷新放在tableview.reloadData后
    var fan_automaticallyFooterHidden:Bool = false
    
    /// 是否自动刷新(false是手动点击才刷新)
    var fan_automaticallyRefresh:Bool = true

    var fan_automaticallyRefreshTriggerPercent:CGFloat=1.0
    
    override var isHidden: Bool {
        get{
            return super.isHidden
        }
        set{
            let lastHidden = self.isHidden
            super.isHidden=newValue

            if !lastHidden && newValue {
                self.state = .FanRefreshStateDefault
                self.superScrollView?.fan_insetBottom -= self.fan_height
            }else if lastHidden && !newValue {
                self.superScrollView?.fan_insetBottom += self.fan_height
                self.fan_y = (self.superScrollView?.fan_contentHeight)!
            }
        }
    }
    //MARK: - 重写的方法
    
    override func fan_prepare() -> () {
        super.fan_prepare()
        self.fan_height=FanRefreshFooterHeight
    }
    
    /// 重新布局UI，子控件
    override func fan_placeSubviews() -> () {
        super.fan_placeSubviews()
//        print(self.frame)
//        print(self.scrollViewOriginalInset)
//        self.superScrollView?.fan_insetBottom = 44
//        self.superScrollView?.fan_offsetY=20
        
//        print(self.superScrollView?.contentInset)
//        print(self.superScrollView?.contentSize)
//        print(self.superScrollView?.contentOffset)
        
        self.fan_y=(self.superScrollView?.fan_contentHeight)!
//        print(self.fan_y)
    }
    
    override func fan_changeState(oldState:FanRefreshState) -> () {
        if self.state==oldState {
            return
        }
        super.fan_changeState(oldState: oldState)
        //做各个状态的事情
        if self.state == .FanRefreshStateRefreshing {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5, execute: { 
                self.fan_executeRefreshingCallBack()
            })
        }else if self.state == .FanRefreshStateNoMoreData || self.state == .FanRefreshStateDefault {
            if oldState == .FanRefreshStateRefreshing {
                if (self.fan_endRefreshBlock != nil) {
                    self.fan_endRefreshBlock!()
                }
            }
        }
    }
    override func fan_scrollViewContentOffsetDidChange(change: [NSKeyValueChangeKey : Any]) {
        super.fan_scrollViewContentOffsetDidChange(change: change)
//        print(change[.newKey])
        
        if self.state != .FanRefreshStateDefault || !self.fan_automaticallyRefresh || self.fan_y == 0.0 {
            return
        }
        //内容超过容器
        if (self.superScrollView?.fan_insetTop)! + (self.superScrollView?.fan_contentHeight)! > (self.superScrollView?.fan_height)! {
//            print("offSetY:\((self.superScrollView?.fan_offsetY)!)  contentHeight:\((self.superScrollView?.fan_contentHeight)!)  sHeight:\((self.superScrollView?.fan_height)!)  insetBottom:\((self.superScrollView?.fan_insetBottom)!)")
            if (self.superScrollView?.fan_offsetY)! >= (self.superScrollView?.fan_contentHeight)! - (self.superScrollView?.fan_height)! + self.fan_height * self.fan_automaticallyRefreshTriggerPercent + (self.superScrollView?.fan_insetBottom)! - self.fan_height {
                
                //防止手松开时连续调用
                let old:CGPoint = change[.oldKey] as! CGPoint
                let new:CGPoint = change[.newKey] as! CGPoint
                if new.y <= old.y {
                    return
                }
                
                //开始刷新
                self.fan_beginRefreshing()

            }
        }
    }
    override func fan_scrollViewContentSizeDidChange(change:[NSKeyValueChangeKey : Any]) {
        super.fan_scrollViewContentSizeDidChange(change: change)
//        print(change[.newKey])
        self.fan_y = (self.superScrollView?.fan_contentHeight)!
        
    }
    
    override func fan_scrollViewPanStateDidChange(change: [NSKeyValueChangeKey : Any]) {
        super.fan_scrollViewContentSizeDidChange(change: change)
        if self.state != .FanRefreshStateDefault {
            return
        }
        
        if !self.fan_automaticallyRefresh {
            return
        }
        
        if self.superScrollView?.panGestureRecognizer.state == UIGestureRecognizerState.ended {
            //手松开时
            if (self.superScrollView?.fan_insetTop)! + (self.superScrollView?.fan_contentHeight)! <= (self.superScrollView?.fan_height)! {
                //内容不够一个屏幕
                if (self.superScrollView?.fan_offsetY)! >= -((self.superScrollView?.fan_insetTop)!) {
                    self.fan_beginRefreshing()
                }
            }else{
                //超过一个屏幕
                if (self.superScrollView?.fan_offsetY)! >= ( (self.superScrollView?.fan_contentHeight)! + (self.superScrollView?.fan_insetBottom)! - (self.superScrollView?.fan_height)! ) {
                    self.fan_beginRefreshing()
                    print("3333333333333")

                }
            }
        }
    }
  
    //MARK: - 外部调用的公共方法
    func fan_endRefreshingWithNoMoreData() {
        self.state = .FanRefreshStateNoMoreData
    }
    
    func fan_resetNoMoreData() {
        self.state = .FanRefreshStateDefault
    }
    
    /// 最好放在tableview.reloadData后
    override func fan_endRefreshing() {
        self.state = .FanRefreshStateDefault
        if self.fan_automaticallyFooterHidden {
            self.superScrollView?.fan_hiddenFooterWhenNull()
        }
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
