//
//  UserHeadCell.h
//  dongni
//
//  Created by gaoguangxiao on 16/8/16.
//  Copyright © 2016年 河南善泽文化传媒有限公司. All rights reserved.
//

#import "RRCTableViewCell.h"

@interface UserHeadCell : RRCTableViewCell

@property(nonatomic,strong)void(^PushPartAndCharge)(NSInteger index);

/* 设置用户信息**/
-(void)setUserData:(EntityUser *)user;

@end
