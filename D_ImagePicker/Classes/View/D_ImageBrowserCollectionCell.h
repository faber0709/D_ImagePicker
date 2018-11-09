//
//  D_ImageBrowserCollectionCell.h
//  ImagePicker
//
//  Created by 丁鹏飞 on 2018/11/1.
//  Copyright © 2018 丁鹏飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "D_ImagePickerModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^singleTapBlock)(void);

@interface D_ImageBrowserCollectionCell : UICollectionViewCell

@property (nonatomic, copy)singleTapBlock   singleTapBlock;

- (void)configCell:(D_ImagePickerModel *)model;

@end

NS_ASSUME_NONNULL_END
