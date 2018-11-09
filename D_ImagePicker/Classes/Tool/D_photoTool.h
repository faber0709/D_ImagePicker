//
//  D_photoTool.h
//  ImagePicker
//
//  Created by 丁鹏飞 on 2018/10/30.
//  Copyright © 2018 丁鹏飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface D_photoTool : UIView

+ (instancetype)sharePhotoTool;

//相册权限判断
- (BOOL)judgeIsHavePhotoAblumAuthority;

//获取相册内所有照片资源(ascending 为YES时，按照照片的创建时间升序排列;为NO时，则降序排列)
- (NSArray<PHAsset *> *)getAllAssetInPhotoAblumWithAscending:(BOOL)ascending;

//获取asset对应的图片
- (void)requestImageForAsset:(PHAsset *)asset size:(CGSize)size resizeMode:(PHImageRequestOptionsResizeMode)resizeMode completion:(void (^)(UIImage *))completion;

@end

NS_ASSUME_NONNULL_END
