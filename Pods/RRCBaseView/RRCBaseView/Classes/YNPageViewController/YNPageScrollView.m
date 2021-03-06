//
//  YNPageScrollView.m
//  YNPageViewController
//
//  Created by ZYN on 2018/4/22.
//  Copyright © 2018年 yongneng. All rights reserved.
//

#import "YNPageScrollView.h"
#import "UIView+YNPageExtend.h"
#import <objc/runtime.h>

@interface YNPageScrollView () <UIGestureRecognizerDelegate>

@end

@implementation YNPageScrollView

//是否支持多手势触发，返回YES，则可以多个手势一起触发方法，返回NO则为互斥
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    if ([self panBack:gestureRecognizer]) {
        return YES;
    }
    return NO;
}

- (BOOL)panBack:(UIGestureRecognizer *)gestureRecognizer {

    int location_X = 0.15 * kYNPAGE_SCREEN_WIDTH;

    if (gestureRecognizer == self.panGestureRecognizer) {
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint point = [pan translationInView:self];
        UIGestureRecognizerState state = gestureRecognizer.state;
        if (UIGestureRecognizerStateBegan == state || UIGestureRecognizerStatePossible == state) {
            CGPoint location = [gestureRecognizer locationInView:self];
//            NSLog(@"location.y：%f,",location.y);
            int temp1 = location.x;
            int tempy1 = location.y;
            int temp2 = kYNPAGE_SCREEN_WIDTH;
            int tempy2 = self.yn_height;
            NSInteger XX = temp1 % temp2;
            NSInteger YY = tempy1 % tempy2;
            if (point.x >0 && XX < location_X) {
                return YES;
            }
            if (self.failScolleGes && YY < self.panHeight) {
                return YES;
            }
            /*
            if (point.x > 0 && location.x < location_X && self.contentOffset.x <= 0) {
                return YES;
            }
             */
        }
    }
    return NO;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {

    if ([self panBack:gestureRecognizer]) {
        return NO;
    }
    return YES;
}


@end
