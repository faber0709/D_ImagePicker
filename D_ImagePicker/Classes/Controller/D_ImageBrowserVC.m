//
//  D_ImageBrowserVC.m
//  ImagePicker
//
//  Created by 丁鹏飞 on 2018/11/1.
//  Copyright © 2018 丁鹏飞. All rights reserved.
//

#import "D_ImageBrowserVC.h"
#import "D_ImageBrowserCollectionCell.h"

#import "D_Macros.h"
#import "D_photoTool.h"


@interface D_ImageBrowserVC ()<UICollectionViewDelegate,UICollectionViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong)   UICollectionView                       *collectionView;
@property (nonatomic, strong)   NSMutableArray<D_ImagePickerModel *>   *dataSources;
@property (nonatomic, assign)   NSInteger                               maxCount;
@property (nonatomic, assign)   NSInteger                               selectIndex;
@property (nonatomic, strong)   UIButton                               *navRightBtn;

@end

@implementation D_ImageBrowserVC

- (instancetype)initWithDataSources:(NSMutableArray<D_ImagePickerModel *>*)dataSources maxCoumt:(NSInteger)maxCoumt index:(NSInteger)index
{
    self = [super init];
    if (self) {
        self.dataSources = [NSMutableArray array];
        self.dataSources = dataSources;
        if (maxCoumt) {
            self.maxCount = maxCoumt;
        }else{
            maxCoumt = 0;
        }
        self.selectIndex = index;
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"D_ImageBrowserVC dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    self.title = @"照片";
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:92.0/255.0 green:154.0/255.0 blue:254.0/255.0 alpha:1];
    self.edgesForExtendedLayout = UIRectEdgeTop;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = [UIColor blackColor];
    [self configNav];
    [self configUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_collectionView setContentOffset:CGPointMake(self.selectIndex*(D_SCREEN_WIDTH), 0)];
}


- (void)configNav
{
    //left nav btn
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"navBackBtn"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(BackBtnClick)];
    
    //right nav btn
    self.navRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.navRightBtn.frame = CGRectMake(0, 0, 25, 25);
    [self.navRightBtn setBackgroundImage:[UIImage imageNamed:@"btn_circle.png"] forState:UIControlStateNormal];
    [self.navRightBtn setBackgroundImage:[UIImage imageNamed:@"btn_selected.png"] forState:UIControlStateSelected];
    [self.navRightBtn addTarget:self action:@selector(navRightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_navRightBtn];
}


- (void)configUI
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(0,0,0,0);
    layout.itemSize = CGSizeMake(D_SCREEN_WIDTH, D_SCREEN_HEIGHT);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, D_SCREEN_WIDTH, D_SCREEN_HEIGHT) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = false;
    [self.collectionView registerClass:[D_ImageBrowserCollectionCell class] forCellWithReuseIdentifier:@"D_ImageBrowserCollectionCell"];
    [self.view addSubview:self.collectionView];
}


#pragma mark --- 私有方法 ---
- (void)BackBtnClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)navRightBtnClick
{
    D_ImagePickerModel *model = self.dataSources[_selectIndex];
    model.selected = !model.selected;
    
    if (model.selected) {//选中
        //超过可选数量
        if (!self.maxCount && self.maxCount <= 0) {
            model.selected = NO;
            return;
        }
        self.maxCount --;//没超过可选数量，可选数量减1
    }else{//取消选中
        self.maxCount++;//取消选中，可选数量加1
    }
    
    [self.dataSources replaceObjectAtIndex:self.selectIndex withObject:model];
    self.navRightBtn.selected = model.selected;
    if (self.delagete && [self.delagete respondsToSelector:@selector(imageBrowerSelect:)]) {
        [self.delagete imageBrowerSelect:model];
    }
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


- (void)singleTap
{
    self.navigationController.navigationBarHidden = !self.navigationController.navigationBarHidden;
    [UIApplication sharedApplication].statusBarHidden = ![UIApplication sharedApplication].statusBarHidden;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    D_ImageBrowserCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"D_ImageBrowserCollectionCell" forIndexPath:indexPath];
    
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
    
    TOWeak(weakself);
    cell.singleTapBlock = ^{
        [weakself singleTap];
    };
    return cell;
}


- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section { 
    return self.dataSources.count;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == (UIScrollView *)_collectionView) {
        //改变导航标题
        self.selectIndex = scrollView.contentOffset.x/(D_SCREEN_WIDTH);
        D_ImagePickerModel *model = self.dataSources[self.selectIndex];
        self.navRightBtn.selected = model.selected;
    }
}

@end
