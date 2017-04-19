//
//  FanRefreshControl.swift
//  FanRefresh
//
//  Created by 向阳凡 on 2017/4/12.
//  Copyright © 2017年 凡向阳. All rights reserved.
//


/**  注意：如果请求时间非常短，创建cell非常慢时有bug
 *      1.当数据请求下来开始刷新了，如果手指还在滑动tableView，
 *        cell复用代理里面的indexPath与数据个数不相同，出现数组越界
 *
 *      2.如果使用，请在数据改变后，立即reloadData，记得不要让创建cell上耗时
          要求请求数据是个耗时动作就行了
 *
 *
 *
 */

import UIKit

public enum FanRefreshControlState:Int {
    case Default=0
    case Pulling=1
    case Refreshing=2
}

open class FanRefreshControl: UIRefreshControl {
    //MARK: - 初始化方法
    
    public class func fan_addRefresh(target: Any?, action: Selector)->(Self){
        let refreshControl=self.init()
        refreshControl.addTarget(target, action: action, for: UIControlEvents.valueChanged)
        return refreshControl
    }
    
    public override required init() {
        super.init()
        //初始化变量
        
        self.fan_stateTitles[.Default] = NSAttributedString(string: Bundle.fan_localizedString(key: FanRefreshControlDefaultText)!)
        self.fan_stateTitles[.Refreshing] = NSAttributedString(string: Bundle.fan_localizedString(key: FanRefreshControlRefreshingText)!)
        
        if !self.fan_isHidderTitle {
            self.attributedTitle = self.fan_stateTitles[.Default]
        }else{
            self.attributedTitle = nil
        }
       

    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 存放状态标题字典
    public var fan_stateTitles:Dictionary<FanRefreshControlState, NSAttributedString> = Dictionary<FanRefreshControlState, NSAttributedString>()
    
    public var fan_isHidderTitle:Bool = true {
        didSet{
            self.attributedTitle = self.fan_stateTitles[.Default]
        }
    }
    
    private var _fan_textColor:UIColor?
    public var fan_textColor:UIColor? {
        get{
            return _fan_textColor
        }
        set{
            self._fan_textColor = newValue
            self.updateTextColor(color: newValue)
        }
    }
    
    //MARK: - 重写父类方法
    open override func beginRefreshing() {
        super.beginRefreshing()
        if !self.fan_isHidderTitle {
            self.attributedTitle = self.fan_stateTitles[.Refreshing]
        }else{
            self.attributedTitle = nil
        }
    }
    
    open override func endRefreshing() {
        super.endRefreshing()
        if !self.fan_isHidderTitle {
            self.attributedTitle = self.fan_stateTitles[.Default]
        }else{
            self.attributedTitle = nil
        }
    }
    //MARK: - 外部调用方法

    /// 开始正在刷新的title状态
    open func fan_beginRefreshing() {
        if !self.fan_isHidderTitle {
            self.attributedTitle = self.fan_stateTitles[.Refreshing]
        }else{
            self.attributedTitle = nil
        }
    }

    //MARK: - 内部方法
    fileprivate func updateTextColor(color:UIColor?){
        if (color != nil) {
            let currentAttribut = NSMutableAttributedString(attributedString:self.attributedTitle!)
            currentAttribut.addAttributes([NSForegroundColorAttributeName:color!], range: NSRange(location: 0, length: currentAttribut.string.characters.count))
            self.attributedTitle = currentAttribut
            
            for (key,value) in self.fan_stateTitles {
                let attribut = NSMutableAttributedString(attributedString: value)
                attribut.addAttributes([NSForegroundColorAttributeName:color!], range: NSRange(location: 0, length: attribut.string.characters.count))
                self.fan_stateTitles[key] = attribut

            }
            
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
