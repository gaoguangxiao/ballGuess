//
//  MGShowImage.h
//  觅购
//
//  Created by mac on 2017/11/22.
//  Copyright © 2017年 migou. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef  void(^didRemoveImage)(void);

@interface MGShowImage : UIView<UIScrollViewDelegate,UIActionSheetDelegate>
{
    UIImageView *showImage;
}

@property (nonatomic,copy) didRemoveImage removeImg;
@property (nonatomic,strong) NSMutableArray * photoArr;
@property (nonatomic ,assign) NSInteger allPhotoCount;

- (void)show:(UIView *)bgView didFinish:(didRemoveImage)tempBlock;

- (id)initWithFrame:(CGRect)frame byClick:(NSInteger)clickTag appendArray:(NSArray *)appendArray andImageArr:(NSArray *)imageArr isLocal:(BOOL)local;

@end
