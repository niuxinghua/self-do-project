//
//  AboutUsViewController.m
//  IntelligentLock
//
//  Created by niuxinghua on 2018/3/4.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "AboutUsViewController.h"
#import "LoginModel.h"
@interface AboutUsViewController ()

@property (nonatomic,strong)UIWebView *webView;

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
    }];
    [self getData];
    [self setNavigationUI];
}


- (void)getData
{
    //about us
    ///OkGo.get(getResources().getString(R.string.APP_URL)).params("app", "userapp")
    //.params("token", userInfo.token)
    //.params("act", "aboutus").cacheKey("aboutus")
    NSDictionary *logindic =
    [[NSUserDefaults standardUserDefaults] objectForKey:@"loginmodel"];
    
    LoginModel *loginModel = [LoginModel yy_modelWithJSON:logindic];
    NSDictionary *dic = @{@"app":@"userapp",@"token":loginModel.retval.token,@"act":@"aboutus"};
    [PPNetworkHelper GET:kBaseUrl parameters:dic success:^(id responseObject) {
        NSDictionary *dic = [responseObject objectForKey:@"retval"];
        NSString *articleId = [dic objectForKey:@"id"];
        if (articleId) {
            [self loadHtmlWithId:articleId];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)loadHtmlWithId:(NSString *)htmlId
{

//    OkGo.get(getResources().getString(R.string.APP_URL)).params("app", "userapp")
//    .params("token", userInfo.token).params("id", id)
//    .params("act", "articledetail").cacheKey("articledetail").execute(new JsonCallback<LibResponse<ArticleResult>>() {
    NSDictionary *logindic =
    [[NSUserDefaults standardUserDefaults] objectForKey:@"loginmodel"];
    
    LoginModel *loginModel = [LoginModel yy_modelWithJSON:logindic];
    NSDictionary *dic = @{@"app":@"userapp",@"token":loginModel.retval.token,@"act":@"articledetail",@"id":htmlId};
    [PPNetworkHelper GET:kBaseUrl parameters:dic success:^(id responseObject) {
        NSDictionary *dic = [responseObject objectForKey:@"retval"];
        [_webView loadHTMLString:[dic objectForKey:@"content"] baseURL:nil];
    } failure:^(NSError *error) {
        
    }];
    
    
    
}
- (void)setNavigationUI
{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    
    titleLabel.textColor = [UIColor whiteColor];
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    titleLabel.text = [kMultiTool getMultiLanByKey:@"guanyu"];
    
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
