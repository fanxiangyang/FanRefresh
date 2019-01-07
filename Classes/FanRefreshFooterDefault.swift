//
//  FanRefreshFooterDefault.swift
//  FanRefresh
//
//  Created by 向阳凡 on 2017/4/7.
//  Copyright © 2017年 凡向阳. All rights reserved.
//

import UIKit

public class FanRefreshFooterDefault: FanRefreshFooter {

    /// 存放状态标题字典
    public var fan_stateTitles:Dictionary<FanRefreshState, String> = Dictionary<FanRefreshState, String>()
    //文字距离圆圈和箭头的距离
    public var fan_labelInsetLeft:CGFloat = FanRefreshLabelInsetLeft
    
    public var fan_isRefreshTitleHidden:Bool = false

    //MARK: - 内部成员变量+只读的
    
    /// 状态Label
    public lazy var fan_stateLabel:UILabel = {
        let titleLabel = UILabel.fan_label()
        self.addSubview(titleLabel)
        return titleLabel
    }()
    
    
    //MARK: - 箭头和菊花或自定义UI
    
 
    /// 菊花样式
    public var fan_activityIndicatorViewStyle:UIActivityIndicatorView.Style = .gray
    //    {
    //        //这里应该不需要重新刷新
    //        didSet{
    //            self.setNeedsLayout()
    //        }
    //    }
    
    ///懒加载属性，类似OC的get方法懒加载
    public lazy var fan_loadingView:UIActivityIndicatorView? = {
        let loadingView = UIActivityIndicatorView(style: self.fan_activityIndicatorViewStyle)
        self.addSubview(loadingView)
        return loadingView
    }()
    
    //MARK: - 本类方法
    
    /// 设置title状态
    public func fan_setTitle(title:String?,state:FanRefreshState) {
        if title == nil {
            return
        }
        self.fan_stateTitles[state]=title
        self.fan_stateLabel.text=self.fan_stateTitles[self.state]
    }
    
   @objc public  func fan_stateLabelClick() {
        if self.state == .Default {
            self.fan_beginRefreshing()
        }
    }
    
    //MARK: - 重写父类方法
    
    public override func fan_prepare() {
        super.fan_prepare()
        
        //初始化状态文字
        self.fan_setTitle(title: Bundle.fan_localizedString(key: FanRefreshAutoFooterDefaultText), state: .Default)
        self.fan_setTitle(title: Bundle.fan_localizedString(key: FanRefreshAutoFooterRefreshingText), state: .Refreshing)
        self.fan_setTitle(title: Bundle.fan_localizedString(key: FanRefreshAutoFooterNoMoreDataText), state: .NoMoreData)
        
        //添加手势按钮
        self.fan_stateLabel.isUserInteractionEnabled = true
        self.fan_stateLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.fan_stateLabelClick)))
        
    }
    
    override public func fan_placeSubviews() {
        super.fan_placeSubviews()
        if (self.fan_stateLabel.isHidden) {
            return
        }
        //判断是否有约束
        if self.fan_stateLabel.constraints.count == 0 {
            self.fan_stateLabel.frame=self.bounds
        }
        
        //MARK:  菊花
        var loadingCenterX = self.fan_width * 0.5
    
        //圆圈
        if self.fan_loadingView?.constraints.count == 0 {
            if !fan_isRefreshTitleHidden {
                loadingCenterX -= self.fan_stateLabel.fan_textWidth(height: self.fan_stateLabel.fan_height) * 0.5 + self.fan_labelInsetLeft
            }
            let loadingCenterY = self.fan_height * 0.5
            self.fan_loadingView?.center = CGPoint(x: loadingCenterX, y: loadingCenterY)
        }
    }
    override public func fan_changeState(oldState: FanRefreshState) {
        //每次继承都要判断，防止多执行代码
        if self.state == oldState {
            return
        }
        super.fan_changeState(oldState: oldState)
        //设置状态文字
        if self.fan_isRefreshTitleHidden && self.state == .Refreshing {
            self.fan_stateLabel.text=nil
        }else{
            self.fan_stateLabel.text=self.fan_stateTitles[state]
        }

        //设置菊花
        if self.state == .NoMoreData || self.state == .Default {
            self.fan_loadingView?.stopAnimating()
        }else{
            self.fan_loadingView?.startAnimating()
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
