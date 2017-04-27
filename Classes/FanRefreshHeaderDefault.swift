//
//  FanRefreshHeaderDefault.swift
//  FanRefresh
//
//  Created by 向阳凡 on 2017/3/31.
//  Copyright © 2017年 凡向阳. All rights reserved.
//

import UIKit

public class FanRefreshHeaderDefault: FanRefreshHeader {

    //MARK: - 外部可以修改成员变量

    /// 存放状态标题字典
    public var fan_stateTitles:Dictionary<FanRefreshState, String> = Dictionary<FanRefreshState, String>()
    //文字距离圆圈和箭头的距离
    var fan_labelInsetLeft:CGFloat = FanRefreshLabelInsetLeft
    
    //MARK: - 内部成员变量+只读的

    /// iOS8.0+当前日历
    public var fan_currentCalendar:NSCalendar{
        return NSCalendar(calendarIdentifier: .gregorian)!
    }
    
    /// 时间Label
    public lazy var fan_lastUpdatedTimeLabel:UILabel = {
        let timeLabel = UILabel.fan_label()
        self.addSubview(timeLabel)
        return timeLabel
    }()
    /// 状态Label
    public lazy var fan_stateLabel:UILabel = {
        let titleLabel = UILabel.fan_label()
        self.addSubview(titleLabel)
        return titleLabel
    }()
    
    
    //MARK: - 箭头和菊花或自定义UI
    
    ///懒加载属性，类似OC的get方法懒加载
    public lazy var fan_arrowView:UIImageView = {
        let arrowView = UIImageView(image: Bundle.fan_arrowImage)
        self.addSubview(arrowView)
        return arrowView
    }()
    
    /// 菊花样式
    public var fan_activityIndicatorViewStyle:UIActivityIndicatorViewStyle = .gray
//    {
//        //这里应该不需要重新刷新
//        didSet{
//            self.setNeedsLayout()
//        }
//    }
    public lazy var fan_loadingView:UIActivityIndicatorView? = {
        let loadingView = UIActivityIndicatorView(activityIndicatorStyle: self.fan_activityIndicatorViewStyle)
        self.addSubview(loadingView)
        return loadingView
    }()
    
    //MARK: - 外部类调用方法

    /// 设置title状态
    public func fan_setTitle(title:String?,state:FanRefreshState) {
        if title == nil {
            return
        }
        self.fan_stateTitles[state]=title
        self.fan_stateLabel.text=self.fan_stateTitles[self.state]
    }
    
    //MARK: - 重写父类方法
    
    /// 重写设置时间key，用来更新Label
    ///
    /// - Parameter timeKey: timeKey
    public override func fan_setLastUpdatedTimeKey(timeKey:String) {
        super.fan_setLastUpdatedTimeKey(timeKey: timeKey)
        
        if (self.fan_lastUpdatedTimeLabel.isHidden) {
            return
        }
        let lastUpdatedTime:Date?=UserDefaults.standard.object(forKey: timeKey) as? Date
        
        //外部回调更新时间Label内容
        
        if (self.fan_lasUpdateTimeText != nil) {
            self.fan_lastUpdatedTimeLabel.text=self.fan_lasUpdateTimeText?(lastUpdatedTime)
            return
        }
        
        if (lastUpdatedTime != nil) {
            let calendar = self.fan_currentCalendar
            let options:NSCalendar.Unit = [.year,.month,.day,.hour,.minute]
            let cmp1 = calendar.components(options, from: lastUpdatedTime!)
            let cmp2 = calendar.components(options, from: Date())
            //格式化日期
            let formatter = DateFormatter()
            var isToday:Bool=false
            if cmp1.day == cmp2.day {
                //今天
                isToday=true
                formatter.dateFormat="HH:mm"
            }else if cmp1.year == cmp2.year {
                //今年
                formatter.dateFormat="MM-dd HH:mm"
            }else{
                formatter.dateFormat="yyyy-MM-dd HH:mm"
            }
            let time=formatter.string(from: lastUpdatedTime!)
            
            self.fan_lastUpdatedTimeLabel.text = Bundle.fan_localizedString(key: FanRefreshHeaderLastTimeText)! + (isToday ? Bundle.fan_localizedString(key: FanRefreshHeaderDateTodayText)! : " ") + time
        }else{
            self.fan_lastUpdatedTimeLabel.text = Bundle.fan_localizedString(key: FanRefreshHeaderLastTimeText)! + Bundle.fan_localizedString(key: FanRefreshHeaderNoneLastDateText)!
        }
        
    }
    
    public override func fan_prepare() {
        super.fan_prepare()
        
        //初始化UI,放在最前面(已经用懒加载)
        
        //初始化状态文字（已经国际化）
        self.fan_setTitle(title: Bundle.fan_localizedString(key: FanRefreshHeaderDefaultText), state: .Default)
        self.fan_setTitle(title: Bundle.fan_localizedString(key: FanRefreshHeaderPullingText), state: .Pulling)
        self.fan_setTitle(title: Bundle.fan_localizedString(key: FanRefreshHeaderRefreshingText), state: .Refreshing)
    }
    
