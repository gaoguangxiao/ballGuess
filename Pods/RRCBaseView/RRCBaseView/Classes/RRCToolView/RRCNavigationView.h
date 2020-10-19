//
//  RRCNavigationView.h
//  MXSFramework
//
//  Created by gaoguangxiao on 2019/5/31.
//  Copyright © 2019 MXS. All rights reserved.
//

#import "RRCView.h"

NS_ASSUME_NONNULL_BEGIN

@interface RRCNavigationView : RRCView

-(instancetype)initWithFrame:(CGRect)frame andnaviTitle:(NSString *)title;

@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UILabel *titlelabel2;
@property (nonatomic , strong) UIView *lineView;

-(void)setRightBtnTitle:(NSString *)rightTitle;

-(void)setLeftTitle:(NSString *)leftTitle;

@property(nonatomic, strong)void(^leftAction)(void);

@property(nonatomic, strong)void(^rightAction)(void);
@end

NS_ASSUME_NONNULL_END
