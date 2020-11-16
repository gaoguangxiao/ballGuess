//
//  HomeOrderEntity.h
//  CPetro
//
//  Created by ggx on 2017/3/9.
//  Copyright © 2017年 高广校. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeOrderEntity : NSObject

@property(nonatomic,copy)NSString *orderId;



@property(nonatomic , copy) NSString *phone;
@property(nonatomic , copy) NSString *uordercash;//套餐id
@property(nonatomic , copy) NSString *sporder_id;
@property(nonatomic , copy) NSString *game_state;

@property(nonatomic , copy) NSString *addtime;
@property(nonatomic , copy) NSString *cardname;
@property(nonatomic , copy) NSString *game_userid;
@property(nonatomic , copy) NSString *uorderid;

@end
