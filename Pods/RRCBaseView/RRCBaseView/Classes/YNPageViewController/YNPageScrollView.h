//
//  YNPageScrollView.h
//  YNPageViewController
//
//  Created by ZYN on 2018/4/22.
//  Copyright © 2018年 yongneng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YNPageScrollView : UIScrollView

@property(nonatomic, assign) BOOL failScolleGes;
//越过一定高度不在触发手势，默认本视图从上开始下计算
@property(nonatomic, assign) CGFloat panHeight;
@end
