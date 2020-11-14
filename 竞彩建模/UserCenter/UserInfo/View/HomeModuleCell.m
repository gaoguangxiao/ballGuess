
//
//  HomeModuleCell.m
//  KnowXiTong
//
//  Created by ggx on 2017/4/6.
//  Copyright © 2017年 高广校. All rights reserved.
//

#import "HomeModuleCell.h"

@implementation HomeModuleCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)setViewColor{
    self.backgroundColor = RRCSplitViewColor;
}

- (IBAction)TapModuleIndex:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(homeModuleActionAtIndedx:)]) {
        [self.delegate homeModuleActionAtIndedx:sender.tag];
    }
}

@end
