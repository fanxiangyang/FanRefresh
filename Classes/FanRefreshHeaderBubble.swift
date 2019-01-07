//
//  FanRefreshHeaderBubble.swift
//  FanRefresh
//
//  Created by 向阳凡 on 2017/6/5.
//  Copyright © 2017年 凡向阳. All rights reserved.
//

import UIKit

public class FanRefreshHeaderBubble: FanRefreshHeader {
    /// 存放状态标题字典
    public var fan_stateTitles:Dictionary<FanRefreshState, String> = Dictionary<FanRefreshState, String>()
    /// 状态Label
    public lazy var fan_stateLabel:UILabel = {
        let titleLabel = UILabel.fan_label()
        self.addSubview(titleLabel)
        return titleLabel
    }()
    /// 菊花样式
    public var fan_activityIndicatorViewStyle:UIActivityIndicatorView.Style = .gray
    //    {
    //        //这里应该不需要重新刷新
    //        didSet{
    //            self.setNeedsLayout()
    //        }
    //    }
    public lazy var fan_loadingView:UIActivityIndicatorView? = {
        let loadingView = UIActivityIndicatorView(style: self.fan_activityIndicatorViewStyle)
        self.addSubview(loadingView)
        return loadingView
    }()

    ///是否隐藏状态内容
    public var fan_stateTitleHidden:Bool = true

    //文字距离圆圈和箭头的距离
    public var fan_labelInsetLeft:CGFloat = FanRefreshLabelInsetLeft
    public var fillColor:UIColor = UIColor.darkGray
    public var dragHeight:CGFloat = 90
    public var bubbleRadius:CGFloat = (FanRefreshHeaderHeight-20)/2.0;
    public var bubbleCenter:CGPoint{
        return CGPoint(x: self.frame.size.width/2.0, y: FanRefreshHeaderHeight/2.0)
    }
    /// 开始的距离，偏移量-圆直径
    public var startY:CGFloat = 0.0
    public var selfFrame:CGRect?;
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
    
    public override func fan_prepare() {
        super.fan_prepare()
        
        //初始化UI,放在最前面(已经用懒加载)
        
        //初始化状态文字（已经国际化）
        self.fan_setTitle(title: Bundle.fan_localizedString(key: FanRefreshHeaderDefaultText), state: .Default)
        self.fan_setTitle(title: Bundle.fan_localizedString(key: FanRefreshHeaderPullingText), state: .Pulling)
        self.fan_setTitle(title: Bundle.fan_localizedString(key: FanRefreshHeaderRefreshingText), state: .Refreshing)
        
        self.fan_stateLabel.isHidden=true
        
        
    }
    
