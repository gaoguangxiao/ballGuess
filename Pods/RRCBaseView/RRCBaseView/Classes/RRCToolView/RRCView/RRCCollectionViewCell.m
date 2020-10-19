//
//  RRCCollectionViewCell.m
//  MXSFramework
//
//  Created by gaoguangxiao on 2019/12/19.
//  Copyright © 2019 MXS. All rights reserved.
//

#import "RRCCollectionViewCell.h"

@implementation RRCCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self creatCell];
    }
    return self;
}

-(void)creatCell{}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self setViewColor];
}
-(void)setViewColor{
   
    self.backgroundColor = RRCUnitViewColor;
   
}

@end
