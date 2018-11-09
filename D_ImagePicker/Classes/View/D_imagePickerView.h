//
//  D_imagePickerView.h
//  ImagePicker
//
//  Created by 丁鹏飞 on 2018/10/30.
//  Copyright © 2018 丁鹏飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "D_photoTool.h"
#import "D_ImagePickerModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^handler)(NSMutableArray<D_ImagePickerModel *> *selectPhotos);

@protocol D_imagePickerViewDelegate <NSObject>

/**
 选中代理

 @param imageModel image的model
 */
- (void)D_SelectedImage:(D_ImagePickerModel *)imageModel;

/**
 反选代理

 @param imageModel image的model
 */
- (void)D_DeSelectImage:(D_ImagePickerModel *)imageModel;

/**
  选中完成代理

 @param selectArray 选中数据
 */
- (void)D_SelectFinish:(NSMutableArray<D_ImagePickerModel *> *)selectArray;

@end

@interface D_imagePickerView : UIView

@property (nonatomic, copy)     handler                         handler;
@property (nonatomic, weak)   id<D_imagePickerViewDelegate>     delegate;//图片选择的代理（正选，反选）



/**
 初始化View

 @param frame frame
 @param maxCount 可选数量最大值
 @return view
 */
- (instancetype)initWithFrame:(CGRect)frame maxCount:(NSInteger)maxCount;
@end

NS_ASSUME_NONNULL_END