    override public func fan_placeSubviews() {
        super.fan_placeSubviews()
        let centerY = self.fan_height * 0.5
        if (self.fan_stateLabel.isHidden) {
            if self.fan_lastUpdatedTimeLabel.isHidden == false {
                //更新时间
                if self.fan_lastUpdatedTimeLabel.constraints.count == 0 {
                    self.fan_lastUpdatedTimeLabel.fan_x=0.0
                    self.fan_lastUpdatedTimeLabel.fan_y=centerY+10
                    self.fan_lastUpdatedTimeLabel.fan_width=self.fan_width
                    self.fan_lastUpdatedTimeLabel.fan_height=self.fan_height-(self.fan_lastUpdatedTimeLabel.fan_y)
                }
            }
        }else{
            let noConstrainsOnStatusLabel = (self.fan_stateLabel.constraints.count == 0)
            
            if self.fan_lastUpdatedTimeLabel.isHidden {
                if noConstrainsOnStatusLabel {
                    self.fan_stateLabel.frame = self.bounds
                }
            }else{
                if noConstrainsOnStatusLabel {
                    self.fan_stateLabel.fan_x=0.0
                    self.fan_stateLabel.fan_y=0.0
                    self.fan_stateLabel.fan_width = self.fan_width
                    self.fan_stateLabel.fan_height = centerY
                }
                //更新时间
                if self.fan_lastUpdatedTimeLabel.constraints.count == 0 {
                    self.fan_lastUpdatedTimeLabel.fan_x=0.0
                    self.fan_lastUpdatedTimeLabel.fan_y=centerY
                    self.fan_lastUpdatedTimeLabel.fan_width=self.fan_width
                    self.fan_lastUpdatedTimeLabel.fan_height=self.fan_height-(self.fan_lastUpdatedTimeLabel.fan_y)
                }
            }
        }
        //MARK:  箭头和菊花
        var arrowCenterX = self.fan_width * 0.5
        var arrowCenterY = self.fan_height * 0.5
        
        if self.fan_stateLabel.isHidden == false {
            let stateWidth:CGFloat = self.fan_stateLabel.fan_textWidth(height: self.fan_stateLabel.fan_height)
            var timeWidth:CGFloat = 0.0
            if (self.fan_lastUpdatedTimeLabel.isHidden == false) {
                timeWidth = self.fan_lastUpdatedTimeLabel.fan_textWidth(height: self.fan_lastUpdatedTimeLabel.fan_height)
            }
            let textWidth:CGFloat = max(stateWidth, timeWidth)
            arrowCenterX -= textWidth/2.0 + self.fan_labelInsetLeft
        }else{
            if self.fan_lastUpdatedTimeLabel.isHidden == false {
                arrowCenterY -= 5.0
            }
        }
        
        let arrowCenter = CGPoint(x: arrowCenterX, y: arrowCenterY)
        //箭头
        if self.fan_arrowView.constraints.count == 0 {
            self.fan_arrowView.fan_size = (self.fan_arrowView.image?.size)!
            self.fan_arrowView.center = arrowCenter
        }
        //圆圈
        if self.fan_loadingView?.constraints.count == 0 {
            self.fan_loadingView?.center = arrowCenter
        }
        //箭头颜色和状态Label颜色相同
        self.fan_arrowView.tintColor = self.fan_stateLabel.textColor
    }
    override public func fan_changeState(oldState: FanRefreshState) {
        //每次继承都要判断，防止多次调用执行代码
        if self.state == oldState {
            return
        }
        super.fan_changeState(oldState: oldState)
        //设置状态文字
        self.fan_stateLabel.text=self.fan_stateTitles[state]
        //重新显示时间，重新设置Key
        self.fan_lastUpdatedTimeKey = self.fan_lastUpdatedTimeKey
        
        
        //MARK:  箭头和菊花状态变化
        if self.state == .Default {
            if oldState == .Refreshing {
                self.fan_arrowView.transform = CGAffineTransform.identity
                UIView.animate(withDuration: FanRefreshSlowAnimationDuration, animations: { 
                    self.fan_loadingView?.alpha=0.0
                }, completion: { (finished) in
                    if self.state != .Default {
                        return
                    }
                    self.alpha=1.0
                    self.fan_loadingView?.stopAnimating()
                    self.fan_arrowView.isHidden=false
                })
            }else{
                self.fan_loadingView?.stopAnimating()
                self.fan_arrowView.isHidden=false
                UIView.animate(withDuration: FanRefreshAnimationDuration, animations: {
                    self.fan_arrowView.transform = CGAffineTransform.identity
                })
            }
        }else if self.state == .Pulling {
            self.fan_loadingView?.stopAnimating()
            self.fan_arrowView.isHidden=false
            UIView.animate(withDuration: FanRefreshAnimationDuration, animations: { 
                self.fan_arrowView.transform=CGAffineTransform(rotationAngle: (CGFloat(0.0000001 - Double.pi)))
            })
        }else if self.state == .Refreshing {
            self.fan_loadingView?.alpha=1.0
            self.fan_loadingView?.startAnimating()
            self.fan_arrowView.isHidden=true
        
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
