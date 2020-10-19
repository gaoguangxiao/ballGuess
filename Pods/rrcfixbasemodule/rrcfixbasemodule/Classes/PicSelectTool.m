//
//  PicSelectTool.m
//  MXSFramework
//
//  Created by 人人彩 on 2019/9/3.
//  Copyright © 2019 MXS. All rights reserved.
//

#import "PicSelectTool.h"
#import "TZImagePickerController.h"
#import "UIView+DYViewController.h"
@implementation PicSelectTool

+(void)picSelect:(id)object{
    UIActionSheet* actionSheet=nil;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        actionSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:object cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选取",@"拍照", nil];
    }else{
        actionSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:object cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选取", nil];
    }
    [actionSheet showInView:object];
}

+(void)sheetVc:(UIView *)view index:(NSInteger)buttonIndex num:(NSInteger)picNum Block:(void(^)(NSArray *imageArr))block{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus photoStatus) {
        dispatch_async(dispatch_get_main_queue(), ^{
    
            if (photoStatus == PHAuthorizationStatusAuthorized) {
                if (buttonIndex == 0) {
                    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:picNum delegate:nil];
                    imagePickerVc.showSelectBtn = YES;
                    imagePickerVc.showSelectedIndex = YES;
                    imagePickerVc.showPhotoCannotSelectLayer = YES;
                    imagePickerVc.allowTakePicture = NO;
                    imagePickerVc.allowTakeVideo = NO;
                    imagePickerVc.allowPickingVideo = NO;
                    imagePickerVc.allowPickingOriginalPhoto = NO;
                    // You can get the photos by block, the same as by delegate.
                    // 你可以通过block或者代理，来得到用户选择的照片.
                    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                        block(photos);
                    }];
                    imagePickerVc.imagePickerControllerDidCancelHandle = ^{
                        block(nil);
                    };
                    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
                    [view.viewController presentViewController:imagePickerVc animated:YES completion:nil];
                }else{
                    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                        UIImagePickerController* pickerViewController=[[UIImagePickerController alloc]init];
                        pickerViewController.delegate = view;
                        pickerViewController.sourceType=UIImagePickerControllerSourceTypeCamera;
                        [view.viewController presentViewController:pickerViewController animated:YES completion:nil];
                    }
                    
                }
            }
        });
    }];
    
}


+(void)sheetIndex:(NSInteger)buttonIndex withObjc:(UIView *)objct num:(NSInteger)picNum{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus photoStatus) {
        dispatch_async(dispatch_get_main_queue(), ^{
    
            if (photoStatus == PHAuthorizationStatusAuthorized) {
                ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                {
                    if (buttonIndex == 0) {
//                        self.picker = [[ZYQAssetPickerController alloc] init];
                        picker.maximumNumberOfSelection = picNum;
                        picker.assetsFilter = ZYQAssetsFilterAllPhotos;
                        picker.showEmptyGroups=NO;
                        picker.delegate = objct;
                        picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                            if ([(ZYQAsset*)evaluatedObject mediaType]==ZYQAssetMediaTypeVideo) {
                                return NO;
                            } else {
                                return YES;
                            }
                        }];
                        [objct.viewController presentViewController:picker animated:YES completion:NULL];
                    }else if (buttonIndex == 1){
                        UIImagePickerController* pickerViewController=[[UIImagePickerController alloc]init];
                        pickerViewController.delegate = objct;
                        pickerViewController.sourceType=UIImagePickerControllerSourceTypeCamera;
                        [objct.viewController presentViewController:pickerViewController animated:YES completion:nil];
                    }
                }else{
                    if (buttonIndex == 0) {
                        picker = [[ZYQAssetPickerController alloc] init];
                        picker.maximumNumberOfSelection = picNum;
                        picker.assetsFilter = ZYQAssetsFilterAllPhotos;
                        picker.showEmptyGroups=NO;
                        picker.delegate = objct;
                        picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                            if ([(ZYQAsset*)evaluatedObject mediaType]==ZYQAssetMediaTypeVideo) {
                               
                                return NO;
                            } else {
                                return YES;
                            }
                        }];
                        [objct.viewController presentViewController:picker animated:YES completion:NULL];
                    }
                }
            }
        });
    }];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"clickedButtonAtIndex.........");
    
}

@end
