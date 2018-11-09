//
//  D_imagePickerCollectionCell.m
//  ImagePicker
//
//  Created by 丁鹏飞 on 2018/10/30.
//  Copyright © 2018 丁鹏飞. All rights reserved.
//

#import "D_imagePickerCollectionCell.h"

@implementation D_imagePickerCollectionCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.image = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.image.contentMode = UIViewContentModeScaleAspectFill;
        self.image.clipsToBounds = YES;
        [self.contentView addSubview:self.image];
        self.selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.selectBtn setBackgroundImage:[UIImage imageNamed:@"btn_unselected"] forState:UIControlStateNormal];
        [self.selectBtn setBackgroundImage:[UIImage imageNamed:@"btn_selected"] forState:UIControlStateSelected];
        [self.selectBtn addTarget:self action:@selector(selectBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.selectBtn];
    }
    return self;
}

- (void)selectBtnClick
{
    if (self.delegate && [_delegate respondsToSelector:@selector(selectBtnClicked:)]) {
        self.selectBtn.selected = !self.selectBtn.selected;
        [_delegate selectBtnClicked:self.model];
    }
}

- (void)configCell:(D_ImagePickerModel *)model
{
    self.model = model;
    self.image.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    self.image.image = self.model.image;
    
    self.selectBtn.frame = CGRectMake(CGRectGetWidth(self.frame)-30, 4, 20, 20);
    self.selectBtn.selected = self.model.selected;
}
@end
