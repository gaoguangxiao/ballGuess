//
//  TZNavTop.m
//  MXSFramework
//
//  Created by 人人彩 on 2019/10/22.
//  Copyright © 2019 MXS. All rights reserved.
//

#import "TZNavTop.h"
#import "UIView+Layout.h"
#import "RRCDeviceConfigure.h"
@interface TZNavTop ()
@property (nonatomic,strong) UILabel *navTitle;
@property (nonatomic,strong) UIImageView *navImg;
@property (nonatomic,assign) BOOL isUnfold;
@end
@implementation TZNavTop

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initNav];
    }
    return self;
}

-(void)initNav{
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dropViewAction)]];
    [self addSubview:self.navTitle];
//    [self.navTitle mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_offset(6);
//        make.top.bottom.mas_offset(0);
//    }];
    
    [self addSubview:self.navImg];
//    [self.navImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.navTitle.mas_right).with.mas_offset(6);
//        make.centerY.mas_equalTo(self);
//        make.size.mas_offset(CGSizeMake(18, 18));
//        make.right.mas_equalTo(self).with.mas_offset(-6);
//    }];
}

-(void)dropViewAction{
    self.isUnfold = !self.isUnfold;
    [UIView animateWithDuration:.2 animations:^{
        if (self.isUnfold) {
            self.navImg.transform = CGAffineTransformMakeRotation(M_PI);
        }else{
            self.navImg.transform = CGAffineTransformIdentity;
        }
    } completion:nil];
    if (self.DropBlock) {
        self.DropBlock(self.isUnfold);
    }
}

-(void)setNavStr:(NSString *)navStr{
    _navStr = navStr;
    _navTitle.text = navStr;
    
    float labWidth = [self LabelWidth:16*Device_Ccale andTitle:navStr];
    _navTitle.tz_width = labWidth;
    _navImg.tz_left = labWidth + 6;
    self.tz_width =  _navImg.tz_right;
}

- (float)LabelWidth:(float)fontSize andTitle:(NSString *)title{
    CGSize maxSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
    float width = [title boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]} context:nil].size.width;
    return width;
}

-(UILabel *)navTitle{
    if (!_navTitle) {
        _navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
        _navTitle.textAlignment = NSTextAlignmentCenter;
        _navTitle.userInteractionEnabled = YES;
        _navTitle.font = [UIFont systemFontOfSize:16*Device_Ccale];
        _navTitle.textColor = [UIColor whiteColor];
        
    }
    return _navTitle;
}

-(UIImageView *)navImg{
    if (!_navImg) {
        _navImg = [[UIImageView alloc] initWithFrame:CGRectMake(_navTitle.tz_right, 10, 24, 24)];
        _navImg.image = [UIImage imageNamed:@"photoDrop"];
    }
    return _navImg;
}

@end
