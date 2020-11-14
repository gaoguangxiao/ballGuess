//
//  RRCMatchConfig.h
//  MXSFramework
//
//  Created by renrencai on 2019/4/18.
//  Copyright © 2019年 MXS. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "RRCTodayModel.h"b
NS_ASSUME_NONNULL_BEGIN


@interface RRCMatchChartConfig : NSObject

/**表格类型 */
//@property (nonatomic, assign) MatchType matchType;

/** */
@property (nonatomic, strong) UIViewController *defineVc;

/** 表格背景颜色*/
@property (nonatomic , strong) UIColor *tableBackColor;

/** 左右间距*/
@property (nonatomic , assign) CGFloat beginSpace;

/** 底部间距*/
@property (nonatomic , assign) CGFloat bottomSpace;

/** 列表数据为0，是否自动隐藏*/
@property (nonatomic , assign) BOOL isListZeroCancel;

/**返回按钮 图片 */
@property (nonatomic, strong) UIImage *backLastVcImage;

/** 状态栏样式*/
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;

/**导航栏背景颜色 */
@property (nonatomic, strong) UIColor *navigationColor;

/**渐变左边 */
@property (nonatomic, strong) UIColor *left_navigationColor;

/**渐变导航栏右边 */
@property (nonatomic, strong) UIColor *right_navigationColor;

@property (nonatomic, strong) UIImage *rightNav_image;


+ (instancetype)defaultConfig;

/**赛事条件时间 */
//@property (nonatomic, strong) RRCTodayModel *todayModel;


@end

NS_ASSUME_NONNULL_END
