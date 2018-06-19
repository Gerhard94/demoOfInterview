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

@interface ViewController (){
    CGRect oldFrame;
}


@property (weak, nonatomic) IBOutlet UISlider *AlphaSlider;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (weak, nonatomic) IBOutlet UIView *backImage;

@property (nonatomic, strong) NSMutableArray *photoArray;

@property (nonatomic, strong) UIImageView *selectedImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _photoArray = [NSMutableArray arrayWithCapacity:0];
    
    // Do any additional setup after loading the view, typically from a nib.
//    [_backImage showBigImageInWindow];
}

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

- (IBAction)deletePhoto:(id)sender {
    UIImageView *imageV = [[UIImageView alloc] init];
    
    NSLog(@"%@",imageV.selectedView);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
