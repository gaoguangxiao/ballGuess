//
//  Macro.h
//  CPetro
//
//  Created by ggx on 2017/3/8.
//  Copyright © 2017年 高广校. All rights reserved.
//  工具宏定义

#ifndef Macro_h
#define Macro_h

//#import "HJNavgationViewController.h"
//#import "ShareHandle.h"
#import "CustomUtil.h"//
#import "RRCAlertManager.h"
#import <BmobSDK/Bmob.h> //引入云端数据库
//#import <RongIMKit/RongIMKit.h>
//#import "EFQuery.h"
//#import "EFUser.h"

#import "Service.h"  //APP请求工具
#import "HUDHelper.h"

//工程获取info.plist
#define PROJECT_NAME [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleName"]
#define PROJECT_DISPLAY_NAME [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleDisplayName"]

//字符串
#define String(XX) [NSString stringWithFormat:@"%@",XX]
#define URLLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

//工程提交按钮的颜色
#define K_SubmitTitleColor [UIColor darkGrayColor]
#define K_SubmitTitleLayerBorderColor [UIColor darkGrayColor]
#define K_RGBColor(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
//系统配置
#define K_NavigationTitleColor K_RGBColor(255, 255, 255) //导航题颜色
#define K_NavigationBackColor K_RGBColor(30, 111, 222) //导航栏颜色 //偏蓝色

#define K_NaMustBanColor  K_RGBColor(227, 89, 90) //禁用颜色
#define K_SystemFont [UIFont systemFontOfSize:15.0]
#define K_SystemFontFourteen [UIFont systemFontOfSize:14.0]
//截取几个屏幕的属性
#define SCREEN_WIDTH [[UIScreen mainScreen]bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen]bounds].size.height

//bmob时间
#define U_SERVER_FORMATTER [NSDateFormatter dateFormatterWithFormat:@"yyyy-MM-dd HH:mm:ss"]
//弱引用
//#define WeakSelf __weak typeof(self) weakSelf = self;
//#define K_Weakself __weak typeof(self) weakSelf = self;

#define K_APNNOTIFICATIONLOGIN @"APNNotificationLogin"//用户登录成功

//先做几个常用的xib，快速创建的
#define PushViewController(XX) [self.navigationController pushViewController:XX animated:YES]
#define PushViewControllerName(XX) [self.navigationController pushViewController:CreateViewController(XX) animated:YES]
#define POP [self.navigationController popViewControllerAnimated:YES]
#define PROOTP  [self.navigationController popToRootViewControllerAnimated:YES]
#define CreateViewController(classname) [[NSClassFromString(classname) alloc]initWithNibName:classname bundle:nil]
#define CreateViewControllerWithNav(classname) [[UINavigationController alloc]initWithRootViewController:[[NSClassFromString(classname) alloc]initWithNibName:classname bundle:nil]]
#define CreateCell(classname) [[[NSBundle mainBundle]loadNibNamed:classname owner:self options:nil] objectAtIndex:0]

#endif /* Macro_h */
