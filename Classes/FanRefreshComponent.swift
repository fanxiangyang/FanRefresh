//
//  FanRefreshComponent.swift
//  FanRefresh
//
//  Created by 向阳凡 on 2017/3/29.
//  Copyright © 2017年 凡向阳. All rights reserved.
//

import UIKit

/// 刷新控件状态
///
/// - Default: 默认闲着状态
/// - Pulling: 松开就可以刷新的状态
/// - Refreshing: 正在刷新状态
/// - WillRefresh: 即将刷新状态
/// - NoMoreData: 数据加载完成，没有更多数据
public enum FanRefreshState:Int {
    case Default=0
    case Pulling=1
    case Refreshing=2
    case WillRefresh=3
    case NoMoreData=4
}


/// 进入刷新状态的回调
public typealias FanRefreshComponentRefreshingBlock = (()->())

/// 开始刷新后的回调
public typealias FanRefreshComponentBeginRefreshingBlock = (()->())

/// 结束刷新后的回调
public typealias FanRefreshComponentEndRefreshingBlock = (()->())


public class FanRefreshComponent: UIView {
    
    /// 记录scrolView刚开始的Inset
    public var scrollViewOriginalInset:UIEdgeInsets?
    
    /// 父类scrollView
    public weak var superScrollView:UIScrollView?
    
    /// 正在刷新的回调
    public var fan_refreshingBlock:FanRefreshComponentRefreshingBlock?
    /// 开始刷新
    public var fan_beginRefreshBlock:FanRefreshComponentBeginRefreshingBlock?
    /// 结束刷新
    public var fan_endRefreshBlock:FanRefreshComponentEndRefreshingBlock?

    public var state:FanRefreshState = .Default{
        willSet{
//            print("\(self.state)----\(newValue)\n")
//            self.fan_changeState(newState: newValue)
        }
        didSet{
//            print("\(self.state)\n")
            self.fan_changeState(oldState: oldValue)
        }
    }
    public var scrollViewPan:UIPanGestureRecognizer?
    /// 拖拽百分比改透明度(内部属性，)
    public var fan_pullingPercent:CGFloat=0.0{
        didSet{
            if self.isRefreshing() {
                return
            }
            if self.fan_automaticallyChangeAlpha {
                self.alpha = self.fan_pullingPercent
            }
        }
    }
    
    /// 下拉时使用属性，上拉没有用
    public var fan_automaticallyChangeAlpha:Bool=true{
        didSet{
            if self.isRefreshing() {
                return
            }
            if self.fan_automaticallyChangeAlpha {
                self.alpha = self.fan_pullingPercent
            }else{
                self.alpha = 1.0
            }
        }
    }
    
    
    //MARK: - 初始化

    
   public override init(frame: CGRect) {
        super.init(frame: frame)
        self.state = .Default
        self.fan_prepare()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        self.fan_removeObservers()
//        print(#function)
    }
    
    //MARK: - 内部方法
    
    public override  func draw(_ rect: CGRect) {
        super.draw(rect)
        // 预防view还没显示出来就调用了fan_beginRefreshing
        if self.state == .WillRefresh {
            self.state = .Refreshing
        }
    }
    
    public override func layoutSubviews() {
        self.fan_placeSubviews()
        super.layoutSubviews()
    }
    
    
    public func fan_addObservers() {
        let options:NSKeyValueObservingOptions = [ .new,.old ]
        self.superScrollView?.addObserver(self, forKeyPath: FanRefreshKeyPathContentOffset, options: options, context: nil)
        self.superScrollView?.addObserver(self, forKeyPath: FanRefreshKeyPathContentSize, options: options, context: nil)
        self.scrollViewPan=self.superScrollView?.panGestureRecognizer
        self.scrollViewPan?.addObserver(self, forKeyPath: FanRefreshKeyPathPanState, options: options, context: nil)

    }
    public func fan_removeObservers() {
        self.superview?.removeObserver(self, forKeyPath: FanRefreshKeyPathContentOffset)
        self.superview?.removeObserver(self, forKeyPath: FanRefreshKeyPathContentSize)
        self.scrollViewPan?.removeObserver(self, forKeyPath: FanRefreshKeyPathPanState)
        self.scrollViewPan = nil
    }
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        //不可用状态不处理
        if self.isUserInteractionEnabled == false {
            return
        }
        
