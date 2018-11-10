//
//  SysSettingViewController.m
//  IntelligentLock
//
//  Created by niuxinghua on 2018/3/4.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "SysSettingViewController.h"
#import "SettingTextView.h"
#import "Masonry.h"
#import "Const.h"
#import "AboutUsViewController.h"
@interface SysSettingViewController ()
//@property (nonatomic,strong)SettingTextView *textView1;
@property (nonatomic,strong)SettingTextView *textView2;
//@property (nonatomic,strong)SettingTextView *textView3;
@end

@implementation SysSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationUI];
//    [self.view addSubview:self.textView1];
    [self.view addSubview:self.textView2];
//    [self.view addSubview:self.textView3];
    [self makeConstrians];
}
- (void)makeConstrians
{
//    [_textView1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.left.right.equalTo(self.view);
//        make.top.equalTo(self.view.mas_top).offset(10);
//        make.height.equalTo(@60);
//        
//    }];
    [_textView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self.view);
        make.height.equalTo(@60);
        make.top.equalTo(self.view.mas_top).offset(10);
        
    }];
//    [_textView3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.left.right.equalTo(self.view);
//        make.height.equalTo(@60);
//        make.top.equalTo(self.textView2.mas_bottom).offset(10);
//        
//    }];
   
    
}
- (void)setNavigationUI
{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    
    titleLabel.textColor = [UIColor whiteColor];
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    titleLabel.text = [kMultiTool getMultiLanByKey:@"syssetting"];
    
    self.navigationItem.titleView = titleLabel;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = NO;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbackimage"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem uc_backBarButtonItemWithAction:^{
        
        // self.navigationController.navigationBar.hidden = YES;
        [self.navigationController popViewControllerAnimated:NO];
        
    }];
    
}
#pragma mark UI getters

//- (SettingTextView *)textView1
//{
//    
//    if (!_textView1) {
//        _textView1 = [[SettingTextView alloc]init];
//        [_textView1 setLeftText:[kMultiTool getMultiLanByKey:@"aboutus"]];
//        _textView1.touchBlock = ^{
//            AboutUsViewController *aboutus = [[AboutUsViewController alloc]init];
//            [self.navigationController pushViewController:aboutus animated:NO];
//        };
//    }
//    
//    return _textView1;
//}
- (SettingTextView *)textView2
{
    
    if (!_textView2) {
        _textView2 = [[SettingTextView alloc]init];
        [_textView2 setLeftText:[NSString stringWithFormat:@"%@:%@",[kMultiTool getMultiLanByKey:@"currentv"],vCFBundleShortVersionStr]];
    }
    
    return _textView2;
}
//- (SettingTextView *)textView3
//{
//    
//    if (!_textView3) {
//        _textView3 = [[SettingTextView alloc]init];
//        [_textView3 setLeftText:[kMultiTool getMultiLanByKey:@"vupdate"]];
//    }
//    
//    return _textView3;
//}
@end
