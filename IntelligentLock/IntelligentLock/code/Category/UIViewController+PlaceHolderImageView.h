//
//  UIViewController+PlaceHolderImageView.h
//  caxjh
//
//  Created by niuxinghua on 2017/9/12.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
@interface UIViewController (PlaceHolderImageView)
@property (nonatomic,strong) UIImageView *placeImageView;
-(void)shownormalEmptyImageView;
-(void)hidePlaceHolderImageView;
-(void)showEmptyImageViewAtY:(CGFloat)y;
@end
