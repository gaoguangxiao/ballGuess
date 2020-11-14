//
//  UserCenterFootCell.h
//  SimpleSrore
//
//  Created by ggx on 2017/3/17.
//  Copyright © 2017年 高广校. All rights reserved.
//

#import "RRCTableViewCell.h"
//#import "CGButtonRadius5.h"
@protocol UserCenterFootCellDelegate <NSObject>

-(void)exitAction:(NSInteger)index;

@end
@interface UserCenterFootCell : RRCTableViewCell
@property(nonatomic)id<UserCenterFootCellDelegate>delegate;

@property(nonatomic,strong)UIButton *exitBtn;
@end
