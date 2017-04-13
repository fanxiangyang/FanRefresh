//
//  UIScrollView+FanExtension.swift
//  FanRefresh
//
//  Created by 向阳凡 on 2017/3/29.
//  Copyright © 2017年 凡向阳. All rights reserved.
//

import Foundation

import UIKit

private  var FanRefreshHeaderKey=0
private  var FanRefreshFooterKey=1
private  var FanRefreshControlKey=2
private  var FanRefreshReloadDataBlockKey=3

public extension UIScrollView {
    
    //MARK: - FanExtension Frame
    public var fan_insetTop:CGFloat{
        get{
            return self.contentInset.top
        }
        set{
            var inset=self.contentInset
            inset.top=newValue
            self.contentInset=inset
        }
    }
    public var fan_insetBottom:CGFloat
    {
        get{
            return self.contentInset.bottom
        }
        set{
            var inset=self.contentInset
            inset.bottom=newValue
            self.contentInset=inset
        }
    }
    public var fan_insetLeft:CGFloat
    {
        get{
            return self.contentInset.left
        }
        set{
            var inset=self.contentInset
            inset.left=newValue
            self.contentInset=inset
        }
    }
    public var fan_insetRight:CGFloat{
        get{
            return self.contentInset.right
        }
        set{
            var inset=self.contentInset
            inset.right=newValue
            self.contentInset=inset
        }
    }
    
    
    
    public var fan_offsetX:CGFloat{
        get{
            return self.contentOffset.x
        }
        set{
            var offset=self.contentOffset
            offset.x=newValue
            self.contentOffset=offset
        }
    }
    public var fan_offsetY:CGFloat{
        get{
            return self.contentOffset.y
        }
        set{
            var offset=self.contentOffset
            offset.y=newValue
            self.contentOffset=offset
        }
    }
    
    public var fan_contentWidth:CGFloat{
        get{
            return self.contentSize.width
        }
        set{
            var size=self.contentSize
            size.width=newValue
            self.contentSize=size
        }
    }
    public var fan_contentHeight:CGFloat{
        get{
            return self.contentSize.height
        }
        set{
            var size=self.contentSize
            size.height=newValue
            self.contentSize=size
        }
    }
    
    //MARK: - FanRefresh
    
    /// 下拉刷新控件
    public var fan_header:FanRefreshHeader?{
        get{
            return objc_getAssociatedObject(self, &FanRefreshHeaderKey) as? FanRefreshHeader
        }
        set{
            if newValue != self.fan_header {
                self.fan_header?.removeFromSuperview()
                self.insertSubview(newValue!, at: 0)
                self.willChangeValue(forKey: "fan_header")
                objc_setAssociatedObject(self, &FanRefreshHeaderKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                self.didChangeValue(forKey: "fan_header")
            }
        }
    }
    /// 系统自带刷新控件
    public var fan_refreshControl:FanRefreshControl?{
        get{
            return objc_getAssociatedObject(self, &FanRefreshControlKey) as? FanRefreshControl
        }
        set{
            if newValue != self.fan_refreshControl {
                self.fan_refreshControl?.removeFromSuperview()
                self.insertSubview(newValue!, at: 0)
                self.willChangeValue(forKey: "fan_refreshControl")
                objc_setAssociatedObject(self, &FanRefreshControlKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                self.didChangeValue(forKey: "fan_refreshControl")
            }
        }
    }

    /// 上拉新控件
    public var fan_footer:FanRefreshFooter?{
        get{
            return objc_getAssociatedObject(self, &FanRefreshFooterKey) as? FanRefreshFooter
        }
        set{
            if newValue != self.fan_footer {
                self.fan_footer?.removeFromSuperview()
                self.insertSubview(newValue!, at: 0)
                self.willChangeValue(forKey: "fan_footer")
                objc_setAssociatedObject(self, &FanRefreshFooterKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                self.didChangeValue(forKey: "fan_footer")
                //用来自动隐藏控件，当数据为空时
//                self.fan_hiddenFooterWhenNull()
            }
        }
    }
    
    /// 列表数据总数
    ///
    /// - Returns: 总个数
    public func fan_totalDataCount() -> Int {
        var totalCount=0
        if self is UITableView {
            let tableView=self as! UITableView
            for section in 0...(tableView.numberOfSections-1) {
                totalCount+=tableView.numberOfRows(inSection: section)
            }
        }else if self is UICollectionView {
            let collectionView=self as! UICollectionView
            for section in 0...(collectionView.numberOfSections-1) {
                totalCount+=collectionView.numberOfItems(inSection: section)
            }
        }
        return totalCount
    }
    
    /// 回调列表数据总个数(footer 中使用)
    public var fan_reloadDataBlock:((_ totalDataCount:Int)->())? {
        get{
            return objc_getAssociatedObject(self, &FanRefreshReloadDataBlockKey) as? ((Int) -> ())
        }
        set{
            self.willChangeValue(forKey: "fan_reloadDataBlock")
            objc_setAssociatedObject(self, &FanRefreshReloadDataBlockKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.didChangeValue(forKey: "fan_reloadDataBlock")

        }
    }
    
    /// 当数据为空时，隐藏footer
    public func fan_hiddenFooterWhenNull() {
        if (self.fan_reloadDataBlock != nil) {
            self.fan_reloadDataBlock!(self.fan_totalDataCount())
        }
    }
    
    
}

public extension UITableView{
    //swift 已经废弃这样使用了，想其他办法吧
//    override open class func initialize() {
//        self.exchangeImp()
//    }
//    
//    class func exchangeImp() {
//        let method1 = class_getInstanceMethod(self, #selector(self.reloadData))
//        let method2 = class_getInstanceMethod(self, #selector(self.fan_hiddenFooterWhenNull))
//        method_exchangeImplementations(method1, method2)
//    }
    
}
