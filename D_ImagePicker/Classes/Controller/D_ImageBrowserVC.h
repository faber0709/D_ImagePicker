//
//  D_ImageBrowserVC.h
//  ImagePicker
//
//  Created by 丁鹏飞 on 2018/11/1.
//  Copyright © 2018 丁鹏飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "D_ImagePickerModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^imageBrowerSelect)(void);

@protocol imageBrowerSelectDelegate <NSObject>
//z选中代理
- (void)imageBrowerSelect:(D_ImagePickerModel *)model;

@end


@interface D_ImageBrowserVC : UIViewController

@property (nonatomic, weak)id<imageBrowerSelectDelegate>    delagete;

@property (nonatomic, copy)imageBrowerSelect                imageBrowerSelectBlock;

- (instancetype)initWithDataSources:(NSMutableArray<D_ImagePickerModel *>*)dataSources maxCoumt:(NSInteger)maxCoumt index:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
