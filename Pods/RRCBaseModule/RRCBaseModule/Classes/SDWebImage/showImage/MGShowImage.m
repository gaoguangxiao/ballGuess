//
//  MGShowImage.m
//  觅购
//
//  Created by mac on 2017/11/22.
//  Copyright © 2017年 migou. All rights reserved.
//

#import "MGShowImage.h"
#import "UIImageView+WebCache.h"
#import "RRCDeviceConfigure.h"
#import "MBProgressHUD.h"
//#import "Log.h"

@interface MGShowImage()<UIAlertViewDelegate>

@end
@implementation MGShowImage{
    
    UIScrollView *_scrollView;
    CGRect self_Frame;
    NSInteger page;
    BOOL doubleClick;
    BOOL isDoubleClickState;
    UIPageControl *pageControl;
    UILabel *label;
    UIImageView *currentImageView;
}

- (id)initWithFrame:(CGRect)frame byClick:(NSInteger)clickTag appendArray:(NSArray *)appendArray andImageArr:(NSArray *)imageArr isLocal:(BOOL)local{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self_Frame = frame;
        
        //      self.backgroundColor = [UIColor redColor];
//        self.alpha = 0.0f;
        page = 0;
        doubleClick = YES;
        
        [self configScrollViewWith:clickTag andAppendArray:appendArray andImageArr:imageArr isLocal:local];
        
        //通过通知监听屏幕旋转
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(OrientationDidChange:)name:UIDeviceOrientationDidChangeNotification object:nil];
        
        UITapGestureRecognizer *tapGser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disappear)];
        tapGser.numberOfTouchesRequired = 1;
        tapGser.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapGser];
        
        UITapGestureRecognizer *doubleTapGser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeBig:)];
        doubleTapGser.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTapGser];
        [tapGser requireGestureRecognizerToFail:doubleTapGser];
        
        UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longTap:)];
        [self addGestureRecognizer:longTap];
        
        
    }
    return self;
    
    
}


-(void)OrientationDidChange:(NSNotification *)notificaiton{
    
    
    /*
     UIDeviceOrientationUnknown,
     UIDeviceOrientationPortrait,            // Device oriented vertically, home button on the bottom
     UIDeviceOrientationPortraitUpsideDown,  // Device oriented vertically, home button on the top
     UIDeviceOrientationLandscapeLeft,       // Device oriented horizontally, home button on the right
     UIDeviceOrientationLandscapeRight,      // Device oriented horizontally, home button on the left
     UIDeviceOrientationFaceUp,              // Device oriented flat, face up
     UIDeviceOrientationFaceDown
     */
    UIDevice *device = notificaiton.object;
    float  radian=0;
    switch (device.orientation) {
        case UIDeviceOrientationLandscapeRight://设备向右
            radian =1.5*M_PI;
            break;
        case UIDeviceOrientationPortraitUpsideDown://设备向下
            radian =M_PI;
            break;
        case UIDeviceOrientationLandscapeLeft://设备向左
            radian =M_PI_2;
            break;
        case UIDeviceOrientationPortrait://设备向上
            radian =0;
            break;
        default:
            break;
    }
    NSLog(@"%ld",device.orientation);
    [UIView animateWithDuration:0.5 animations:^{
        currentImageView.transform = CGAffineTransformMakeRotation(radian);
    }];
    
}


- (void)longTap:(UILongPressGestureRecognizer *)reco
{
    if ([reco state]==UIGestureRecognizerStateBegan) {
        [[reco view]becomeFirstResponder];
        UIActionSheet *act = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存图片", nil];
        [act showInView:self.superview];
        
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self saveClick];
    }
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}

-(BOOL) canPerformAction:(SEL)action withSender:(id)sender{
    if (action == @selector(saveClick) ) {
        return YES;
    }
    return NO; //隐藏系统默认的菜单项
}

