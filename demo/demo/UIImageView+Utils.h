//
//  UIImageView+Utils.h
//  demo
//
//  Created by Gerhard Z on 2018/6/19.
//  Copyright © 2018年 lakers JH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
@interface UIImageView (Utils) <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIImageView *selectedView;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UISlider *slider;

- (void)showBigImageInWindow:(UIView *)backgroundView;

@end
