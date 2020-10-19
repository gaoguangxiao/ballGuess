//
//  RRCDeviceConfigure.h
//  MXSFramework
//
//  Created by gaoguangxiao on 2020/4/30.
//  Copyright © 2020 MXS. All rights reserved.
//

#ifndef RRCDeviceConfigure_h
#define RRCDeviceConfigure_h
#import "UIDevice+Size.h"

#define K_WEBSOCKETKEY @"SOCKETURL"
#define K_APPCheckStatus @"checkStatus"

//获取屏幕自适应宽高
#define kScreenWidthFit    [UIScreen mainScreen].bounds.size.width
#define kScreenHeightFit   [UIScreen mainScreen].bounds.size.height

#define DeviceMainScale [UIScreen mainScreen].scale

//获取屏幕固定宽高
#define kScreenWidth    [UIDevice getScreenWidth]
#define kScreenHeight   [UIDevice getScreenHeight]

//设备字体大小 宽高适配 [414/1.1.04] [320/0.85]
#define Device_Ccale    kScreenWidth/375

#define KUserDefault(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]
#define K_UDIDValue ([KUserDefault(@"checkStatus") integerValue] == 1 ?YES:NO)

//适配iphonex
#define IS_IPHONE_X ((kScreenHeight == 812.0f || kScreenHeight == 896.0f) ? YES : NO)
//状态栏高度
#define kHeightNavigationStatusBar    (IS_IPHONE_X==YES? 44 : 20) //iPhoneX与iPoneXS_Max一样,齐刘海
//底部安全域高度
#define iPhoneXBottomUnSafeAreaHeight (IS_IPHONE_X==YES? 34 : 0)
//导航栏高度
#define kHeightNavigation             (IS_IPHONE_X==YES? 88 : 64)
//tabbar高度
#define kHeightTabBar                 (49 + iPhoneXBottomUnSafeAreaHeight)
//导航栏除去状态栏高度
#define KNavHeight                    44
#define kScreenSafeAreaHeight (kScreenHeight - iPhoneXBottomUnSafeAreaHeight-kHeightNavigation)
#define kScreenContentHeight (kScreenHeight - iPhoneXBottomUnSafeAreaHeight- kHeightNavigationStatusBar)

//设备所用字体大小
#define K_FontSizeValue(value) [UIFont systemFontOfSize:Device_Ccale * value] //获取字体大小
#define K_FontSizeSuper [UIFont systemFontOfSize:Device_Ccale * 18] //超大号字体
#define K_FontSizeViceBig [UIFont systemFontOfSize:Device_Ccale * 17] //副大号字体
#define K_FontSizeBig    [UIFont systemFontOfSize:Device_Ccale * 16] //大号字体
#define K_FontSizeNormal [UIFont systemFontOfSize:Device_Ccale * 15] //正常字体
#define K_FontSizeSmall  [UIFont systemFontOfSize:Device_Ccale * 14] //小号总体
#define K_FontSizeViceSmall [UIFont systemFontOfSize:Device_Ccale * 13] //副小号字体
#define K_FontSizeTiny [UIFont systemFontOfSize:Device_Ccale * 12] //微型字体
#define K_FontSizeViceTiny [UIFont systemFontOfSize:Device_Ccale * 11] //副微型字体
#define K_FontSizeNMFont [UIFont systemFontOfSize:Device_Ccale * 10] //纳米型字体

//
#define kWeakSelf __weak typeof(self) weakSelf = self;
#define kSafeString(string) (![string isKindOfClass:[NSString class]]) || \
([string isKindOfClass:[NSNull class]]) || \
(!string) || \
(0 == ((NSString *)string).length)    \
? ([string isKindOfClass:[NSNumber class]]?KSafeNumber(string):@"") : string

#define KSafeNumber(string) [NSString stringWithFormat:@"%@",KSafeEmpty(string)]
#define KSafeInteger(id) [[NSString stringWithFormat:@"%@",KSafeEmpty(id)] integerValue]
#define KSafeEmpty(id) ([id isKindOfClass:[NSNull class]])? @"":id

#endif /* RRCDeviceConfigure_h */
