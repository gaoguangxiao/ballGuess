//
//  UserCenterFootCell.m
//  SimpleSrore
//
//  Created by ggx on 2017/3/17.
//  Copyright © 2017年 高广校. All rights reserved.
//

#import "UserCenterFootCell.h"

@implementation UserCenterFootCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
//    
//    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        //添加视图
//        [self setBackgroundColor:[UIColor clearColor]];
//        
//        [self.contentView addSubview:self.exitBtn];
//        [self.exitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(self.contentView);
//            make.leading.equalTo(@10);
//            make.trailing.equalTo(@-10);
////            make.centerX.equalTo(self.contentView);
//            make.height.equalTo(@40);
//        }];
//    }
//    return self;
//}

-(void)creatCell{
    //添加视图
    [self setBackgroundColor:[UIColor clearColor]];
    
    [self.contentView addSubview:self.exitBtn];
    [self.exitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.leading.equalTo(@10);
        make.trailing.equalTo(@-10);
//            make.centerX.equalTo(self.contentView);
        make.height.equalTo(@40);
    }];
}

-(void)setViewColor{
    self.backgroundColor = RRCSplitViewColor;
}

-(UIButton *)exitBtn{
    if (!_exitBtn) {
        _exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    [_exitBtn addTarget:self action:@selector(startExit:) forControlEvents:UIControlEventTouchUpInside];
    [_exitBtn setTitle:@"退出登陆" forState:0];
    _exitBtn.titleLabel.font  = K_SystemFont;
    [_exitBtn setTitleColor:K_NavigationTitleColor forState:0];
    [_exitBtn setBackgroundColor:K_RGBColor(239, 116, 118)];
    return _exitBtn;
}
-(void)startExit:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(exitAction:)]) {
        [self.delegate exitAction:sender.tag];
    }
}
@end
