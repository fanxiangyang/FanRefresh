//
//  FanRefreshHeaderGIF.swift
//  FanRefresh
//
//  Created by 向阳凡 on 2017/4/21.
//  Copyright © 2017年 凡向阳. All rights reserved.
//

import UIKit

class FanRefreshHeaderGIF: FanRefreshHeader {
    //MARK: - 外部可以修改成员变量
    //防止频繁创建加载，所以把这个活跃内存长期拥有
    public var fan_gifImages:Dictionary<FanRefreshState, UIImage> = Dictionary<FanRefreshState, UIImage>()
    //gif与时间控件的上下间隔
    public var fan_labelInsetTop:CGFloat = 5

    //MARK: - 外部调用方法
    //设置不同状态的GIF图片
    public func fan_setGifName(name:String?,gifState:FanRefreshState){
        if (name != nil) {
            let image = UIImage.fan_gif(name: name!)
            if (image != nil) {
                self.fan_gifImages[gifState] = image
            }
        }
    }

    //MARK: - 内部成员变量+只读的
    fileprivate var lodingGifTimes = 0
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
    //MARK: - GIF自定义UI
    
    ///懒加载属性，类似OC的get方法懒加载
    public lazy var fan_gifImageView:UIImageView = {
        let gifView = UIImageView()
        self.addSubview(gifView)
        return gifView
    }()
    

    
    //MARK: - 本类方法
    fileprivate func fan_gifRefreshUI(){
        let centerPoint = CGPoint(x: self.fan_width*0.5, y: self.fan_height*0.5)
        self.fan_gifImageView.center = centerPoint
        
        let gifImage = self.fan_gifImages[self.state]
        if (gifImage != nil) {
            self.fan_gifImageView.image = gifImage
        }
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
    
        self.fan_gifImageView.contentMode = .scaleAspectFit
        self.fan_gifImageView.fan_size = CGSize(width: 60, height: 60)
    }
    
    override public func fan_placeSubviews() {
        super.fan_placeSubviews()
        
        if lodingGifTimes < 2 {
            lodingGifTimes += 1
            self.fan_gifRefreshUI()
        }
//        //外部修改
        if self.fan_lastUpdatedTimeLabel.isHidden == false {
            //更新时间
            if self.fan_lastUpdatedTimeLabel.constraints.count == 0 {
                self.fan_lastUpdatedTimeLabel.fan_x=0.0
                self.fan_lastUpdatedTimeLabel.fan_y=self.fan_gifImageView.fan_y+self.fan_gifImageView.fan_height+fan_labelInsetTop
                self.fan_lastUpdatedTimeLabel.fan_width=self.fan_width
                self.fan_lastUpdatedTimeLabel.fan_height=20
            }
        }
    }
    override public func fan_changeState(oldState: FanRefreshState) {
        //每次继承都要判断，防止多次调用执行代码
        if self.state == oldState {
            return
        }
        super.fan_changeState(oldState: oldState)
    

        self.fan_gifRefreshUI()

        //重新显示时间，重新设置Key
        self.fan_lastUpdatedTimeKey = self.fan_lastUpdatedTimeKey
        
        
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
