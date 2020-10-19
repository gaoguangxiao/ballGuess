//
//  UIDevice+Size.m
//  Pods-RRCBaseUI_Example
//
//  Created by gaoguangxiao on 2020/5/9.
//

#import "UIDevice+Size.h"

@implementation UIDevice (Size)

+(CGFloat)getScreenWidth{
    NSInteger width = (MIN([[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width));
    return width;
}

+(CGFloat)getScreenHeight{
    NSInteger height = (MAX([[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width));
    return height;
}

@end
