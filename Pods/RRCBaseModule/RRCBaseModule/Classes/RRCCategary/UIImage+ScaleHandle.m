//
//  UIImage+ScaleHandle.m
//  RRCBaseModule
//
//  Created by gaoguangxiao on 2020/5/22.
//

#import "UIImage+ScaleHandle.h"

@implementation UIImage (ScaleHandle)


+ (UIImage *)scalewithImg:(UIImage *)img withWidth:(float)targetWidth ToKBytes:(float)size
{
    CGSize imageSize = img.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    if (targetWidth == 0) {
        targetWidth = width;
    }
    CGFloat targetHeight = (targetWidth / width) * height;
    
    targetWidth = targetWidth *2;
    targetHeight = targetHeight *2;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [img drawInRect:CGRectMake(0,0,targetWidth,  targetHeight)];
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData * imageData = UIImageJPEGRepresentation(img,1);
    
    if (imageData.length /1024.0 > size) {
        
        NSData *lastData = nil;
        while ([imageData length]/1024.0 > size) {
            imageData = UIImageJPEGRepresentation(img, 0.1);
            //防止无法跳出循环
            if (imageData.length/1024.0 > size && lastData.length == imageData.length) {
                break;
            }
            lastData = imageData;
        }
        img = [UIImage imageWithData:imageData];
        
    }
    return img;
    
}

+ (UIImage *)scaleToKBytes:(float)size withImg:(UIImage *)img withWidth:(float)targetWidth
{
    NSData * imageData = UIImageJPEGRepresentation(img,1);
    NSData *lastData = nil;
    while ([imageData length]/1024.0 > size) {
        imageData = UIImageJPEGRepresentation(img, 0.1);
        //防止无法跳出循环
        if (imageData.length/1024.0 > size && lastData.length == imageData.length) {
            break;
        }
        lastData = imageData;
    }
    img = [UIImage imageWithData:imageData];
    
    if (imageData.length /1024.0 > size) {
        CGSize imageSize = img.size;
        CGFloat width = imageSize.width;
        CGFloat height = imageSize.height;
        
        if (targetWidth == 0) {
            targetWidth = width;
        }
        CGFloat targetHeight = (targetWidth / width) * height;
        UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
        [img drawInRect:CGRectMake(0,0,targetWidth,  targetHeight)];
        img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return img;
}

@end
