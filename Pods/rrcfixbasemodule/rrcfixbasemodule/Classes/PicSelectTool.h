//
//  PicSelectTool.h
//  MXSFramework
//
//  Created by 人人彩 on 2019/9/3.
//  Copyright © 2019 MXS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZYQAssetPickerController.h"
NS_ASSUME_NONNULL_BEGIN

@interface PicSelectTool : NSObject<UIActionSheetDelegate,ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate>

+(void)picSelect:(id)object;
+(void)sheetVc:(id)VC index:(NSInteger)buttonIndex num:(NSInteger)picNum Block:(void(^)(NSArray *imageArr))block;
+(void)sheetIndex:(NSInteger)buttonIndex withObjc:(UIView *)objc num:(NSInteger)picNum;
@end

NS_ASSUME_NONNULL_END
