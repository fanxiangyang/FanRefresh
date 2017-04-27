//
//  NSBundle+FanRefresh.swift
//  FanRefresh
//
//  Created by 向阳凡 on 2017/3/31.
//  Copyright © 2017年 凡向阳. All rights reserved.
//

import Foundation
import UIKit

public extension Bundle{
    
    //静态类属性（本类） 
    //如果这样写会报错  A declaration cannot be both 'final' and 'dynamic'
//    static let fan_RefreshBundle:Bundle? = Bundle(path: Bundle(for: FanRefreshComponent.classForCoder()).path(forResource: "FanRefresh", ofType: "bundle")!)
    //第二种单利类写法
    public static var fan_RefreshBundle:Bundle? {
        struct StaticBundle {
            static let rbundle : Bundle = Bundle(path: Bundle(for: FanRefreshComponent.classForCoder()).path(forResource: "FanRefresh", ofType: "bundle")!)!
        }
        return StaticBundle.rbundle
    }
//    static var fan_arrowImage:UIImage? = UIImage(contentsOfFile: (Bundle.fan_RefreshBundle?.path(forResource: "fan_arrow@2x", ofType: "png"))!)?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
    public static var fan_arrowImage:UIImage?{
        return (UIImage(contentsOfFile: (Bundle.fan_RefreshBundle?.path(forResource: "fan_arrow@2x", ofType: "png"))!)?.withRenderingMode(UIImageRenderingMode.alwaysTemplate))
    }
    
    public static var fan_languageBundle:Bundle?{
        return Bundle.fan_getLanguageBundle()
    }
    public class func fan_getLanguageBundle() -> Bundle? {
        var language = Locale.preferredLanguages.first
        if (language?.hasPrefix("en"))! {
            language="en"
        }else if (language?.hasPrefix("zh"))! {
            if ((language?.range(of: "Hans")) != nil) {
                language="zh-Hans"
            }else{
                 //zh-Hant\zh-HK\zh-TW
                language="zh-Hant"
            }
        }else{
            language="en"
        }
        return Bundle(path: (Bundle.fan_RefreshBundle?.path(forResource: language, ofType: "lproj"))!)
    }

    public class func fan_localizedString(key:String,value:String?) -> String? {
        let valueReal=self.fan_getLanguageBundle()?.localizedString(forKey: key, value: value, table: nil)
        //自己的配置文件重新改数据，不修改就用默认的
        return self.main.localizedString(forKey: key, value: valueReal, table: nil)
    }
    public class func fan_localizedString(key:String) -> String? {
        return self.fan_localizedString(key: key, value: nil)
    }
    
}
