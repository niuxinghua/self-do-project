//
//  MainTabBarViewController.m
//  IntelligentLock
//
//  Created by niuxinghua on 2018/1/26.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "MainTabBarViewController.h"

@interface MainTabBarViewController ()<CYTabBarDelegate>
@property (nonatomic,assign)NSInteger index;
@end

@implementation MainTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabbar.delegate = self;
}

#pragma mark - CYTabBarDelegate
//中间按钮点击
- (void)tabbar:(CYTabBar *)tabbar clickForCenterButton:(CYCenterButton *)centerButton{
    
   [[NSNotificationCenter defaultCenter] postNotificationName:@"didtapplus" object:@(_index)];
    
    
}
//是否允许切换
- (BOOL)tabBar:(CYTabBar *)tabBar willSelectIndex:(NSInteger)index{
    //NSLog(@"将要切换到---> %ld",index);
    _index = index;
    if (index==2) {
        [self setDefaultMessageBarIcon];
    }
    return YES;
}
//通知切换的下标
- (void)tabBar:(CYTabBar *)tabBar didSelectIndex:(NSInteger)index{
   // NSLog(@"切换到---> %ld",index);
    
}


@end
