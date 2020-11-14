//
//  HomeModuleCell.h
//  KnowXiTong
//
//  Created by ggx on 2017/4/6.
//  Copyright © 2017年 高广校. All rights reserved.
//

#import "RRCTableViewCell.h"

@protocol HomeModuleCellDelegate <NSObject>
-(void)homeModuleActionAtIndedx:(NSInteger)index;
@end

@interface HomeModuleCell : RRCTableViewCell
@property(nonatomic,strong)id<HomeModuleCellDelegate>delegate;
@end
