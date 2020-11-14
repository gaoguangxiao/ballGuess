//
//  BlogTableViewHelper.h
//  SimpleSrore
//
//  Created by ggx on 2017/3/16.
//  Copyright © 2017年 高广校. All rights reserved.
//

#import <Foundation/Foundation.h>

//#import "Service.h"


#import <UIKit/UIKit.h>
@interface BlogTableViewHelper : NSObject<UITableViewDelegate,UITableViewDataSource>
+ (instancetype)helperWithTableView:(UITableView *)tableView userId:(NSUInteger)userId;

@property(nonatomic,strong)void(^didSelectRowAtPushViewIndexPath)(NSInteger indexTag);
//- (void)fetchDataWithCompletionHandler:(void(^)(BOOL b,CGDataResult *r))completionHander;
//- (void)setVCGenerator:(ViewControllerGenerator)VCGenerator;
@end
