//
//  UIImage+Matchscoremodule.m
//  matchscoremodule
//
//  Created by gaoguangxiao on 2020/5/16.
//

#import "UIImage+Matchscoremodule.h"
#import "UIImage+Bundle.h"
@implementation UIImage (Matchscoremodule)

+ (nonnull UIImage *)matchscoremoduleImageNamed:(nonnull NSString *)name{
    return [UIImage imageNamed:name inBundleName:@"matchscoremodule"];
}


@end
