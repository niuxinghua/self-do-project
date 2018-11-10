//
//  DestroyViewController.m
//  IntelligentLock
//
//  Created by niuxinghua on 2018/3/15.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "DestroyViewController.h"
#import "UIBarButtonItem+UC.h"
#import "LoginModel.h"
#import "PPNetworkHelper.h"
#import "Const.h"
#import "Masonry.h"
@interface DestroyViewController ()
@property(nonatomic, strong) RegisterItemView *introView;

@property(nonatomic, strong) RegisterItemView *enterTeleView;

@property(nonatomic, strong) RegisterItemView *enterVerify;

@property(nonatomic, strong) UIButton *registerButton;
@end

@implementation DestroyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationUI];
    
    [self.view addSubview:self.introView];
   // [self.view addSubview:self.enterTeleView];
    [self.view addSubview:self.enterVerify];
    [self.view addSubview:self.registerButton];
    [self makeConstrains];
    
}
- (void)makeConstrains
{
  
        [self.introView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.equalTo(self.view);
            
            make.height.equalTo(@60);
            
            make.top.equalTo(self.view);
        }];
//        [self.enterTeleView mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.left.right.equalTo(self.view);
//
//            make.height.equalTo(@60);
//
//            make.top.equalTo(self.introView.mas_bottom);
//        }];
        [self.enterVerify mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.equalTo(self.view);
            
            make.height.equalTo(@60);
            
            make.top.equalTo(self.introView.mas_bottom);
        }];
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self.view);
        
        make.height.equalTo(@40);
        
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
    }];
    
}
- (void)destroy{
    
    
    NSDictionary *logindic =
    [[NSUserDefaults standardUserDefaults] objectForKey:@"loginmodel"];
   LoginModel *_loginModel = [LoginModel yy_modelWithJSON:logindic];
   // _headerView.loginModel = _loginModel;
    if (![_enterVerify getText].length) {
        [self.view makeToast:[kMultiTool getMultiLanByKey:@"qingshuuyanzhengma"]];
        return;
    }
//    NSRange addRange = [_enterTeleView.rightLable.text rangeOfString:@"+"];
//    NSMutableString *str =
//    [[NSMutableString alloc] initWithString:_enterTeleView.rightLable.text];
//    [str deleteCharactersInRange:addRange];

    NSDictionary *dic = @{
                          @"uname":_loginModel.retval.n,
                          @"a" : kLoginModel.retval.area_code,
                          @"y" : [[_introView getText] containsString:@"@"]?@"2":@"1",
                          @"token":_loginModel.retval.token,
                          @"app" : @"userloginapp",
                          @"act" : @"setzcheck",
                          @"platform":@"iOS",
                          @"model":@"",
                          @"code":[_enterVerify getText]
                          };
    
    
    [PPNetworkHelper GET:kBaseUrl parameters:dic success:^(id responseObject) {
        if ([[responseObject valueForKey:@"done"] boolValue]) {
            [self logout];
        }else{
            [kWINDOW makeToast:[responseObject objectForKey:@"msg"]];
        }
        
        
        
    } failure:^(NSError *error) {
       // [kWINDOW makeToast:error.description];
    }];
    
}

- (void)logout{
    
    
    NSDictionary *logindic =
    [[NSUserDefaults standardUserDefaults] objectForKey:@"loginmodel"];
    LoginModel *_loginModel = [LoginModel yy_modelWithJSON:logindic];
    // _headerView.loginModel = _loginModel;
    if (![_enterVerify getText].length) {
        [self.view makeToast:[kMultiTool getMultiLanByKey:@"qingshuuyanzhengma"]];

        return;
    }
    NSDictionary *dic = @{
                          
                          @"token":_loginModel.retval.token,
                          @"app" : @"userloginapp",
                          @"act" : @"dropuser",
                          @"platform":@"iOS",
                          @"model":@"",
                         
                          };
    
    
    [PPNetworkHelper GET:kBaseUrl parameters:dic success:^(id responseObject) {
        if ([[responseObject valueForKey:@"done"] boolValue]) {
            [kWINDOW makeToast:[responseObject objectForKey:@"msg"]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"logout" object:nil];
            });
            
        }else{
            [kWINDOW makeToast:[responseObject objectForKey:@"msg"]];
        }
        
        
        
    } failure:^(NSError *error) {
      //  [kWINDOW makeToast:error.description];
    }];
    
}


- (void)setNavigationUI
{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    
    titleLabel.textColor = [UIColor whiteColor];
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    titleLabel.text = [kMultiTool getMultiLanByKey:@"destroyaccount"];
    
    self.navigationItem.titleView = titleLabel;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = NO;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbackimage"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem uc_backBarButtonItemWithAction:^{
        
        // self.navigationController.navigationBar.hidden = YES;
        [self.navigationController popViewControllerAnimated:NO];
        
    }];
    
}

