//
//  UIImageView+Utils.m
//  demo
//
//  Created by Gerhard Z on 2018/6/19.
//  Copyright © 2018年 lakers JH. All rights reserved.
//

#import "UIImageView+Utils.h"
#import "Masonry.h"

@implementation UIImageView (Utils)

static CGRect oldframe;
static char *selectedKey = "selectedKey";
static char *deleteBKey = "deleteBKey";
static char *sliderKey = "slider";


- (void)showBigImageInWindow:(UIView *)backgroundView{
    //获取到添加的ImageView
    UIImageView *currentImageview = self;
    UIImage *image = currentImageview.image;

    
    oldframe = [currentImageview convertRect:currentImageview.bounds                toView:backgroundView];

    //将显示的图片添加到操作视图中
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:oldframe];
    [imageView setUserInteractionEnabled:YES];
    [imageView setImage:image];
    [backgroundView addSubview:imageView];
    
    //添加删除按钮
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [backgroundView addSubview:deleteButton];
    [deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
        make.top.equalTo(backgroundView);
        make.right.equalTo(backgroundView);
    }];
    
    self.deleteButton = deleteButton;
    [self.deleteButton addTarget:self action:@selector(deletePic) forControlEvents:UIControlEventTouchUpInside];
    
    //向imageView添加手势 缩放图片
    UIPanGestureRecognizer *pan =[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    //添加到指定视图
    [imageView addGestureRecognizer:pan];
    UIPinchGestureRecognizer *pinch =[[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchAction:)];
    [imageView addGestureRecognizer:pinch];
    UIRotationGestureRecognizer *rotation =[[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(rotationAction:)];
    [imageView addGestureRecognizer:rotation];
    pinch.delegate = self;
    rotation.delegate = self;
    
    self.selectedView = imageView;
    
//    //添加点击事件
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectView:)];
    [imageView addGestureRecognizer:tapGestureRecognizer];
    
    //动画放大所展示的ImageView
    [UIView animateWithDuration:0.4 animations:^{
        CGFloat y,width,height;
        y = ([UIScreen mainScreen].bounds.size.height - image.size.height * [UIScreen mainScreen].bounds.size.width / image.size.width) * 0.5;
        width = [UIScreen mainScreen].bounds.size.width;
        //高度 根据图片宽高比设置
        height = image.size.height * [UIScreen mainScreen].bounds.size.width / image.size.width;
        [imageView setFrame:CGRectMake(0, y, width, height)];
        //重要！ 将视图显示出来
        [backgroundView setAlpha:1];
    } completion:^(BOOL finished) {
        
    }];
    

    UISlider *slider = [[UISlider alloc] init];
    slider.value = self.selectedView.alpha;
    slider.backgroundColor = [UIColor whiteColor];
    [slider addTarget:self
               action:@selector(changeAlpha:)
     forControlEvents:UIControlEventValueChanged];
    [backgroundView addSubview:slider];
    [slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(200);
        make.centerX.equalTo(backgroundView);
        make.top.equalTo(backgroundView).offset(10);
    }];
    self.slider = slider;
}

- (void)setSelectedView:(UIImageView *)selectedView {
    objc_setAssociatedObject(self, selectedKey, selectedView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setDeleteButton:(UIButton *)deleteButton {
    objc_setAssociatedObject(self, deleteBKey, deleteButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImageView *)selectedView {
    return objc_getAssociatedObject(self, selectedKey);
}

- (UIButton *)deleteButton {
    return objc_getAssociatedObject(self, deleteBKey);
}

- (void)setSlider:(UISlider *)slider {
    objc_setAssociatedObject(self, sliderKey, slider, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UISlider *)slider {
    return objc_getAssociatedObject(self, sliderKey);
}

/**
 *
 *  @param tap 点击事件
 */
- (void)selectView:(UITapGestureRecognizer *)tap{
    UIImageView *imageView = (UIImageView *)tap.view;
    if (!imageView) {
        return ;
    }
    [imageView.superview bringSubviewToFront:imageView];
    [imageView.superview bringSubviewToFront:self.deleteButton];
    [imageView.superview bringSubviewToFront:self.slider];
    
    self.selectedView = imageView;
    self.slider.value = self.selectedView.alpha;
    
}

- (void)deletePic {
    [self.selectedView removeFromSuperview];
    [self.deleteButton removeFromSuperview];
    [self.slider removeFromSuperview];
       
}

- (void)changeAlpha:(UISlider *)slider {
    self.selectedView.alpha = slider.value;
}

//创建平移事件
-(void)panAction:(UIPanGestureRecognizer *)pan
{
    UIImageView *imageView = (UIImageView *)pan.view;
    if (!imageView) {
        return ;
    }
    //获取手势的位置
    CGPoint position =[pan translationInView:imageView];
    
    //通过stransform 进行平移交换
    imageView.transform = CGAffineTransformTranslate(imageView.transform, position.x, position.y);
    //将增量置为零
    [pan setTranslation:CGPointZero inView:imageView];
    [imageView.superview bringSubviewToFront:imageView];
    
}

//添加捏合事件
-(void)pinchAction:(UIPinchGestureRecognizer *)pinch
{
    UIImageView *imageView = (UIImageView *)pinch.view;
    if (!imageView) {
        return ;
    }
    //通过 transform(改变) 进行视图的视图的捏合
    imageView.transform = CGAffineTransformScale(imageView.transform, pinch.scale, pinch.scale);
    //设置比例 为 1
    pinch.scale = 1;
}



//旋转事件
-(void)rotationAction:(UIRotationGestureRecognizer *)rote
{
    UIImageView *imageView = (UIImageView *)rote.view;
    if (!imageView) {
        return ;
    }
    //通过transform 进行旋转变换
    imageView.transform = CGAffineTransformRotate(imageView.transform, rote.rotation);
    //将旋转角度 置为 0
    rote.rotation = 0;
}


#pragma gesture delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
