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
let FanRefreshHeaderHeight:CGFloat=60.0
let FanRefreshFooterHeight:CGFloat=44.0
let FanRefreshAnimationDuration:Double=0.27
let FanRefreshSlowAnimationDuration:Double=0.4
let FanRefreshLabelInsetLeft:CGFloat=20.0

let FanRefreshKeyPathContentOffset = "contentOffset"
let FanRefreshKeyPathContentInset = "contentInset"
let FanRefreshKeyPathContentSize = "contentSize"
let FanRefreshKeyPathPanState = "state"

/// 刷新时间Key
let FanRefreshHeaderLastUpdatedTimeKey = "FanRefreshHeaderLastUpdatedTimeKey"

// 刷新状态控制Key
let FanRefreshHeaderDefaultText = "FanRefreshHeaderDefaultText"
let FanRefreshHeaderPullingText = "FanRefreshHeaderPullingText"
let FanRefreshHeaderRefreshingText = "FanRefreshHeaderRefreshingText"

let FanRefreshAutoFooterDefaultText = "FanRefreshAutoFooterDefaultText"
let FanRefreshAutoFooterRefreshingText = "FanRefreshAutoFooterRefreshingText"
let FanRefreshAutoFooterNoMoreDataText = "FanRefreshAutoFooterNoMoreDataText"

let FanRefreshBackFooterDefaultText = "FanRefreshBackFooterDefaultText"
let FanRefreshBackFooterPullingText = "FanRefreshBackFooterPullingText"
let FanRefreshBackFooterRefreshingText = "FanRefreshBackFooterRefreshingText"
let FanRefreshBackFooterNoMoreDataText = "FanRefreshBackFooterNoMoreDataText"

let FanRefreshHeaderLastTimeText = "FanRefreshHeaderLastTimeText"
let FanRefreshHeaderDateTodayText = "FanRefreshHeaderDateTodayText"
let FanRefreshHeaderNoneLastDateText = "FanRefreshHeaderNoneLastDateText"

//MARK: - 方法宏定义
func FanRefreshColor(r:CGFloat,g:CGFloat,b:CGFloat,a:CGFloat)->UIColor{
    return UIColor(red: (r)/255.0, green: (g)/255.0, blue: (b)/255.0, alpha: (a))
}
func FanRefreshLableFont()->UIFont{
    return UIFont.boldSystemFont(ofSize: 14)
}
func FanRefreshTextColor()->UIColor{
    return FanRefreshColor(r: 90.0, g: 90.0, b: 90.0, a: 1.0)
}














