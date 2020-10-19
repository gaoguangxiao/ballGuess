//
//  RRCThemeManager.h
//  MXSFramework
//
//  Created by gaoguangxiao on 2020/4/1.
//  Copyright © 2020 MXS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
NS_ASSUME_NONNULL_BEGIN

@interface RRCThemeManager : NSObject

DeclareSingleton(RRCThemeManager);

-(NSInteger )getThemeState;

@end

NS_ASSUME_NONNULL_END
