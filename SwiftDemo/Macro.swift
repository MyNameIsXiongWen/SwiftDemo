//
//  Macro.swift
//  SwiftDemo
//
//  Created by 熊文 on 2018/4/5.
//  Copyright © 2018年 熊文. All rights reserved.
//

import UIKit

public let SCREEN_WIDTH :CGFloat = UIScreen.main.bounds.width
public let SCREEN_HEIGHT :CGFloat = UIScreen.main.bounds.height
public func swift_setScrollViewContentInsetAdjustmentNever(scrollView: UIScrollView) -> Void {
    if #available (iOS 11.0, *) {
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
    }
}



class Macro: NSObject {

}
