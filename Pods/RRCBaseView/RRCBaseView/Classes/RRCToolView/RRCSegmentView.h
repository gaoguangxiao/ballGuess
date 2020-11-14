//
//  RRCSegmentView.h
//  MXSFramework
//
//  Created by 人人彩 on 2019/9/27.
//  Copyright © 2019 MXS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RRCSegmentDelegate <NSObject>

-(void)segmentSelect:(NSInteger)index;
@end

@interface RRCSegmentView : UIView
//字体颜色

@property (nonatomic,strong) UIColor *bordeColor;//边框颜色

@property (nonatomic,strong) UIColor *backNormalColor;//背景颜色

@property (nonatomic,assign) float titleFont;
@property (nonatomic,strong) NSArray *titleArr;
@property (nonatomic,assign) NSInteger selectIndex;
@property (nonatomic,weak) id <RRCSegmentDelegate> segmentDelegate;
-(instancetype)initWithFrame:(CGRect)frame Titles:(NSArray *)titleArr;
@end



