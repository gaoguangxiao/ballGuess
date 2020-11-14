//
//  RRCMatchProgressView.h
//  MXSFramework
//
//  Created by 人人彩 on 2020/4/13.
//  Copyright © 2020 MXS. All rights reserved.
//

#import "RRCView.h"
@class RRCMatchProgressItem;
@interface RRCMatchProgressView : RRCView
@property (nonatomic,strong) NSDictionary *progressDic;
@end

@interface RRCMatchProgressItem : RRCView
@property (nonatomic,assign) float progressRate;
@end



