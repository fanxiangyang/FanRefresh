//
//  UIView+FanExtension.swift
//  FanRefresh
//
//  Created by 向阳凡 on 2017/3/29.
//  Copyright © 2017年 凡向阳. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {
    
    public var fan_x:CGFloat{
        get{
            return self.frame.origin.x
        }
        set{
            var frame=self.frame
            frame.origin.x=newValue
            self.frame=frame
        }
    }
    public var fan_y:CGFloat{
        get{
            return self.frame.origin.y
        }
        set{
            var frame=self.frame
            frame.origin.y=newValue
            self.frame=frame
        }
    }
    
    public var fan_width:CGFloat{
        get{
            return self.frame.size.width
        }
        set{
            var frame=self.frame
            frame.size.width=newValue
            self.frame=frame
        }
    }
    public var fan_height:CGFloat{
        get{
            return self.frame.size.height
        }
        set{
            var frame=self.frame
            frame.size.height=newValue
            self.frame=frame
        }
    }
  
    public var fan_size:CGSize{
        get{
            return self.frame.size
        }
        set{
            var frame=self.frame
            frame.size=newValue
            self.frame=frame
        }
    }
    public var fan_origin:CGPoint{
        get{
            return self.frame.origin
        }
        set{
            var frame=self.frame
            frame.origin=newValue
            self.frame=frame
        }
    }

    
}

