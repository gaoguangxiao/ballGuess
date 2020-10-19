//
//  RRCLiveGifLoad.h
//  MXSFramework
//
//  Created by 人人彩 on 2020/5/18.
//  Copyright © 2020 MXS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RRCLiveGifLoad : UIImageView

@property (nonatomic,copy) void (^TimeOutBlock)(BOOL timeOut);
//开始动画
- (void)startLoadingAnimation;
//结束动画
- (void)stopLoadingAnimation;
@end

NS_ASSUME_NONNULL_END
