//
//  UIImage+MatchmoduleImg.m
//  matchmodule
//
//  Created by 人人彩 on 2020/5/19.
//

#import "UIImage+MatchmoduleImg.h"
#import "UIImage+Bundle.h"
@implementation UIImage (MatchmoduleImg)
+ (nonnull UIImage *)matchModuleImageNamed:(nonnull NSString *)name
{
    return [UIImage imageNamed:name inBundleName:@"matchmodule"];
}
@end
