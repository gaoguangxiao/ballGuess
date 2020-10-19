//
//  MGShowLocalImage.m
//  觅购
//
//  Created by mac on 2017/12/12.
//  Copyright © 2017年 migou. All rights reserved.
//

#import "MGShowLocalImage.h"
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import "UIImageView+WebCache.h"
#import "RRCDeviceConfigure.h"

@interface MGShowLocalImage ()
<UIScrollViewDelegate,
UIActionSheetDelegate>

@end

@implementation MGShowLocalImage
{
    UIScrollView *_scrollView;
    CGRect self_Frame;
    
}

- (id)initWithFrame:(CGRect)frame byClick:(NSInteger)clickTag andImageArr:(NSArray *)imageArr
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self_Frame = frame;
        self.alpha = 0.0f;
        [self configScrollViewWith:clickTag andImageArr:imageArr];
        UITapGestureRecognizer *tapGser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disappear)];
        tapGser.numberOfTouchesRequired = 1;
        tapGser.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapGser];
    }
    return self;
}
- (void)configScrollViewWith:(NSInteger)clickTag andImageArr:(NSArray *)imageArr{
    _scrollView = [[UIScrollView alloc] initWithFrame:self_Frame];
    _scrollView.pagingEnabled = true;
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(self.frame.size.width * imageArr.count, 0);
    _scrollView.bounces = NO;
    [self addSubview:_scrollView];
    
    float W = self.frame.size.width;
    for (int i = 0; i <imageArr.count; i++) {
//        if ([imageArr[i] isKindOfClass:[NSURL class]]) {
//
//        }else{
            UIScrollView *imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.frame.size.width * i, 0, self.frame.size.width, self.frame.size.height)];
            imageScrollView.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
            imageScrollView.delegate = self;
            imageScrollView.maximumZoomScale = 4;
            imageScrollView.minimumZoomScale = 1;
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            if ([imageArr[i] isKindOfClass:[UIImage class]]) {
                imageView.image = imageArr[i];
            }else if ([imageArr[i] isKindOfClass:[NSString class]]){
                [imageView sd_setImageWithURL:[self linkCodeWithUrlStr:imageArr[i]] placeholderImage:nil options:SDWebImageRetryFailed];
            } else{
                ALAsset *asset=imageArr[i];
                imageView.image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
            }
            [imageScrollView addSubview:imageView];
            [_scrollView addSubview:imageScrollView];
            
//        }
        
        
    }
    [_scrollView setContentOffset:CGPointMake(W * clickTag, 0) animated:YES];
    
}

-(NSURL *)linkCodeWithUrlStr:(NSString *)url{
    NSString *imgUrl = [[NSString stringWithFormat:@"%@",url]  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [NSURL URLWithString:imgUrl];
}

- (void)show:(UIView *)bgView didFinish:(didRemoveImage)tempBlock{
    
    [bgView addSubview:self];
    
    _removeImg = tempBlock;
    
    [UIView animateWithDuration:.4f animations:^(){
        
        self.alpha = 1.0f;
        
    } completion:^(BOOL finished) {
        
    }];
    
}
- (void)disappear{
    
    _removeImg();
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reload" object:@"chatCell"];
    
}

@end
