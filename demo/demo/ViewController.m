//
//  ViewController.m
//  demo
//
//  Created by Gerhard Z on 2018/6/15.
//  Copyright © 2018年 lakers JH. All rights reserved.
//

#import "ViewController.h"
#import "SuPhotoPicker/SuPhotoPicker.h"
#import "UIImageView+Utils.h"
#import "PreViewCell.h"
#import "Masonry.h"
@interface ViewController () <UICollectionViewDelegate,UICollectionViewDataSource>{
    CGRect oldFrame;
}


@property (weak, nonatomic) IBOutlet UISlider *AlphaSlider;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (weak, nonatomic) IBOutlet UIView *backImage;

@property (nonatomic, strong) NSMutableArray *photoArray;

@property (nonatomic, strong) UIImageView *selectedImageView;

@property (nonatomic, strong) NSMutableArray *addPhotoArray;

@property (weak, nonatomic) IBOutlet UICollectionView *preview;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _addPhotoArray = [NSMutableArray arrayWithCapacity:10];
    //设置图片
    _photoArray = [NSMutableArray arrayWithCapacity:10];
    for (int i = 0; i < 10; ++i) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"curtain_%d",i]];
        [_photoArray addObject:image];
    }
    
    [self setupPreView];
}


/**
 设置预览图
 */
- (void)setupPreView {
    //单元格尺寸
    CGFloat itemSizeWH = 76;
    CGFloat margin = 10;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(itemSizeWH, itemSizeWH);
    
    //滑动方向
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = margin;
    
    self.preview.collectionViewLayout = layout;
    self.preview.delegate = self;
    self.preview.dataSource = self;
    self.preview.scrollsToTop = NO;
    self.preview.showsVerticalScrollIndicator = NO;
    self.preview.showsHorizontalScrollIndicator = NO;
    
    [self.preview registerNib:[UINib nibWithNibName:NSStringFromClass([PreViewCell class])
                                             bundle:nil]
   forCellWithReuseIdentifier:@"ID"];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _photoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PreViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ID" forIndexPath:indexPath];
    cell.photoView.image = _photoArray[indexPath.row];
    return cell;
}


/**
 监听点击事件
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UIImage *workImage = _photoArray[indexPath.row];
    UIImageView *workImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, workImage.size.width, workImage.size.height)];
    [workImageView setImage:workImage];
    [_addPhotoArray addObject:workImageView];
    [workImageView showBigImageInWindow:_backImage];
    _selectedImageView = workImageView;
}

/*
- (IBAction)addImage:(id)sender {
    __weak typeof(self) weakSelf = self;
    SuPhotoPicker *picker = [[SuPhotoPicker alloc] init];
    picker.selectedCount = 1;
    picker.preViewCount = 15;
    [picker showInSender:self handle:^(NSArray<UIImage *> *photos) {
        [weakSelf showSelectedPhotos:photos];
    }];
}

- (void)showSelectedPhotos:(NSArray *)imgs {
    UIImage *photo = imgs[0];
//        UIImageView *photoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, photo.size.width, photo.size.height)];
    UIImageView *photoView = [[UIImageView alloc] init];
    photoView.image = photo;
    [_photoArray addObject:photoView];
//    [photoView showBigImageInWindow:_backImage];
//        [_backImage addSubview:photoView];
    [_photoArray.lastObject showBigImageInWindow:_backImage];
}
 */




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
