//
//  TZNavTop.h
//  MXSFramework
//
//  Created by 人人彩 on 2019/10/22.
//  Copyright © 2019 MXS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TZNavTop : UIView
@property (nonatomic,copy) NSString *navStr;
@property (nonatomic,copy) void (^DropBlock)(BOOL isProp);
-(void)dropViewAction;
@end

NS_ASSUME_NONNULL_END