- (void)saveClick
{
    UIImageView *imageView = (UIImageView *)[self viewWithTag:page + 1000];
    if (imageView.image) {
        UIImageWriteToSavedPhotosAlbum(imageView.image, self,
                                       @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"存储失败"
                                                    message:@"请到设置>隐私>相片打开本应用的权限设置."
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
        [al show];
    }else{
        UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"存储成功"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil, nil];
        [al show];
    }
    
}
//alertView代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        //
    }else{
        //        prefs:root=Privacy&path=CONTACTS
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

- (void)configScrollViewWith:(NSInteger)clickTag andAppendArray:(NSArray *)appendArray andImageArr:(NSArray *)imageArr isLocal:(BOOL)local{
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self_Frame];
    _scrollView.pagingEnabled = true;
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(self.frame.size.width * appendArray.count, 0);
    _scrollView.bounces = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];
    
    float W = self.frame.size.width;
    for (int i = 0; i <appendArray.count; i++) {
        
        UIScrollView *imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.frame.size.width * i, 0, self.frame.size.width, self.frame.size.height)];
        imageScrollView.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
        imageScrollView.delegate = self;
        imageScrollView.maximumZoomScale = 4;
        imageScrollView.minimumZoomScale = 1;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        if (i==0) {
            currentImageView = imageView;
        }
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        __block MBProgressHUD *myHud = [MBProgressHUD showHUDAddedTo:imageView animated:YES];
        myHud.mode = MBProgressHUDModeIndeterminate;
        myHud.removeFromSuperViewOnHide = YES;
        myHud.label.text = @"加载中";
        if ([imageArr[0] isKindOfClass:[NSString class]]&&[imageArr[0] isEqualToString:@"image"]) {
            imageView.image = appendArray[i];
            [myHud hideAnimated:YES];
        }else
            //如果为侧滑的时候
            
            if ([imageArr[0] isEqualToString:@"我不为空"]){
                //本地图片
                if ([appendArray[i] hasSuffix:@".jpg"]) {
                     [imageView sd_setImageWithURL:[NSURL fileURLWithPath:appendArray[i]] placeholderImage:[UIImage imageNamed:@"callBg"] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                        int progress = floor(((float)receivedSize/expectedSize)*100);
                        float progressValue = progress/100.0f;
                        myHud.progress = progressValue;
                    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                        [myHud hideAnimated:YES];
                    }];
                    
                }else{
                    //网络图
                    if ([appendArray[i] length] >0) {
                        UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:appendArray[i]];
                        if (cacheImage) {
                            imageView.image = cacheImage;
                            [myHud hideAnimated:YES];
                        }else{
                            
                            [imageView sd_setImageWithURL:[NSURL URLWithString:appendArray[i]] placeholderImage:[[SDImageCache sharedImageCache] imageFromDiskCacheForKey:appendArray[i]] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                                int progress = floor(((float)receivedSize/expectedSize)*100);
                                float progressValue = progress/100.0f;
                                myHud.progress = progressValue;
                            } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                                ////      本身SDwebimage 支持硬盘缓存是你要加代码实现的来硬盘缓存
                                if (image) {
                                    [[SDImageCache sharedImageCache] storeImage:image forKey:appendArray[i] completion:nil];
                                }
                                
                                [myHud hideAnimated:YES];
                            }];
                        }
                    }else{
                        imageView.image = [UIImage imageNamed:@"暂无图片"];
                        [myHud hideAnimated:YES];
                    }
                }
            }else{
                //如果是图片
                if ([appendArray[i] isKindOfClass:[UIImage class]]) {
                    imageView.image =appendArray[i];
                    [myHud hideAnimated:YES];
                }else{
                    [imageView sd_setImageWithURL:local?[NSURL fileURLWithPath:appendArray[i]]:[NSURL URLWithString:appendArray[i]] placeholderImage:[UIImage imageNamed:@"动态长图默认"] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                        int progress = floor(((float)receivedSize/expectedSize)*100);
                        float progressValue = progress/100.0f;
                        myHud.progress = progressValue;
                    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                        [myHud hideAnimated:YES];
                        float imageHeight = kScreenWidth*image.size.height/image.size.width;

                        if (image.size.height<=kScreenHeight || imageHeight <=kScreenHeight) {
                            imageView.image =image;
                            return ;
                        }
                        //长图
                        UIImage *scaleimage= nil;
                        CGRect rect =imageView.frame;
                        //经过统计，imageView.frame 大于 10000，就不会显示
                        if (imageHeight>10000) {
                            float height =  kScreenWidth*image.size.height/image.size.width;
                            rect.size= CGSizeMake(kScreenWidth, height);
                            scaleimage = [self ct_imageFromImage:image inRect:rect];
                        }else{
                            float height =  kScreenWidth*image.size.height/image.size.width;
                            rect.size=CGSizeMake(kScreenWidth, height);
                            scaleimage= image;
                        }
                        imageView.image =scaleimage;
                        imageView.frame = rect;
                        imageScrollView.contentSize = rect.size;
                    }];
                }
            }
        
        
        [imageScrollView addSubview:imageView];
        [_scrollView addSubview:imageScrollView];
        
        imageScrollView.tag = 100 + i ;
        imageView.tag = 1000 + i;
        
        
    }
    [_scrollView setContentOffset:CGPointMake(W * clickTag, 0) animated:YES];
    page = clickTag;
    if (appendArray.count != 1) {
        int pageNum = _scrollView.contentOffset.x / _scrollView.frame.size.width;
        label =[[UILabel alloc]initWithFrame:CGRectMake(35,kScreenHeight -50,kScreenWidth-70, 30)];
        label.textColor =[UIColor whiteColor];
        label.textAlignment =NSTextAlignmentCenter;
        label.text =[NSString stringWithFormat:@"%d/%ld",pageNum+1,(unsigned long)appendArray.count];
        [self addSubview:label];
        
        self.allPhotoCount = appendArray.count;
    }
}

