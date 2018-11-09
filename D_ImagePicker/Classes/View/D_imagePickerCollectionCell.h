//
//  D_imagePickerCollectionCell.h
//  ImagePicker
//
//  Created by 丁鹏飞 on 2018/10/30.
//  Copyright © 2018 丁鹏飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "D_ImagePickerModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol D_imagePickerCollectionCellDelegate <NSObject>

- (void)selectBtnClicked:(D_ImagePickerModel *)model;

@end

@interface D_imagePickerCollectionCell : UICollectionViewCell

@property (nonatomic, weak) id<D_imagePickerCollectionCellDelegate>delegate;

@property (nonatomic, strong)UIImageView        *image;
@property (nonatomic, strong)UIButton           *selectBtn;
@property (nonatomic, strong)D_ImagePickerModel *model;


- (void)configCell:(D_ImagePickerModel *)model;

@end

NS_ASSUME_NONNULL_END
