//
//  RRCLiveGifLoad.m
//  MXSFramework
//
//  Created by 人人彩 on 2020/5/18.
//  Copyright © 2020 MXS. All rights reserved.
//

#import "RRCLiveGifLoad.h"
#import "UIImage+MatchmoduleImg.h"
#import "NSBundle+Resources.h"
@interface RRCLiveGifLoad ()
@property (nonatomic,strong) NSTimer *bufferTimer;//缓冲
@end
@implementation RRCLiveGifLoad

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self startGIFViewAnimationWithImages];
    }
    return self;
}

- (void)startGIFViewAnimationWithImages{
    NSMutableArray *result = [NSMutableArray array];
    for (NSUInteger i = 0; i <= 35; i++) {
         NSBundle *imageBundle = [NSBundle bundleName:@"matchmodule" andResourcesBundleName:@"liveLogoGif"];
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"logogif_000%02ld",i] inBundle:imageBundle compatibleWithTraitCollection:nil];
//        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"logogif_000%02ld",i]];
        if (image) {
            [result addObject:image];
        }
    }
    self.animationImages = result;
    self.animationDuration = result.count * 0.05;
}


//开始动画
- (void)startLoadingAnimation {
    self.hidden = NO;
    [self startAnimating];
    [self initBufferTimer];
}

-(void)startLoadingAnimationIsNeedOutTime:(BOOL)isNeedOutTime{
    if (isNeedOutTime) {
        [self initBufferTimer];
    }
    
    self.hidden = NO;
    [self startAnimating];
}
//结束动画
- (void)stopLoadingAnimation {
    self.hidden = YES;
    [self stopAnimating];
    [self desBufferTimer];
}

-(void)initBufferTimer{
    self.bufferTimer = [NSTimer timerWithTimeInterval:30. target:self selector:@selector(bufferTimerAction) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.bufferTimer forMode:NSDefaultRunLoopMode];
}

-(void)bufferTimerAction{
    if (!self.hidden) {
        //超过30s
        [self stopLoadingAnimation];
        if (self.TimeOutBlock) {
            self.TimeOutBlock(YES);
        }
    }
}

-(void)desBufferTimer{
    if (_bufferTimer) {
        [_bufferTimer invalidate];
        _bufferTimer = nil;
    }
}

-(void)dealloc{
    [self desBufferTimer];
}

@end
