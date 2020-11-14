//
//  EntityCatalog.h
//  SimpleSrore
//
//  Created by gaoguangxiao on 2017/4/2.
//  Copyright © 2017年 高广校. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>

#import "EntityGoods.h"
@interface EntityCatalog : NSObject
@property(nonatomic,copy)NSString *city;
@property(nonatomic,copy)NSString *company;
@property(nonatomic , copy) NSString *companytype;
@property(nonatomic , strong) NSArray *flows;
@property(nonatomic , copy) NSString *name;
@property(nonatomic , copy) NSString *type;
@end
