//
//  RRCMatchEnterBallView.h
//  MXSFramework
//
//  Created by gaoguangxiao on 2019/7/10.
//  Copyright © 2019 MXS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    RRCEnterBallVoicePlayerTogether, //视图和播放一起
    RRCEnterBallVoicePlayerBefore,    //视图出现之前播放
    RRCEnterBallVoicePlayerAfter,    //视图之后播放
} RRCEnterBallVoicePlayer;

@interface RRCMatchEnterBallView : UIView

/**进球是否展示视图 默认NO ，进球声音一直播放*/
@property (nonatomic, assign) BOOL isHiddenEnterView;

-(void)setUpNewEnterBall:(NSArray *)arr;

/**声音播放和视图显示顺序 */
@property (nonatomic, assign) RRCEnterBallVoicePlayer  enterBallVoicePlayer;

/**是否播放声音 */
@property (nonatomic, assign) BOOL isPlayerVoice;

/**是否具备动画 */
@property (nonatomic, assign) BOOL isInsertAnimations;

/**播放声音地址 isplayerVoice 必须 true */
@property (nonatomic, strong) NSString *playUrl;

/**消失时间 默认5S*/
@property (nonatomic, assign) CGFloat disappearTime;

/**出现时 距离底部间距 默认 10pt */
@property (nonatomic, assign) CGFloat appearBottomMargin;
@end

NS_ASSUME_NONNULL_END