#pragma mark - UI getter
- (RegisterItemView *)introView {
    if (!_introView) {
        _introView = [[RegisterItemView alloc] init];
    }
    [_introView setLeftIcon:[UIImage imageNamed:@"registerperson"]
              textFeildText:[kMultiTool getMultiLanByKey:@"zhanghaotishi"]
                 rightLable:@""
           textFeildCanEdit:YES];
    NSDictionary *logindic =
    [[NSUserDefaults standardUserDefaults] objectForKey:@"loginmodel"];
    LoginModel *_loginModel = [LoginModel yy_modelWithJSON:logindic];
    _introView.textFeild.text = _loginModel.retval.n;
    return _introView;
}

- (RegisterItemView *)enterTeleView {
    if (!_enterTeleView) {
        _enterTeleView = [[RegisterItemView alloc] init];
    }
    [_enterTeleView setLeftIcon:[UIImage imageNamed:@"registerarea"]
                  textFeildText:[kMultiTool getMultiLanByKey:@"zhongguo"]
                     rightLable:@"+86"
               textFeildCanEdit:NO];
    
    __weak RegisterViewController *weakSelf = self;
    
    __weak RegisterItemView *weakEnterTeleView = _enterTeleView;
    
    _enterTeleView.didtapViewBlcok = ^{
        XWCountryCodeController *CountryCodeVC =
        [[XWCountryCodeController alloc] init];
        [CountryCodeVC
         toReturnCountryCode:^(NSString *countryCodeStr, NSString *countryName) {
             //在此处实现最终选择后的界面处理
             //[self.countryCodeLB setText:countryCodeStr];
             [weakEnterTeleView setLeftIcon:[UIImage imageNamed:@"registerarea"]
                              textFeildText:countryName
                                 rightLable:[NSString stringWithFormat:@"+%@",countryCodeStr]
                           textFeildCanEdit:YES];
         }];
        [weakSelf presentViewController:CountryCodeVC animated:YES completion:nil];
        
    };
    return _enterTeleView;
}
- (RegisterItemView *)enterVerify {
    if (!_enterVerify) {
        _enterVerify = [[RegisterItemView alloc] init];
    }
    [_enterVerify setLeftIcon:[UIImage imageNamed:@"registerverify"]
                textFeildText:[kMultiTool getMultiLanByKey:@"yanzhengma"]                   rightLable:@""
             textFeildCanEdit:YES];
    [_enterVerify showButton:YES];
    
    __weak DestroyViewController *weakSelf = self;
    
    _enterVerify.getVerifyblock = ^{
        
        [weakSelf getVerifyCode];
        
    };
    
    return _enterVerify;
}
- (UIButton *)registerButton {
    if (!_registerButton) {
        _registerButton = [[UIButton alloc] init];
        [_registerButton setTitle:[kMultiTool getMultiLanByKey:@"destroyaccount"] forState:UIControlStateNormal];
        [_registerButton setTitleColor:[UIColor whiteColor]
                              forState:UIControlStateNormal];
        [_registerButton setBackgroundImage:[UIImage imageNamed:@"navbackimage"]
                                   forState:UIControlStateNormal];
        [_registerButton addTarget:self
                            action:@selector(destroy)
                  forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _registerButton;
}
#pragma mark private methods

- (void)getVerifyCode {
    
    if (![_introView getText] || ![_introView getText].length) {
        [kWINDOW makeToast:[kMultiTool getMultiLanByKey:@"shoujihaobudui"]];
        return;
    }
    [kWINDOW makeToastActivity:CSToastPositionCenter];

//    NSRange addRange = [_enterTeleView.rightLable.text rangeOfString:@"+"];
//    NSMutableString *str =
//    [[NSMutableString alloc] initWithString:_enterTeleView.rightLable.text];
//    [str deleteCharactersInRange:addRange];
    if(!kLoginModel.retval.area_code.length)
    {
        [kWINDOW makeToast:[kMultiTool getMultiLanByKey:@"areaerror"]];
        return;
    }
    NSDictionary *dic = @{
                          @"t" : [_introView getText],
                          @"a" : kLoginModel.retval.area_code,
                         @"y" : [[_introView getText] containsString:@"@"]?@"2":@"1",
                          @"app" : @"userapp",
                          @"act" : @"authcode",
                          @"type":@"setz"
                          };
    
    [PPNetworkHelper GET:kBaseUrl
              parameters:dic
                 success:^(id responseObject) {
                     [kWINDOW hideToastActivity];

                    
                     if (![[responseObject objectForKey:@"done"] intValue]) {
                         //[_enterVerify stopCount];
                          [self.view makeToast:[responseObject objectForKey:@"msg"]];
                     }else{
                         [_enterVerify.getVerify startCountDown];
                     }
                     
                 }
                 failure:^(NSError *error) {
                      [kWINDOW hideToastActivity];
                   //  [self.view makeToast:error.description];
                     [_enterVerify stopCount];
                 }];
}

@end
