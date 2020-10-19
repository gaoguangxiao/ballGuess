//
//  RRCAlertManager.h
//  AFNetworking
//
//  Created by gaoguangxiao on 2020/5/7.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
NS_ASSUME_NONNULL_BEGIN

@interface RRCAlertManager : NSObject

DeclareSingleton(RRCAlertManager);

@property (nonatomic, strong) void(^doneBlock)(NSInteger index);

/// 弹文本提示
/// @param title <#title description#>
-(void)showPostingWithtitle:(NSString *)title;


/// 弹出文本提示
/// @param title 文本
/// @param top 距离顶部间距
-(void)showPostingWithtitle:(NSString *)title andTopMargin:(CGFloat)top;


-(void)showChoseWithtitle:(NSString *)title array:(NSArray *)array DoneBlock:(void (^)(NSInteger))block;
@end

NS_ASSUME_NONNULL_END
