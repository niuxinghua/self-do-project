//
//  XJHLandViewController.h
//  caxjh
//
//  Created by niuxinghua on 2018/1/19.
//  Copyright © 2018年 Yingchao Zou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenGLView20.h"
#import "XJHBaseViewController.h"
#import "DBSlider.h"
@interface XJHLandViewController : XJHBaseViewController
@property (weak, nonatomic) UIScrollView *backscrollView;
@property (weak, nonatomic) OpenGLView20 *glview;
@property (strong, nonatomic) UIButton *halfScreenButton;
@property (weak, nonatomic) UIButton *resumeButton;
@property (weak, nonatomic) DBSlider *slider;
@property (weak, nonatomic) UILabel *leftLable;
@end
