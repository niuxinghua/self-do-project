//
//  UserContentViewController.m
//  IntelligentLock
//
//  Created by niuxinghua on 2018/3/20.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "UserContentViewController.h"
#import "UIBarButtonItem+UC.h"
#import "LoginModel.h"
#import "Const.h"
@interface UserContentViewController ()
@property (nonatomic,strong)UIWebView *webView;
@end

@implementation UserContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationUI];
    _webView = [[UIWebView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:_webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
    }];
    [self getData];
    
}
- (void)getData
{
//    OkGo.get(getResources().getString(R.stg(R.stg(R.string.APP_URL)).params("app", "userapp").params("en",MainAppclation.isZh)
//                                      .params("act", "eula")
    NSDictionary *dic = @{@"app":@"userapp",@"act":@"eula"};
    [PPNetworkHelper GET:kBaseUrl parameters:dic success:^(id responseObject) {
        NSDictionary *ret = [responseObject objectForKey:@"retval"];
        if ([ret objectForKey:@"content"]) {
            [_webView loadHTMLString:[ret objectForKey:@"content"] baseURL:nil];
        }
        
    } failure:^(NSError *error) {
        
    }];
}


- (void)setNavigationUI
{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    
    titleLabel.textColor = [UIColor whiteColor];
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    titleLabel.text = [kMultiTool getMultiLanByKey:@"yonghuxieyi"];
    
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
