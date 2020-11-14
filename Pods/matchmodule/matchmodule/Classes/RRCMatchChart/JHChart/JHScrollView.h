//
//  JHScrollView.h
//  MXSFramework
//
//  Created by gaoguangxiao on 2019/9/4.
//  Copyright © 2019 MXS. All rights reserved.
//

#import "YNPageScrollView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHScrollView : YNPageScrollView

//移动的距离
@property (assign, nonatomic) CGFloat moveDistance;

/** 是不是长按状态*/
@property (assign, nonatomic) BOOL isLongPress;

@property (assign, nonatomic) CGPoint currentLoc; //长按时当前定位位置

//点长按
@property (assign, nonatomic) CGFloat pointGap;

@property (nonatomic, assign) CGPoint originSize;


@property (nonatomic, assign) CGFloat columnWidth;//showViewArr

@property (nonatomic, strong) NSArray *showViewArr;
@end

NS_ASSUME_NONNULL_END