        if keyPath == FanRefreshKeyPathContentOffset{
            if self.isHidden {
                return
            }
            self.fan_scrollViewContentOffsetDidChange(change: change!)
        }else if keyPath == FanRefreshKeyPathContentSize{
            self.fan_scrollViewContentSizeDidChange(change: change!)
        }else if keyPath == FanRefreshKeyPathPanState{
            self.fan_scrollViewPanStateDidChange(change: change!)
        }
    }
    
    /// 刷新回调block
    public func fan_executeRefreshingCallBack()  {
        DispatchQueue.main.async {
            if (self.fan_refreshingBlock != nil) {
                self.fan_refreshingBlock!()
            }
            if (self.fan_beginRefreshBlock != nil) {
                self.fan_beginRefreshBlock!()
            }
        }
    }
    
    //MARK: - 子类有些需要实现的
    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if (newSuperview != nil) && !(newSuperview is UIScrollView) {
            return
        }
        //移除监听
        self.fan_removeObservers()
        
        if (newSuperview != nil) {
            self.fan_width=(newSuperview?.fan_width)!
            self.fan_x=0.0
            self.superScrollView=newSuperview as? UIScrollView
            self.superScrollView?.alwaysBounceVertical=true
            self.scrollViewOriginalInset=self.superScrollView?.contentInset
            //添加监听
            self.fan_addObservers()
        }
    }

   
    //MARK: - 子类重写方法
    /// 准备工作，子类重写
    public func fan_prepare() -> () {
//        let autoresize = UIViewAutoresizing().union(.flexibleLeftMargin).union(.flexibleRightMargin).union(.flexibleWidth)
        //适配约束
        let autoresize = UIViewAutoresizing().union(.flexibleWidth)
        self.autoresizingMask=autoresize
        
        self.backgroundColor=UIColor.clear

    }
    
    /// 重新布局UI，子控件
    public func fan_placeSubviews() -> () {
        
    }
    public func fan_scrollViewContentOffsetDidChange(change:[NSKeyValueChangeKey : Any]) {
    }
    public func fan_scrollViewContentSizeDidChange(change:[NSKeyValueChangeKey : Any]) {
    }
    public func fan_scrollViewPanStateDidChange(change:[NSKeyValueChangeKey : Any]) {
    }
    public func fan_changeState(oldState:FanRefreshState) -> () {
        // 加入主队列的目的是等setState:方法调用完毕、设置完文字后再去布局子控件
        DispatchQueue.main.async {
            self.setNeedsLayout()
        }
        
        if self.state==oldState {
            return
        }
    }
    
    //MARK: - 刷新状态控制
    
    /// 开始刷新
    public func fan_beginRefreshing() {
        UIView.animate(withDuration: FanRefreshAnimationDuration) {
            self.alpha = 1.0
        }
        self.fan_pullingPercent=1.0
        //只要正在刷新，就完全显示
        if (self.window != nil) {
            self.state = .Refreshing
        }else{
            // 预防正在刷新中时，调用本方法使得header inset回置失败
            if self.state != .Refreshing {
                self.state = .WillRefresh
                // 刷新(预防从另一个控制器回到这个控制器的情况，回来要重新刷新一下)
                self.setNeedsDisplay()
            }
        }
    }
    public func fan_beginRefreshing(beginRefreshBlock:@escaping FanRefreshComponentBeginRefreshingBlock) {
        self.fan_beginRefreshBlock=beginRefreshBlock
        self.fan_beginRefreshing()
    }
    /// 结束刷新
    public func fan_endRefreshing() {
        self.state = .Default
    }
    public func fan_endRefreshing(endRefreshBlock:@escaping FanRefreshComponentEndRefreshingBlock) {
        self.fan_endRefreshBlock=endRefreshBlock
        self.fan_endRefreshing()
    }
    
    /// 是否正在刷新
    ///
    /// - Returns: false/ture
    public func isRefreshing() -> (Bool){
        return self.state == .Refreshing || self.state == .WillRefresh
    }
    
    //这里是只读的计算属性，不设置set，默认是只读的
//    var isRefreshing:Bool{
//        get{
//            return self.state == .Refreshing || self.state == .WillRefresh
//        }
//    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

//MARK: - Label扩展

public extension UILabel{
    public class func fan_label()-> UILabel {
        let label = UILabel()
        label.font=FanRefreshLableFont()
        label.textColor=FanRefreshTextColor()
        label.autoresizingMask=[.flexibleWidth]
        label.textAlignment = .center
        label.backgroundColor=UIColor.clear
        return label
    }
    
    public func fan_textWidth(height:CGFloat) -> CGFloat {
        var stringWidth:CGFloat=0.0
        let size:CGSize = CGSize(width: CGFloat(MAXFLOAT), height: height)
        //FIXME:  字符串不存在时的崩溃
        if (self.text != nil)  {
            if (self.text?.characters.count)! > 0 {
                stringWidth = (self.text! as NSString).boundingRect(with: size, options: [.usesLineFragmentOrigin], attributes: [NSFontAttributeName:self.font], context: nil).size.width
            }
        }
        return stringWidth
    }
    public func fan_textHeight(width:CGFloat) -> CGFloat {
        var stringHeight:CGFloat=0.0
        let size:CGSize = CGSize(width: width , height: CGFloat(MAXFLOAT))
        if (self.text != nil)  {
            if (self.text?.characters.count)! > 0 {
                stringHeight = (self.text! as NSString).boundingRect(with: size, options: [.usesLineFragmentOrigin], attributes: [NSFontAttributeName:self.font], context: nil).size.height
            }
        }
        return stringHeight
    }
}
