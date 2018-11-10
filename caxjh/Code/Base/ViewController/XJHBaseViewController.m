//
//  XJHBaseViewController.m
//  caxjh
//
//  Created by Yingchao Zou on 30/08/2017.
//  Copyright © 2017 Yingchao Zou. All rights reserved.
//

#import "XJHBaseViewController.h"

@interface XJHBaseViewController (){
    
    id<UIGestureRecognizerDelegate> _delegate;
}

@end

@implementation XJHBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;

  
   
    
  
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.navigationController.viewControllers.count > 1) {
        // 记录系统返回手势的代理
        _delegate = self.navigationController.interactivePopGestureRecognizer.delegate;
        // 设置系统返回手势的代理为当前控制器
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}


- (BOOL)shouldAutorotate
{    // 不允许进行旋转
    return NO;
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{    // 返回默认情况
    return UIInterfaceOrientationMaskPortrait ;
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{    // 返回默认情况
    return UIInterfaceOrientationPortrait;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
