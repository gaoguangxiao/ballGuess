//
//  UIImage+ScaleHandle.h
//  RRCBaseModule
//
//  Created by gaoguangxiao on 2020/5/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ScaleHandle)


+ (UIImage *)scalewithImg:(UIImage *)img withWidth:(float)targetWidth ToKBytes:(float)size;


+ (UIImage *)scaleToKBytes:(float)size withImg:(UIImage *)img withWidth:(float)targetWidth;

@end

NS_ASSUME_NONNULL_END
