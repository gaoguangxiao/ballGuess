//
//  RRCProgressHUD.h
//  MXSFramework
//
//  Created by gaoguangxiao on 2019/5/16.
//  Copyright © 2019 MXS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RRCProgressHUD : UIView

+ (instancetype)showRRCAddedTo:(UIView *)view animated:(BOOL)animated;

+ (instancetype)showRRCAddedTo:(UIView *)view rect:(CGRect)rect;


/// 新loading方法
/// @param view <#view description#>
/// @param height <#height description#>
+ (instancetype)showLoadView:(UIView *)view andHeight:(CGFloat)height;

+ (BOOL)hideRRCForView:(UIView *)view animated:(BOOL)animated;

//调整loading 距离顶部距离 数值越大距离顶部越远
-(void)updateActivityMaginTop:(CGFloat)top;
@end

NS_ASSUME_NONNULL_END
