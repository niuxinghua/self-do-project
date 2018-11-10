//
//  LoginViewController.m
//  IntelligentLock
//
//  Created by niuxinghua on 2018/2/1.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginTextView.h"
#import "Const.h"
#import "Masonry.h"
#import "LoginModel.h"
#import "XWCountryCodeController.h"
#import "ModifyPassWordViewController.h"
#import <Bugly/Bugly.h>
NSString *const kLoginNotification = @"kLoginNotification";

@interface LoginViewController ()


@property (nonatomic,strong)LoginTextView *introView;


@property (nonatomic,strong)LoginTextView *enterTeleView;


@property (nonatomic,strong)LoginTextView *enterPassView;

@property (nonatomic,strong)UIButton *loginButton;

@property (nonatomic,strong)UIButton *registerButton;

@property (nonatomic,strong)UIButton *forgetButton;

@end

@implementation LoginViewController


#pragma mark life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    UIImageView *bg = [[UIImageView alloc]initWithFrame:self.view.bounds];
    bg.image = [UIImage imageNamed:@"loginbg"];
    [self.view addSubview:bg];
    [self.view addSubview:self.introView];
   // [self.view addSubview:self.enterTeleView];
    [self.view addSubview:self.enterPassView];
    [self.view addSubview:self.loginButton];
    [self.view addSubview:self.registerButton];
    [self.view addSubview:self.forgetButton];
    [self makeConstrains];
    UIGestureRecognizer *rec = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:rec];
    self.navigationController.navigationBar.hidden = YES;
    NSString *tel =
    [[NSUserDefaults standardUserDefaults] objectForKey:@"loginname"];
    if (tel) {
       
            self.introView.textFeild.text=tel;
        
    }
    
}


#pragma mark methods

- (void)makeConstrains
{
    CGFloat topOffset = 280;
    if (isiPhoneX) {
        topOffset = 320;
    }
    [self.introView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view);
        
        make.top.equalTo(self.view.mas_top).offset(topOffset);
        
        make.height.equalTo(@50);
        
        make.width.equalTo(@(self.view.frame.size.width - 60));
        
    }];
    
//    [self.enterTeleView mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.centerX.equalTo(self.view);
//
//        make.top.equalTo(self.introView.mas_bottom).offset(10);
//
//        make.height.equalTo(@50);
//
//        make.width.equalTo(@(self.view.frame.size.width - 60));
//
//    }];
    
    [self.enterPassView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view);
        
        make.top.equalTo(self.introView.mas_bottom).offset(10);
        
        make.height.equalTo(@50);
        
        make.width.equalTo(@(self.view.frame.size.width - 60));
        
    }];
    [self.forgetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        
        
        make.top.equalTo(self.enterPassView.mas_bottom).offset(5);
        
        make.height.equalTo(@20);
        
        make.width.equalTo(@100);
        
        make.right.equalTo(self.view.mas_right).offset(-20);
        
    }];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        

        
        make.top.equalTo(self.forgetButton.mas_bottom).offset(30);
        
        make.height.equalTo(@40);
        
        make.width.equalTo(@100);
        
        make.left.equalTo(self.view.mas_left).offset(60);
        
    }];
    
    
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        
        
        make.top.equalTo(self.forgetButton.mas_bottom).offset(30);
        
        make.height.equalTo(@40);
        
        make.width.equalTo(@100);
        
        make.right.equalTo(self.view.mas_right).offset(-60);
        
    }];
    
    
    
}


#pragma mark UI getter

- (LoginTextView *)introView
{
    
    if (!_introView) {
        _introView = [[LoginTextView alloc]initWithFrame:CGRectZero];
        [_introView setLeftIcon:[UIImage imageNamed:@"loginintro"] textFeildText:[kMultiTool getMultiLanByKey:@"zhanghaotishi"] rightLable:@"" textFeildCanEdit:YES];
    }
    
    return _introView;
}
- (LoginTextView *)enterTeleView
{
    
    if (!_enterTeleView) {
        _enterTeleView = [[LoginTextView alloc]initWithFrame:CGRectZero];
        [_enterTeleView setLeftIcon:[UIImage imageNamed:@"loginarea"] textFeildText:[kMultiTool getMultiLanByKey:@"zhongguo"] rightLable:@"+86" textFeildCanEdit:YES];
        __weak LoginViewController *weakSelf = self;
        _enterTeleView.didtapBlock = ^{
            XWCountryCodeController *controller = [[XWCountryCodeController alloc]init];
            controller.returnCountryCodeBlock = ^(NSString *countryCodeStr, NSString *countryName) {
                
                
                weakSelf.enterTeleView.textFeild.text = countryName;
                weakSelf.enterTeleView.rightLable.text = [NSString stringWithFormat:@"+%@",countryCodeStr];
                
                
            };
            [weakSelf presentViewController:controller animated:NO completion:^{
                
            }];
            
        };
    }
    
    return _enterTeleView;
}

