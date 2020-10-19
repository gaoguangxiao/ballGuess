//
//  BaseTableView.m
//  MXSFramework
//
//  Created by 人人彩 on 2019/4/18.
//  Copyright © 2019 MXS. All rights reserved.
//

#import "BaseTableView.h"

@interface BaseTableView ()
@property (nonatomic,assign) NSInteger page;
@end
@implementation BaseTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        [self initTab];
    }
    return self;
}

-(void)initTab{
    self.estimatedRowHeight = 0;     //防止上拉加载页面跳一下
    self.estimatedSectionFooterHeight = 0;
    self.tableFooterView = [UIView new];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.showsVerticalScrollIndicator = NO;
    if ([self respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//11.0之后
        } else {
            self.baseViewController.automaticallyAdjustsScrollViewInsets = NO;//7.0~11.0
        }
    }
}

- (UIViewController *)baseViewController{
    
    id next = self.nextResponder;
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return next;
        }
        next = [next nextResponder];
    } while (next != nil);
    
    if(next == nil){
        next = [[UIApplication sharedApplication] delegate].window.rootViewController;
        if([next isKindOfClass:[UINavigationController class]]){
            next = ((UINavigationController *)next).topViewController;
        }
        return next;
    }
    return nil;
}

@end
