//
//  D_imagePickerView.m
//  ImagePicker
//
//  Created by 丁鹏飞 on 2018/10/30.
//  Copyright © 2018 丁鹏飞. All rights reserved.
//

#import "D_imagePickerView.h"
#import "D_imagePickerCollectionCell.h"
#import "D_Macros.h"
#import "D_ImageBrowserVC.h"


static NSInteger topSpace = 0;
static NSInteger bottomSpace = 0;
static NSInteger leftSpace = 0;
static NSInteger rightSpace = 0;

static NSInteger bottomViewHeight = 50;

@interface D_imagePickerView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,D_imagePickerCollectionCellDelegate,imageBrowerSelectDelegate>

@property (nonatomic, strong)   NSMutableArray<D_ImagePickerModel *>   *dataSources;
@property (nonatomic, strong)   NSMutableArray<D_ImagePickerModel *>   *selectPhotos;
@property (nonatomic, strong)   UICollectionView            *collectionView;
@property (nonatomic, strong)   UIButton                    *finishBtn;
@property (nonatomic, assign)   NSInteger                   maxCount;

@end

@implementation D_imagePickerView


- (instancetype)initWithFrame:(CGRect)frame maxCount:(NSInteger)maxCount
{
    self = [super initWithFrame:frame];
    if (self) {
        self.maxCount = maxCount;
        [self configUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0.1;
    layout.sectionInset = UIEdgeInsetsMake(topSpace,leftSpace,bottomSpace,rightSpace);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-bottomViewHeight) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsHorizontalScrollIndicator = false;
    [self.collectionView registerClass:[D_imagePickerCollectionCell class] forCellWithReuseIdentifier:@"D_imagePickerCollectionCell"];
    [self addSubview:self.collectionView];
    
    //选择按钮
    self.finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.finishBtn.frame = CGRectMake(self.frame.size.width - 100, CGRectGetMaxY(self.collectionView.frame)+10, 80, 30);
    self.finishBtn.layer.cornerRadius = 3;
    self.finishBtn.backgroundColor = [UIColor colorWithRed:29.0/255.0 green:161.0/255.0 blue:242.0/255.0 alpha:1];
    [self.finishBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.finishBtn addTarget:self action:@selector(selectFinish) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.finishBtn];
    
    //数据源初始化
    self.dataSources = [NSMutableArray array];
    [self loadData];
    self.selectPhotos = [NSMutableArray array];
}


#pragma mark -- 数据
- (void)loadData
{
    [self.dataSources removeAllObjects];
    NSMutableArray *array  = [NSMutableArray arrayWithArray:[[D_photoTool sharePhotoTool] getAllAssetInPhotoAblumWithAscending:YES]];
    for (PHAsset* assect in array) {
        D_ImagePickerModel *model = [[D_ImagePickerModel alloc] init];
        model.asset = assect;
        [self.dataSources addObject:model];
    }
    [self.collectionView reloadData];
}


- (void)getImageWithAsset:(PHAsset *)asset completion:(void (^)(UIImage *image))completion
{
    CGSize size = [self getSizeWithAsset:asset];
    size.width  *= 2;
    size.height *= 2;
    [[D_photoTool sharePhotoTool] requestImageForAsset:asset size:size resizeMode:PHImageRequestOptionsResizeModeFast completion:completion];
}


- (CGSize)getSizeWithAsset:(PHAsset *)asset
{
    CGFloat width  = (CGFloat)asset.pixelWidth;
    CGFloat height = (CGFloat)asset.pixelHeight;
    CGFloat scale = width/height;
    
    return CGSizeMake(self.collectionView.frame.size.height*scale, self.collectionView.frame.size.height);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark --- 私有方法 ---
- (void)selectFinish
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(D_SelectFinish:)]) {
        [_delegate D_SelectFinish:self.selectPhotos];
    }
    if (self.handler) {
        self.handler(self.selectPhotos);
    }
    [self removeFromSuperview];
}

/**
  *  获取父视图的控制器
  *
  *  @return 父视图的控制器
  */
- (UIViewController *)viewController
{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}


#pragma mark --- collectionViewDelegate ---
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    D_imagePickerCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"D_imagePickerCollectionCell" forIndexPath:indexPath];
    cell.delegate = self;
    D_ImagePickerModel *model = self.dataSources[indexPath.row];
    //有图片就不用再去重复从PHAsset获取了
    if (model.image) {
        [cell configCell:model];
    }else{
        PHAsset *asset = model.asset;
        TOWeak(weakself);
        [self getImageWithAsset:asset completion:^(UIImage *image) {
            model.image = image;
            model.ImageTag = indexPath.row;
            [weakself.dataSources replaceObjectAtIndex:indexPath.row withObject:model];
            [cell configCell:model];
        }];
    }
    return cell;
}


//设置item 的size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    D_ImagePickerModel *model = self.dataSources[indexPath.row];
    PHAsset *asset = model.asset;
    CGSize size = [self getSizeWithAsset:asset];
    //超长图宽度会不够
    if (size.width<40) {
        size.width = 40;
    }
    return size;
}


- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSources.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *vc = [self viewController];
    //预览
    D_ImageBrowserVC *imageBrowser = [[D_ImageBrowserVC alloc] initWithDataSources:self.dataSources maxCoumt:self.maxCount-self.selectPhotos.count index:indexPath.row];
    imageBrowser.delagete = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:imageBrowser];
    nav.title = @"照片";
    [vc presentViewController:nav animated:YES completion:nil];
}


#pragma mark --- D_ImageBrowserVC delegate ---
- (void)imageBrowerSelect:(D_ImagePickerModel *)model
{
    [self dataModelHandle:model];
    [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:model.ImageTag inSection:0]]];
}


#pragma mark ---  D_imagePickerCollectionCell  ---
- (void)selectBtnClicked:(D_ImagePickerModel *)model
{
    model.selected = !model.selected;
    [self dataModelHandle:model];
}

- (void)dataModelHandle:(D_ImagePickerModel *)model;
{
    if (model.selected) {//选中
        //没有超过最大可选数量
        if (self.maxCount>0 && self.selectPhotos.count+1 <= self.maxCount) {
            //数据源修改
            [self.dataSources replaceObjectAtIndex:model.ImageTag withObject:model];
            //直接添加
            [self.selectPhotos addObject:model];
            //选中代理
            if (self.delegate && [self.delegate respondsToSelector:@selector(D_SelectedImage:)]) {
                [_delegate D_SelectedImage:model];
            }
        }else{
            model.selected = NO;
            [self.dataSources replaceObjectAtIndex:model.ImageTag withObject:model];
            [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:model.ImageTag inSection:0]]];
        }
        
    }else{//取消选中
        
        for (D_ImagePickerModel *selectModel in self.selectPhotos) {
            if (model.ImageTag == selectModel.ImageTag) {
                [self.dataSources replaceObjectAtIndex:model.ImageTag withObject:model];
                [self.selectPhotos removeObject:selectModel];
                //取消选中代理
                if (self.delegate && [self.delegate respondsToSelector:@selector(D_DeSelectImage:)]) {
                    [_delegate D_DeSelectImage:model];
                }
                break;
            }
        }
    }
}

@end
