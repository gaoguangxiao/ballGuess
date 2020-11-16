//
//  UserCenterCell.h
//  SimpleSrore
//
//  Created by ggx on 2017/3/16.
//  Copyright © 2017年 高广校. All rights reserved.
//

#import "RRCTableViewCell.h"

@class EntityUser;
@interface UserCenterCell : RRCTableViewCell
@property(nonatomic,strong)UILabel *keyText;
@property(nonatomic,strong)UILabel *userText;
@property(nonatomic,strong)NSDictionary *userDic;
@end
