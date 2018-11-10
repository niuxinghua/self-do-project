//
//  BaseViewController.m
//  IntelligentLock
//
//  Created by niuxinghua on 2018/2/1.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "BaseViewController.h"
#import "UIViewController+StatusBar.h"
//#import "ZYKeyboardUtil.h"
#import "Const.h"
@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setStatusBarBackgroundColor:[UIColor colorWithRed:22 / 255.0
                                                    green:24 / 255.0
                                                     blue:36 / 255.0
                                                    alpha:0.5]];
//  UIGestureRecognizer *rec =
//      [[UITapGestureRecognizer alloc] initWithTarget:self
//                                              action:@selector(tapgesture)];
//  [self.view addGestureRecognizer:rec];
}
- (UIStatusBarStyle)preferredStatusBarStyle {
  return UIStatusBarStyleLightContent;
}
- (void)setStatusBarBackgroundColor:(UIColor *)color {

  UIView *statusBar = [[[UIApplication sharedApplication]
      valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
  if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
    statusBar.backgroundColor = color;
  }
}

- (void)tapgesture {
  if ([self.view endEditing:YES]) {
  }
}
- (void)setNavigationUI:(NSString *)title
{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    
    titleLabel.textColor = [UIColor whiteColor];
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    titleLabel.text = [kMultiTool getMultiLanByKey:title];
    
    self.navigationItem.titleView = titleLabel;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = NO;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbackimage"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem uc_backBarButtonItemWithAction:^{
        
        // self.navigationController.navigationBar.hidden = YES;
        [self.navigationController popViewControllerAnimated:NO];
        
    }];
    
}
@end
