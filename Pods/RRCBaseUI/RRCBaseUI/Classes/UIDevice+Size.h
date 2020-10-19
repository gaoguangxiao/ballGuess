//
//  UIDevice+Size.h
//  Pods-RRCBaseUI_Example
//
//  Created by gaoguangxiao on 2020/5/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (Size)

/// 获取屏幕固定宽度
+(CGFloat)getScreenWidth;

/// 获取屏幕固定高度
+(CGFloat)getScreenHeight;
@end

NS_ASSUME_NONNULL_END
