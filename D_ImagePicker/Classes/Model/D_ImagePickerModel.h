//
//  D_ImagePickerModel.h
//  ImagePicker
//
//  Created by 丁鹏飞 on 2018/10/30.
//  Copyright © 2018 丁鹏飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface D_ImagePickerModel : NSObject

@property (nonatomic, strong) PHAsset   *asset;
@property (nonatomic, strong) UIImage   *image;
@property (nonatomic, assign) BOOL      selected;//用在选择点击的记录
@property (nonatomic, assign) NSInteger ImageTag;

@property (nonatomic, strong) NSString  *testStr;
@end

NS_ASSUME_NONNULL_END
