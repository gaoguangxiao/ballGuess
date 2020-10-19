//
//  MGShowLocalImage.h
//  觅购
//
//  Created by mac on 2017/12/12.
//  Copyright © 2017年 migou. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef  void(^didRemoveImage)(void);

@interface MGShowLocalImage : UIView
@property (nonatomic,copy) didRemoveImage removeImg;

- (void)show:(UIView *)bgView didFinish:(didRemoveImage)tempBlock;
- (id)initWithFrame:(CGRect)frame byClick:(NSInteger)clickTag andImageArr:(NSArray *)imageArr;
@end
