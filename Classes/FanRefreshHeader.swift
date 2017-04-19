//
//  FanRefreshHeader.swift
//  FanRefresh
//
//  Created by 向阳凡 on 2017/3/30.
//  Copyright © 2017年 凡向阳. All rights reserved.
//

import UIKit


/// 不放任何UI控件，只处理逻辑，一个header的基类，所有具体实现UI类，都继承此类
public class FanRefreshHeader: FanRefreshComponent {
    //MARK: - 属性

    /// 控件的顶部默认隐藏时的位置
    fileprivate var insetTopDefault:CGFloat = 0.0

    public var fan_lastUpdatedTimeKey:String=FanRefreshHeaderLastUpdatedTimeKey{
        didSet{
            self.fan_setLastUpdatedTimeKey(timeKey:self.fan_lastUpdatedTimeKey)
        }
    }
    public var fan_lastUpdatedTime:Date?{
        get{
            return UserDefaults.standard.object(forKey: self.fan_lastUpdatedTimeKey) as? Date
        }
    }
    /// 外部修改日期显示内容
    public var fan_lasUpdateTimeText:((_ lastUpdatTime:Date?) -> String?)?
    
    //MARK: - 外部调用方法
    /// 如果大于上次刷新多少秒，将自动进入刷新
    /// 修复如果初次没有时间时，无记录状态，不做任何操作
    /// - Parameter afterTime: 几秒后 Double
    public func fan_autoRefresh(thanIntervalTime:TimeInterval) {
        if (self.fan_lastUpdatedTime != nil) {
            if fabs((self.fan_lastUpdatedTime?.timeIntervalSinceNow)!) > thanIntervalTime {
                self.fan_beginRefreshing()
            }
        }
    }
   
    //MARK: - 初始化方法
    
    public class func headerRefreshing(refreshingBlock:@escaping FanRefreshComponentRefreshingBlock)->(Self){
        let refreshComponent=self.init()
        refreshComponent.fan_refreshingBlock=refreshingBlock
        return refreshComponent
    }
    //MARK: - 重写的方法

    override public func fan_prepare() -> () {
        super.fan_prepare()

        self.fan_height=FanRefreshHeaderHeight
        //用来刷新时间控件
        self.fan_lastUpdatedTimeKey = FanRefreshHeaderLastUpdatedTimeKey
    }
    
    /// 重新布局UI，子控件
    override public func fan_placeSubviews() -> () {
        super.fan_placeSubviews()
        self.fan_y = -(self.fan_height)
//        print(#function)
    }
    public func fan_setLastUpdatedTimeKey(timeKey:String) {
        
    }
    
    override public func fan_changeState(oldState:FanRefreshState) -> () {
        //做各个状态的事情
        if self.state==oldState {
            return
        }
        super.fan_changeState(oldState: oldState)

        if self.state == .Default {
            if oldState != .Refreshing {
                return
            }
            //保存刷新时间
            let userDefault = UserDefaults.standard
            userDefault.set(Date(), forKey: self.fan_lastUpdatedTimeKey)
            userDefault.synchronize()
            
            //恢复insert和offset
            UIView.animate(withDuration: FanRefreshSlowAnimationDuration, animations: { 
                self.superScrollView?.fan_insetTop += self.insetTopDefault
                if self.fan_automaticallyChangeAlpha {
                    self.alpha=0.0
                }
            }, completion: { (finished) in
                self.fan_pullingPercent=0.0
                if (self.fan_endRefreshBlock != nil) {
                    self.fan_endRefreshBlock!()
                }
            })
            
            //结束刷新回调
        }else if self.state == .Refreshing{
            DispatchQueue.main.async {
                UIView.animate(withDuration: FanRefreshSlowAnimationDuration, animations: {
                    //跳转滚动区域，让控件可以可见
                    let top = (self.scrollViewOriginalInset?.top)! + self.fan_height
                    self.superScrollView?.fan_insetTop = top
                    self.superScrollView?.setContentOffset(CGPoint(x: 0, y: -top), animated: false)
                }, completion: { (finished) in
                    self.fan_executeRefreshingCallBack()
                })
                
            }
        }
        
    
    }
    
    override public func fan_scrollViewContentOffsetDidChange(change: [NSKeyValueChangeKey : Any]) {
        super.fan_scrollViewContentOffsetDidChange(change: change)
//        print(change[.newKey])
        if self.state == .Refreshing{
            if self.window == nil {
                return
            }
            
            // sectionheader停留状态
            var insetT = -((self.superScrollView)?.fan_offsetY)! > ((self.scrollViewOriginalInset)?.top)! ? -((self.superScrollView)?.fan_offsetY)! : (self.scrollViewOriginalInset?.top)!
            insetT = insetT > self.fan_height + (self.scrollViewOriginalInset?.top)! ? self.fan_height + (self.scrollViewOriginalInset?.top)! : insetT
            self.superScrollView?.fan_insetTop=insetT
            //
            self.insetTopDefault = (self.scrollViewOriginalInset?.top)! - insetT
//            print("111111111")
            return;
        }
        //防止
        self.scrollViewOriginalInset=self.superScrollView?.contentInset
        let offsetY = (self.superScrollView?.fan_offsetY)!
        let happenOffsetY = -(self.scrollViewOriginalInset?.top)!
        //如果是向上滑动看不到头控件，直接返回
        if offsetY > happenOffsetY {
            return
        }
        //普通和即将刷新的临界点
        let normalPullingOffsetY=happenOffsetY-self.fan_height
        let pullingPercent = (happenOffsetY-offsetY)/self.fan_height
        if (self.superScrollView?.isDragging)! {
            self.fan_pullingPercent=pullingPercent
            if self.state == .Default && offsetY < normalPullingOffsetY {
                //将要刷新状态,拖拽超过控件高度
                self.state = .Pulling
//                print("2222222")

            }else if self.state == .Pulling && offsetY >= normalPullingOffsetY {
                //转为普通默认状态，拖拽超过又小于控件高度
                self.state = .Default
//                print("33333333")

            }
        }else if self.state == .Pulling {
            //即将刷新或手松开开始刷新
//            print("44444444")
            self.fan_beginRefreshing()
            
        }else if pullingPercent < 1 {
            self.fan_pullingPercent=pullingPercent
//            print("555555555")

        }
    }
    //MARK: -  覆盖基类方法
    override public func fan_endRefreshing() {
        DispatchQueue.main.async {
            self.state = .Default
        }
        self.superScrollView?.fan_hiddenFooterWhenNull()

    }
//    override func fan_scrollViewContentSizeDidChange(change:[NSKeyValueChangeKey : Any]) {
//        super.fan_scrollViewContentSizeDidChange(change: change)
//        print(change[.newKey])
//    
//    }
//
//    override func fan_scrollViewPanStateDidChange(change:[NSKeyValueChangeKey : Any]) {
//        super.fan_scrollViewPanStateDidChange(change: change)
//    }
 
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
