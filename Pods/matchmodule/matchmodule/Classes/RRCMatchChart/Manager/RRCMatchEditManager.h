//
//  RRCMatchEditManager.h
//  MXSFramework
//
//  Created by renrencai on 2019/4/30.
//  Copyright © 2019 MXS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
@class RRCMatchInfoModel;
NS_ASSUME_NONNULL_BEGIN
typedef void(^HandleMatchBlockBOOL)(BOOL result);

@interface RRCMatchEditManager : NSObject

DeclareSingleton(RRCMatchEditManager);


-(void)enableUpdateMatchInfo:(RRCMatchInfoModel *)matchInfoModel AtRow:(NSInteger)row column:(NSInteger)column andhandleMatchinfo:(HandleMatchBlockBOOL)block;
@end

NS_ASSUME_NONNULL_END