- (UIImage *)ct_imageFromImage:(UIImage *)image inRect:(CGRect)rect{
    
    //    //把像 素rect 转化为 点rect（如无转化则按原图像素取部分图片）
    CGFloat scale = 1.8;
    CGFloat x= rect.origin.x*scale,y=rect.origin.y*scale,w=rect.size.width*scale,h=rect.size.height*scale;
    CGRect dianRect = CGRectMake(x, y, w, h);
    //截取部分图片并生成新图片
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, dianRect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef scale:scale orientation:UIImageOrientationUp];
    //防止内存泄漏
    CGImageRelease(newImageRef);
    return newImage;
}

- (UIImage *)jx_WaterImageWithImage:(UIImage *)image text:(NSString *)text textPoint:(CGPoint)point attributedString:(NSDictionary * )attributed{
    //1.开启上下文
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    //2.绘制图片
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    //添加水印文字
    [text drawAtPoint:point withAttributes:attributed];
    //3.从上下文中获取新图片
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    //4.关闭图形上下文
    UIGraphicsEndImageContext();
    //返回图片
    return newImage;
}

// 给图片添加图片水印
- (UIImage *)jx_WaterImageWithImage:(UIImage *)image waterImage:(UIImage *)waterImage waterImageRect:(CGRect)rect{
    
    //1.获取图片
    
    //2.开启上下文
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    //3.绘制背景图片
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    //绘制水印图片到当前上下文
    [waterImage drawInRect:rect];
    //4.从上下文中获取新图片
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    //5.关闭图形上下文
    UIGraphicsEndImageContext();
    //返回图片
    return newImage;
}

- (void)disappear{
    
    _removeImg();
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reload" object:@"chatCell"];
    
    
    
}


- (void)changeBig:(UITapGestureRecognizer *)tapGes{
    
    CGFloat newscale = 1.9;
    UIScrollView *currentScrollView = (UIScrollView *)[self viewWithTag:page + 100];
    CGRect zoomRect = [self zoomRectForScale:newscale withCenter:[tapGes locationInView:tapGes.view] andScrollView:currentScrollView];
    
    if (doubleClick == YES)  {
        
        [currentScrollView zoomToRect:zoomRect animated:YES];
        
    }else {
        [currentScrollView zoomToRect:currentScrollView.frame animated:YES];
    }
    
    doubleClick = !doubleClick;
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    UIImageView *imageView = (UIImageView *)[self viewWithTag:scrollView.tag + 900];
    return imageView;
    
}

- (CGRect)zoomRectForScale:(CGFloat)newscale withCenter:(CGPoint)center andScrollView:(UIScrollView *)scrollV{
    
    CGRect zoomRect = CGRectZero;
    zoomRect.size.height = scrollV.frame.size.height / newscale;
    zoomRect.size.width = scrollV.frame.size.width  / newscale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    // NSLog(@" === %f",zoomRect.origin.x);
    return zoomRect;
    
}

- (void)show:(UIView *)bgView didFinish:(didRemoveImage)tempBlock{
    
    [bgView addSubview:self];
    [bgView bringSubviewToFront:self];
    _removeImg = tempBlock;
    
//    [UIView animateWithDuration:.4f animations:^(){
//
//        self.alpha = 1.0f;
//
//    } completion:^(BOOL finished) {
//
//    }];
    
}


#pragma mark - ScorllViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    CGPoint offset = _scrollView.contentOffset;
    page = offset.x / self.frame.size.width ;
    
    currentImageView =[(UIImageView *)self viewWithTag:page +1000];
    UIScrollView *scrollV_next = (UIScrollView *)[self viewWithTag:page+100+1]; //前一页
    
    if (scrollV_next.zoomScale != 1.0){
        
        scrollV_next.zoomScale = 1.0;
    }
    
    UIScrollView *scollV_pre = (UIScrollView *)[self viewWithTag:page+100-1]; //后一页
    if (scollV_pre.zoomScale != 1.0){
        scollV_pre.zoomScale = 1.0;
    }
    
    label.text =[NSString stringWithFormat:@"%ld/%ld",page + 1,(long)self.allPhotoCount];
    
    //   // NSLog(@"page == %d",page);
    //    int index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
    //    pageControl.currentPage = index;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    int pageNum = scrollView.contentOffset.x / scrollView.frame.size.width;
    //    NSLog(@"%d", page);
    // pageNum + 1  图片从 1开始
    
    //  label.text =[NSString stringWithFormat:@"%d/%ld",pageNum + 1,(long)self.allPhotoCount];
    
}


@end

