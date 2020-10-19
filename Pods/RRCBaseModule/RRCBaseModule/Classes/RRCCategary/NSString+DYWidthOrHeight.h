//
//  NSString+WidthOrHeight.h
//  dianbo17
//
//  Created by Apple on 16/4/13.
//  Copyright © 2016年 17dianbo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (DYWidthOrHeight)

- (float)LabelHeight:(float)fontSize width:(float)width;

- (float)LabelWidth:(float)fontSize;

- (float)LabelBoldWidth:(float)fontSize;
@end
