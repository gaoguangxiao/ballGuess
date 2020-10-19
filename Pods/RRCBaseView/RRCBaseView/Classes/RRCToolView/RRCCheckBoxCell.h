//
//  RRCCommanySelectCell.h
//  MXSFramework
//
//  Created by 人人彩 on 2020/4/15.
//  Copyright © 2020 MXS. All rights reserved.
//  选择视图

#import "RRCTableViewCell.h"
#import "RRCView.h"

@class RRCCommanySelectView;
@interface RRCCheckBoxCell : RRCTableViewCell

/// 设置筛选标题
@property (nonatomic,strong) NSString *choseTitle;
///设置选中状态
@property (nonatomic,assign) BOOL selectStatus;

@end

@interface RRCCheckBoxView : RRCView

/// 设置筛选标题
@property (nonatomic,strong) NSString *choseTitle;
///设置选中状态
@property (nonatomic,assign) BOOL selectStatus;
//设置选中的字体颜色
@property (nonatomic , strong) UIColor *selectTextColor;
/// 设置默认的字体颜色
@property (nonatomic , strong) UIColor *normalTextColor;

@end
