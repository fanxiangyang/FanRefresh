//
//  FanRefreshFooterGIF.swift
//  FanRefresh
//
//  Created by 向阳凡 on 2017/4/27.
//  Copyright © 2017年 凡向阳. All rights reserved.
//

import UIKit

class FanRefreshFooterGIF: FanRefreshFooter {
    //防止频繁创建加载，所以把这个活跃内存长期拥有
    public var fan_gifImages:Dictionary<FanRefreshState, UIImage> = Dictionary<FanRefreshState, UIImage>()

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
    
    //MARK: - GIF自定义UI
    
    ///懒加载属性，类似OC的get方法懒加载
    public lazy var fan_gifImageView:UIImageView = {
        let gifView = UIImageView()
        self.addSubview(gifView)
        return gifView
    }()
    
        
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
    /// 设置title状态
    public func fan_setTitle(title:String?,state:FanRefreshState) {
        if title == nil {
            return
        }
        self.fan_stateTitles[state]=title
        self.fan_stateLabel.text=self.fan_stateTitles[self.state]
    }
    
    public  func fan_stateLabelClick() {
        if self.state == .Default {
            self.fan_beginRefreshing()
        }
    }
    
    //MARK: - 本类方法
    fileprivate func fan_gifRefreshUI(){        
        let gifImage = self.fan_gifImages[self.state]
        if (gifImage != nil) {
            self.fan_gifImageView.image = gifImage
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
        
        self.fan_gifImageView.contentMode = .scaleAspectFit
        self.fan_gifImageView.fan_size = CGSize(width: 40, height: 40)

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
        if self.fan_gifImageView.constraints.count == 0 {
            if !fan_isRefreshTitleHidden {
                loadingCenterX -= self.fan_stateLabel.fan_textWidth(height: self.fan_stateLabel.fan_height) * 0.5 + self.fan_labelInsetLeft + self.fan_gifImageView.fan_width/2.0
            }
            let loadingCenterY = self.fan_height * 0.5
            self.fan_gifImageView.center = CGPoint(x: loadingCenterX, y: loadingCenterY)
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
            self.fan_gifImageView.image=nil
        }else{
            self.fan_gifRefreshUI()
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
