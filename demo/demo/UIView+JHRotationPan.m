//
//  UIView+JHRotationPan.m
//  demo
//
//  Created by Gerhard Z on 2018/6/17.
//  Copyright © 2018年 lakers JH. All rights reserved.
//

#import "UIView+JHRotationPan.h"
@interface UIView ()

@end

@implementation UIView (JHRotationPan)
#pragma mark - 处理所有手势
// 正确姿势
- (void) addGestureRecognizerToView:(UIView *)view
{
    // 根据需求选择要添加的手势
    // 旋转手势
    UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateView:)];
    [view addGestureRecognizer:rotationGesture];
    
    // 缩放手势
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    [view addGestureRecognizer:pinchGesture];
    
    // 移动手势
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [view addGestureRecognizer:panGesture];
}

#pragma mark 处理旋转
- (void) rotateView:(UIRotationGestureRecognizer *)rotationGesture
{
    UIView *view = rotationGesture.view;
    if (rotationGesture.state == UIGestureRecognizerStateBegan || rotationGesture.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformRotate(view.transform, rotationGesture.rotation);
        [rotationGesture setRotation:0];
        //log下查看view.transform是怎么处理原理
        
    }
}

- (void) pinchView:(UIPinchGestureRecognizer *)pinchGesture
{
    
    UIView *view = pinchGesture.view;
    
    if (pinchGesture.state == UIGestureRecognizerStateBegan || pinchGesture.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, pinchGesture.scale, pinchGesture.scale);
        if (_backImage.frame.size.width <= oldFrame.size.width ) {
            [UIView beginAnimations:nil context:nil]; // 开始动画
            [UIView setAnimationDuration:0.5f]; // 动画时长
            /**
             *  固定一倍
             */
            view.transform = CGAffineTransformMake(1, 0, 0, 1, 0, 0);
            [UIView commitAnimations]; // 提交动画
        }
        if (_backImage.frame.size.width > 3 * oldFrame.size.width) {
            [UIView beginAnimations:nil context:nil]; // 开始动画
            [UIView setAnimationDuration:0.5f]; // 动画时长
            /**
             *  固定三倍
             */
            view.transform = CGAffineTransformMake(3, 0, 0, 3, 0, 0);
            [UIView commitAnimations]; // 提交动画
        }
        NSLog(@"%@",NSStringFromCGAffineTransform(view.transform)) ;
        
        pinchGesture.scale = 1;
    }
}

#pragma mark 处理拖拉
-(void)panView:(UIPanGestureRecognizer *)panGesture
{
    UIView *view = panGesture.view;
    if (panGesture.state == UIGestureRecognizerStateBegan || panGesture.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGesture translationInView:view.superview];
        [view setCenter:(CGPoint){view.center.x + translation.x, view.center.y + translation.y}];
        [panGesture setTranslation:CGPointZero inView:view.superview];
    }
}

@end
