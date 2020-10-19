//
//  RRCView.h
//  MXSFramework
//
//  Created by gaoguangxiao on 2019/11/27.
//  Copyright © 2019 MXS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBColorConfigure.h"
#import "RRCDeviceConfigure.h"
#import "Masonry.h"
#import "RRCNetFailView.h"
NS_ASSUME_NONNULL_BEGIN

@interface RRCView : UIView

//此控件背景颜色
@property (nonatomic , strong) NSString *backViewColors;

//所有子视图控件
@property (nonatomic , strong) NSArray *subviewsArray;

@property(nonatomic, strong) RRCNetFailView *defaultPageView;
/// 渲染控件
-(void)setUpView;


/// 控件颜色设置
-(void)setViewColor;

/// 加载缺省页
/// @param text 文本提示
/// @param imageName 图片名字
-(void)loadDefaultZeroViewText:(NSString *)text andImageName:(NSString *)imageName;


/// 取消加载缺省页
-(void)cancleLoadDefaultZero;


@property(nonatomic, strong) id data;
@end

NS_ASSUME_NONNULL_END
