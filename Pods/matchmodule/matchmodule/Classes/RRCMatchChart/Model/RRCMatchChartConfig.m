//
//  RRCMatchConfig.m
//  MXSFramework
//
//  Created by renrencai on 2019/4/18.
//  Copyright © 2019年 MXS. All rights reserved.
//

#import "RRCMatchChartConfig.h"

@implementation RRCMatchChartConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        
//        self.left_navigationColor = COLORRGB(0xF55875);
//        self.right_navigationColor =COLORRGB(0xF5274D);
//        self.backLastVcImage = [UIImage imageNamed:@"返回白色"];
//        self.rightNav_image  = [UIImage imageNamed:@"selectIcon"];
        
//        self.statusBarStyle = [AppToolManager setStatusColor];
    }
    return self;
}

+ (instancetype)defaultConfig {
    
    return [[self alloc] init];
};
@end
