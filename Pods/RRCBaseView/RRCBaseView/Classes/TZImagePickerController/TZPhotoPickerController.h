//
//  TZPhotoPickerController.h
//  TZImagePickerController
//
//  Created by 谭真 on 15/12/24.
//  Copyright © 2015年 谭真. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TZAssetModel.h"

@class TZAlbumModel;
@interface TZPhotoPickerController : UIViewController

@property (nonatomic, assign) BOOL isFirstAppear;
@property (nonatomic, assign) NSInteger columnNumber;
@property (nonatomic, strong) TZAlbumModel *model;

@property (nonatomic, strong) NSMutableArray<TZAssetModel *> *selectedModels;
@property (nonatomic, strong) NSMutableArray *selectedAssetIds;
@property (nonatomic, strong) NSMutableArray *selectedAssets;
@end


@interface TZCollectionView : UICollectionView

@end
