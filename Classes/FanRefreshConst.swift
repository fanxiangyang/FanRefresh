//
//  FanRefreshConst.swift
//  FanRefresh
//
//  Created by 向阳凡 on 2017/3/29.
//  Copyright © 2017年 凡向阳. All rights reserved.
//



/** 使用说明
 *  版本: 0.1
 *  功能: 1.基本的上拉和下拉
 *       2.基本的属性修改，实现部分隐藏，字体内容和颜色等
 *       3.回调可以简写，例如  xxx = FanRefreshHeaderDefault.headerRefreshing { }
 *
 *
 *  将来: 1.支持GIF图片
 *       2.
 *
 *  完善: 1.demo完善
 *
 *
 *
 *  问题: 1.没有数据时自动隐藏，runtime有问题
 *       2.fan_automaticallyFooterHidden属性最好不要使用，默认就好
 *
 *
 */

import Foundation
import UIKit


//MARK: - 常量宏定义
public let FanRefreshHeaderHeight:CGFloat=60.0
public let FanRefreshFooterHeight:CGFloat=44.0
public let FanRefreshAnimationDuration:Double=0.27
public let FanRefreshSlowAnimationDuration:Double=0.4
public let FanRefreshLabelInsetLeft:CGFloat=20.0

public let FanRefreshKeyPathContentOffset = "contentOffset"
public let FanRefreshKeyPathContentInset = "contentInset"
public let FanRefreshKeyPathContentSize = "contentSize"
public let FanRefreshKeyPathPanState = "state"

/// 刷新时间Key
public let FanRefreshHeaderLastUpdatedTimeKey = "FanRefreshHeaderLastUpdatedTimeKey"

// 刷新状态控制Key
public let FanRefreshHeaderDefaultText = "FanRefreshHeaderDefaultText"
public let FanRefreshHeaderPullingText = "FanRefreshHeaderPullingText"
public let FanRefreshHeaderRefreshingText = "FanRefreshHeaderRefreshingText"

public let FanRefreshAutoFooterDefaultText = "FanRefreshAutoFooterDefaultText"
public let FanRefreshAutoFooterRefreshingText = "FanRefreshAutoFooterRefreshingText"
public let FanRefreshAutoFooterNoMoreDataText = "FanRefreshAutoFooterNoMoreDataText"

public let FanRefreshBackFooterDefaultText = "FanRefreshBackFooterDefaultText"
public let FanRefreshBackFooterPullingText = "FanRefreshBackFooterPullingText"
public let FanRefreshBackFooterRefreshingText = "FanRefreshBackFooterRefreshingText"
public let FanRefreshBackFooterNoMoreDataText = "FanRefreshBackFooterNoMoreDataText"

public let FanRefreshHeaderLastTimeText = "FanRefreshHeaderLastTimeText"
public let FanRefreshHeaderDateTodayText = "FanRefreshHeaderDateTodayText"
public let FanRefreshHeaderNoneLastDateText = "FanRefreshHeaderNoneLastDateText"

public let FanRefreshControlDefaultText = "FanRefreshControlDefaultText"
public let FanRefreshControlPullingText = "FanRefreshControlPullingText"
public let FanRefreshControlRefreshingText = "FanRefreshControlRefreshingText"


//MARK: - 方法宏定义
public func FanRefreshColor(r:CGFloat,g:CGFloat,b:CGFloat,a:CGFloat)->UIColor{
    return UIColor(red: (r)/255.0, green: (g)/255.0, blue: (b)/255.0, alpha: (a))
}
public func FanRefreshLableFont()->UIFont{
    return UIFont.boldSystemFont(ofSize: 14)
}
public func FanRefreshTextColor()->UIColor{
    return FanRefreshColor(r: 90.0, g: 90.0, b: 90.0, a: 1.0)
}














