//
//  RRCThemeManager.m
//  MXSFramework
//
//  Created by gaoguangxiao on 2020/4/1.
//  Copyright © 2020 MXS. All rights reserved.
//

#import "RRCThemeManager.h"

@implementation RRCThemeManager

ImplementSingleton(RRCThemeManager);

/// 0：正常模式 1：暗黑模式
-(NSInteger )getThemeState{
    NSInteger themeState = 0;
    if (@available(iOS 13.0, *)) {
        if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            themeState = 1;
        }
    } else {
        // Fallback on earlier versions
    }
    return themeState;
}

@end