    override public func fan_placeSubviews() {
        super.fan_placeSubviews()
        let noConstrainsOnStatusLabel = (self.fan_stateLabel.constraints.count == 0)
        
        //MARK:  菊花
        var loadingCenterX = self.fan_width * 0.5
        
        //圆圈
        if self.fan_loadingView?.constraints.count == 0 {
            if !self.fan_stateTitleHidden {
                loadingCenterX -= self.fan_stateLabel.fan_textWidth(height: self.fan_stateLabel.fan_height) * 0.5 + self.fan_labelInsetLeft
                if noConstrainsOnStatusLabel {
                    //            self.fan_stateLabel.frame = self.bounds
                    self.fan_stateLabel.fan_x=0.0
                    self.fan_stateLabel.fan_y=0
                    self.fan_stateLabel.fan_width = self.fan_width
                    self.fan_stateLabel.fan_height = self.fan_height
                }
            }
            let loadingCenterY = self.fan_height * 0.5
            self.fan_loadingView?.center = CGPoint(x: loadingCenterX, y: loadingCenterY)
        }
    }
    override public func fan_changeState(oldState: FanRefreshState) {
        self.fan_stateLabel.isHidden=true
        //每次继承都要判断，防止多次调用执行代码
        if self.state == oldState {
            return
        }
        super.fan_changeState(oldState: oldState)
        //设置状态文字
        //重新显示时间，重新设置Key
        self.fan_lastUpdatedTimeKey = self.fan_lastUpdatedTimeKey
        self.fan_stateLabel.text=self.fan_stateTitles[state]

        //MARK:  箭头和菊花状态变化
        if self.state == .Default {
            if oldState == .Refreshing {
                if self.state != .Default {
                    return
                }
                self.alpha=1.0
                self.fan_loadingView?.stopAnimating()
            }else{
                self.fan_loadingView?.stopAnimating()
               
            }
        }else if self.state == .Pulling {
            self.fan_loadingView?.stopAnimating()
            
        }else if self.state == .Refreshing {
            self.fan_loadingView?.alpha=1.0
            self.fan_loadingView?.startAnimating()
            self.fan_stateLabel.isHidden=self.fan_stateTitleHidden

        }
    }
    override public func fan_scrollViewContentOffsetDidChange(change: [NSKeyValueChangeKey : Any]) {
//        super.fan_scrollViewContentOffsetDidChange(change: change)
//        print(change[.newKey])
        if self.state == .Refreshing{
            if self.window == nil {
                return
            }
          
            // sectionheader停留状态
            var insetT = -((self.superScrollView)?.fan_offsetY)! > ((self.scrollViewOriginalInset)?.top)! ? -((self.superScrollView)?.fan_offsetY)! : (self.scrollViewOriginalInset?.top)!
//            print("tttttt",insetT,self.scrollViewOriginalInset?.top)
            self.superScrollView?.fan_insetTop=60

            if insetT > 60 + (self.scrollViewOriginalInset?.top)! {
                insetT = 60 + (self.scrollViewOriginalInset?.top)!
//                self.superScrollView?.fan_insetTop = 60
//                self.fan_height = 60
//                self.fan_y = -60

            }
            self.fan_height = 60
            self.fan_y = -insetT//-60
            
            self.superScrollView?.fan_insetTop=insetT

//            self.scrollViewOriginalInset=self.superScrollView?.contentInset

            
            self.insetTopDefault = (self.scrollViewOriginalInset?.top)! - insetT
            print("111111111")
            self.scrollViewOriginalInset=self.superScrollView?.contentInset

            
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
        let normalPullingOffsetY=happenOffsetY-self.dragHeight
        let pullingPercent = (happenOffsetY-offsetY)/self.dragHeight
        if (self.superScrollView?.isDragging)! {
            self.fan_pullingPercent=pullingPercent
            if self.state == .Default && offsetY < normalPullingOffsetY {
                //将要刷新状态,拖拽超过控件高度
                self.state = .Pulling
//                                print("2222222")
                
            }else if self.state == .Pulling && offsetY >= normalPullingOffsetY {
                //转为普通默认状态，拖拽超过又小于控件高度
                self.state = .Default
//                                print("33333333")
                
            }
        }else if self.state == .Pulling {
            //即将刷新或手松开开始刷新
//                        print("44444444")
            self.fan_beginRefreshing()
            
        }else if pullingPercent < 1 {
            self.fan_pullingPercent=pullingPercent
//                        print("555555555")
            
        }

//       print("yyyyyyyyyyyyyy",self.superScrollView?.fan_insetTop,self.scrollViewOriginalInset?.top)
        let newPoint:CGPoint = change[.newKey] as! CGPoint
        var frame = self.frame
        frame.origin.y = newPoint.y+(self.superScrollView?.fan_insetTop)!
        
        frame.size.height = fmax(0, -newPoint.y-(self.superScrollView?.fan_insetTop)!)

        self.startY = fmax(0, -newPoint.y-(self.superScrollView?.fan_insetTop)!-FanRefreshHeaderHeight)
        self.frame = frame
//        print("=======",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height)
        
        self.setNeedsDisplay()
    }

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override public func draw(_ rect: CGRect) {
        // 预防view还没显示出来就调用了fan_beginRefreshing
//        if self.state == .WillRefresh {
//            self.state = .Refreshing
//        }
        if self.state == .Refreshing {
            return
        }
        // Drawing code
//        print(rect)
        let rad1 = self.bubbleRadius-self.startY*0.1
        let rad2 = self.bubbleRadius-self.startY*0.2
        let Y:CGFloat = CGFloat(fmaxf(Float(self.startY), 0.0))
        var rad3:CGFloat = 0.0
        if rad1-rad2 > 0 {
            rad3 = (pow(Y, 2)+pow(rad2, 2)-pow(rad1, 2))/(2*(rad1-rad2))
        }
        rad3 = fmax(0, rad3);
//        print(self.bubbleCenter)
        let center2 = CGPoint(x: self.bubbleCenter.x, y: self.bubbleCenter.y+Y)
        let center3 = CGPoint(x: center2.x+rad2+rad3, y: center2.y)
        let center4 = CGPoint(x: center2.x-rad2-rad3, y: center2.y)
        
        let circle = UIBezierPath(arcCenter: self.bubbleCenter, radius: rad1, startAngle: 0, endAngle: CGFloat(2*Double.pi), clockwise: true)
        circle.move(to: center2)
        circle.addArc(withCenter: center2, radius: rad2, startAngle: 0, endAngle: CGFloat(2*Double.pi), clockwise: true)
        
        let circle2 = UIBezierPath(arcCenter: center3, radius: rad3, startAngle: 0, endAngle: CGFloat(2*Double.pi), clockwise: true)
        circle2.move(to: center4)
        circle2.addArc(withCenter: center4, radius: rad3, startAngle: 0, endAngle: CGFloat(2*Double.pi), clockwise: true)
        let bezidrPath = UIBezierPath()
        bezidrPath.move(to: self.bubbleCenter)
        bezidrPath.addLine(to: center3)
        bezidrPath.addLine(to: center2)
        bezidrPath.addLine(to: center4)
        bezidrPath.close()
        bezidrPath.append(circle)
        self.fillColor.setFill()
        bezidrPath.fill()
        
        self.backgroundColor?.setFill()
        circle2.fill()
        
    }
 

}
