//
//  UIViewController+StatusBar.m
//  caxjh
//
//  Created by niuxinghua on 2017/8/31.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import "UIViewController+StatusBar.h"

@implementation UIViewController (StatusBar)
-(void)setStatusBarDefaultColor
{
    
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.bounds.size.width, 20)];
    statusBarView.backgroundColor = [UIColor colorWithRed:251/255.0 green:111/255.0 blue:113/255.0 alpha:1.0];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    /// 想navigation的navigationBar上添加状态栏
    if (self.navigationController) {
        [self.navigationController.navigationBar addSubview:statusBarView];
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:251/255.0 green:111/255.0 blue:113/255.0 alpha:1.0];
        [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,[UIFont fontWithName:@"Helvetica Neue" size:18.0f], NSFontAttributeName,nil]];
        
    }
    
}
@end