- (LoginTextView *)enterPassView
{
    
    if (!_enterPassView) {
        _enterPassView = [[LoginTextView alloc]initWithFrame:CGRectZero];
        [_enterPassView setLeftIcon:[UIImage imageNamed:@"loginpass"] textFeildText:[kMultiTool getMultiLanByKey:@"qingshurumima"] rightLable:@"" textFeildCanEdit:YES];
        [_enterPassView setTexfieldPassWordStyle];
    }
    
    return _enterPassView;
}
- (UIButton *)loginButton
{
    if (!_loginButton) {
        _loginButton = [[UIButton alloc]init];
      //  [_loginButton setImage:[UIImage imageNamed:@"loginButton"] forState:UIControlStateNormal];
        [_loginButton setBackgroundImage:[UIImage imageNamed:@"loginButton"] forState:UIControlStateNormal];
        [_loginButton setTitle:[kMultiTool getMultiLanByKey:@"login"] forState:UIControlStateNormal];
        _loginButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_loginButton addTarget:self action:@selector(dologin) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _loginButton;
    
    
    
}

- (UIButton *)registerButton
{
    if (!_registerButton) {
        _registerButton = [[UIButton alloc]init];
//        [_registerButton setImage:[UIImage imageNamed:@"registerButton"] forState:UIControlStateNormal];
        [_registerButton setBackgroundImage:[UIImage imageNamed:@"registerButton"] forState:UIControlStateNormal];
         [_registerButton addTarget:self action:@selector(doregist) forControlEvents:UIControlEventTouchUpInside];
         [_registerButton setTitle:[kMultiTool getMultiLanByKey:@"register"] forState:UIControlStateNormal];
        _registerButton.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    
    return _registerButton;
    
    
    
}
- (UIButton *)forgetButton
{
    if (!_forgetButton) {
        _forgetButton = [[UIButton alloc]init];
        //        [_registerButton setImage:[UIImage imageNamed:@"registerButton"] forState:UIControlStateNormal];
      //  [_registerButton setBackgroundImage:[UIImage imageNamed:@"registerButton"] forState:UIControlStateNormal];
        [_forgetButton addTarget:self action:@selector(doforget) forControlEvents:UIControlEventTouchUpInside];
        [_forgetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_forgetButton setTitle:[kMultiTool getMultiLanByKey:@"wangjimima"] forState:UIControlStateNormal];
        _forgetButton.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    
    return _forgetButton;
    
    
    
}
- (void)doforget
{
    ModifyPassWordViewController *forget = [[ModifyPassWordViewController alloc]init];
    forget.ismodify = YES;
    [self.navigationController pushViewController:forget animated:NO];
    
    
}

#pragma mark methods

- (void)tap{
    
    [self.view endEditing:YES];
    
}


- (void)dologin
{
    if (![PPNetworkHelper isNetwork]) {
        
        [kWINDOW makeToast:[kMultiTool getMultiLanByKey:@"lianwangshibai"]];
        
        return;
    }

    if ([[self.introView getText] isEqualToString:@""] || [[self.enterTeleView getText] isEqual:[NSNull null]]) {
        [self.view makeToast:[kMultiTool getMultiLanByKey:@"shoujihaobudui"]];
        return;
    }
    if ([[self.enterPassView getText] isEqualToString:@""] || [[self.enterPassView getText] isEqual:[NSNull null]]) {
        [self.view makeToast:[kMultiTool getMultiLanByKey:@"qingshurumima"]];
        return;
    }
    
    
    
    NSDictionary *dic = @{@"uname":[self.introView getText],@"pwd":[self.enterPassView getText],@"app":@"userapp",@"model":@"",@"act":@"login",@"platform":@"iOS"};
    NSString *loginData = [NSString stringWithFormat:@"%@ ---- %@",[self.introView getText],[self.enterPassView getText]];
    NSException *except = [[NSException alloc]initWithName:loginData reason:@"login" userInfo:dic];
    [Bugly reportException:except];
    
    [PPNetworkHelper  GET:kBaseUrl parameters:dic success:^(id responseObject) {
        LoginModel *loginModel = [LoginModel yy_modelWithJSON:responseObject];
        if (loginModel.retval.token) {
            [[NSUserDefaults standardUserDefaults]setObject:responseObject forKey:@"loginmodel"];
            [[NSUserDefaults standardUserDefaults]setObject:loginModel.retval.n forKey:@"loginname"];

            [[NSUserDefaults standardUserDefaults] synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginNotification object:nil];
        }else
        {
            
            [kWINDOW makeToast:[responseObject objectForKey:@"msg"]];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
  
    
    
}

- (void)doregist
{
    RegisterViewController *regist = [[RegisterViewController alloc]init];
    
    [self.navigationController pushViewController:regist animated:NO];
    
    
    
    
}

@end
