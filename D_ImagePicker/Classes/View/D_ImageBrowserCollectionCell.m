//
//  D_ImageBrowserCollectionCell.m
//  ImagePicker
//
//  Created by 丁鹏飞 on 2018/11/1.
//  Copyright © 2018 丁鹏飞. All rights reserved.
//

#import "D_ImageBrowserCollectionCell.h"


@interface D_ImageBrowserCollectionCell ()<UIScrollViewDelegate>

@property (nonatomic, strong)UIImageView    *image;
@property (nonatomic, strong)UIScrollView   *scrollView;

@end

@implementation D_ImageBrowserCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor blackColor];
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.scrollView.backgroundColor = [UIColor blackColor];
        self.scrollView.delegate = self;
        self.scrollView.maximumZoomScale = 3.0;
        self.scrollView.minimumZoomScale = 1.0;
        [self.contentView addSubview:self.scrollView];
        
        self.image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.image.contentMode = UIViewContentModeScaleAspectFit;
        self.image.userInteractionEnabled = YES;
        [self.scrollView addSubview:self.image];
        
        
        //单击手势
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        singleTap.numberOfTapsRequired = 1;
        [self.image addGestureRecognizer:singleTap];
        
        //双击缩放手势
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        [self.image addGestureRecognizer:doubleTap];
        
        [singleTap requireGestureRecognizerToFail:doubleTap];
    }
    return self;
}

#pragma mark - 图片缩放相关方法
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.image;
    
}

- (void)singleTap:(UITapGestureRecognizer *)recognizer
{
    if (self.singleTapBlock) {
        self.singleTapBlock();
    }
}

- (void)doubleTap:(UITapGestureRecognizer *)recognizer {
    if (self.scrollView.zoomScale > 1.0) {
        [self.scrollView setZoomScale:1.0 animated:YES];
    } else {
        CGPoint touchPoint = [recognizer locationInView:self.image];
        CGFloat scale = self.scrollView.maximumZoomScale;
        CGRect newRect = [self getRectWithScale:scale andCenter:touchPoint];
        [_scrollView zoomToRect:newRect animated:YES];
    }
}

- (CGRect)getRectWithScale:(CGFloat)scale andCenter:(CGPoint)center{
    CGRect newRect = CGRectZero;
    newRect.size.width =  self.scrollView.frame.size.width/scale;
    newRect.size.height = self.scrollView.frame.size.height/scale;
    newRect.origin.x = center.x - newRect.size.width * 0.5;
    newRect.origin.y = center.y - newRect.size.height * 0.5;
    
    return newRect;
}


- (void)configCell:(D_ImagePickerModel *)model
{
    [self.scrollView setZoomScale:1.0 animated:YES];
    self.image.image = model.image;
}

@end
