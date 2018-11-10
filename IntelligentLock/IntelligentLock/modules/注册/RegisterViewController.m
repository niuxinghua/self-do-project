//
//  RegisterViewController.m
//  IntelligentLock
//
//  Created by niuxinghua on 2018/2/6.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "RegisterViewController.h"
#import "LineLable.h"
#import "UserContentViewController.h"
#import "LoginModel.h"
@interface RegisterViewController ()

@property (nonatomic,strong)UIButton *checkButton;
@property (nonatomic,strong)LineLable *linelable;

@property (nonatomic,assign)BOOL ischecked;
@end

@implementation RegisterViewController

#pragma mark life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationUI];
    [self.view addSubview:self.introView];
    if(!kLoginModel.retval.area_code.length)
    {
     [self.view addSubview:self.enterTeleView];
    }
    
    [self.view addSubview:self.enterVerify];
    [self.view addSubview:self.enterPassView];
    [self.view addSubview:self.enterPassViewAgain];
    [self.view addSubview:self.registerButton];
//    [self.view addSubview:self.checkButton];
//    _linelable = [[LineLable alloc]init];
//    [self.view addSubview:_linelable];
//    _linelable.text = [kMultiTool getMultiLanByKey:@"zhucexieyi"];
//    _linelable.tapBlock = ^{
//        UserContentViewController *user = [[UserContentViewController alloc]init];
//        [self.navigationController pushViewController:user animated:NO];
//
  //  };
    
    [self makeConstrains];
    
}

- (void)makeConstrains {
    [self.introView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self.view);
        
        make.height.equalTo(@60);
        
        make.top.equalTo(self.view);
    }];
    if(!kLoginModel.retval.area_code.length)
    {
        [self.enterTeleView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.equalTo(self.view);
            
            make.height.equalTo(@60);
            
            make.top.equalTo(self.introView.mas_bottom);
        }];
        [self.enterVerify mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.equalTo(self.view);
            
            make.height.equalTo(@60);
            
            make.top.equalTo(self.enterTeleView.mas_bottom);
        }];
    }else
    {
        [self.enterVerify mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.equalTo(self.view);
            
            make.height.equalTo(@60);
            
            make.top.equalTo(self.introView.mas_bottom);
        }];
    }
   
   
    [self.enterPassView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self.view);
        
        make.height.equalTo(@60);
        
        make.top.equalTo(self.enterVerify.mas_bottom);
    }];
    [self.enterPassViewAgain mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self.view);
        
        make.height.equalTo(@60);
        
        make.top.equalTo(self.enterPassView.mas_bottom);
    }];
    
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self.view);
        
        make.height.equalTo(@40);
        
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
    }];
//    [self.checkButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(@16);
//        make.height.equalTo(@16);
//        make.centerX.equalTo(self.view).offset(-40);
//        make.top.equalTo(self.enterPassViewAgain.mas_bottom).offset(20);
//        
//    }];
//    [self.linelable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(@120);
//        make.height.equalTo(@16);
//        make.centerY.equalTo(self.checkButton.mas_centerY);
//        make.left.equalTo(self.checkButton.mas_right).offset(5);
//        
//    }];
}

#pragma mark navigation UI

- (void)setNavigationUI {
    
    UILabel *titleLabel =
    [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    
    titleLabel.textColor = [UIColor whiteColor];
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    titleLabel.text = [kMultiTool getMultiLanByKey:@"register"];
    
    self.navigationItem.titleView = titleLabel;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = NO;
    
    [self.navigationController.navigationBar
     setBackgroundImage:[UIImage imageNamed:@"navbackimage"]
     forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.leftBarButtonItem =
    [UIBarButtonItem uc_backBarButtonItemWithAction:^{
        
        self.navigationController.navigationBar.hidden = YES;
        [self.navigationController popViewControllerAnimated:NO];
        
    }];
}
#pragma mark private methods

- (void)getVerifyCode {
    if (!_introView.textFeild.text.length) {
        [kWINDOW makeToast:[kMultiTool getMultiLanByKey:@"shoujihaobudui"]];
        [_enterVerify.getVerify stopCountDown];
        return;
    }
      [kWINDOW makeToastActivity:CSToastPositionCenter];
    [_enterVerify.getVerify startCountDown];
    NSRange addRange = [_enterTeleView.rightLable.text rangeOfString:@"+"];
    NSMutableString *str =
    [[NSMutableString alloc] initWithString:_enterTeleView.rightLable.text];
    [str deleteCharactersInRange:addRange];
    if (kLoginModel.retval.area_code.length) {
        str = kLoginModel.retval.area_code.mutableCopy;
    }
    NSDictionary *dic = @{
                          @"t" : [_introView getText],
                          @"a" : str,
                          @"y" : [[_introView getText] containsString:@"@"]?@"2":@"1",
                          @"app" : @"userapp",
                          @"act" : @"authcode"
                          };
    
    [PPNetworkHelper GET:kBaseUrl
              parameters:dic
                 success:^(id responseObject) {
                       [kWINDOW hideToastActivity];
                     if (![[responseObject objectForKey:@"done"] boolValue]) {
//                         [self.enterVerify stopCount];
                         [self.view makeToast:[responseObject objectForKey:@"msg"]];
                     }else{
                         [_enterVerify.getVerify startCountDown];
                     }
                 }
                 failure:^(NSError *error) {
                      [kWINDOW hideToastActivity];
                    // [self.view makeToast:error.description];
                     
                 }];
}

- (void)didtouchregister {
    if (_enterPassView.textFeild.text.length && ![_enterPassView.textFeild.text isEqualToString:_enterPassViewAgain.textFeild.text]) {
        [kWINDOW makeToast:[kMultiTool getMultiLanByKey:@"mimabuyizhi"]];
        return;
    }
    if (!_enterVerify.textFeild.text.length) {
        [kWINDOW makeToast:[kMultiTool getMultiLanByKey:@"qingshuuyanzhengma"]];
        return;
    }
    NSRange addRange = [_enterTeleView.rightLable.text rangeOfString:@"+"];
    NSMutableString *str =
    [[NSMutableString alloc] initWithString:_enterTeleView.rightLable.text];
    [str deleteCharactersInRange:addRange];
    NSDictionary *dic = @{
                          @"uname" : [_introView getText],
                          @"pwd" : [_enterPassView getText],
                          @"t" : [_enterTeleView getText],
                          @"area" : str,
                          @"code" : [_enterVerify getText],
                          @"y" : [[_introView getText] containsString:@"@"]?@"2":@"1",
                          @"app" : @"userapp",
                          @"act" : @"register"
                          };
    
    [PPNetworkHelper GET:kBaseUrl
              parameters:dic
                 success:^(id responseObject) {
                     LoginModel *loginModel = [LoginModel yy_modelWithJSON:responseObject];
                     if (loginModel.retval.token) {
                         [[NSUserDefaults standardUserDefaults]setObject:responseObject forKey:@"loginmodel"];
                         [[NSUserDefaults standardUserDefaults] synchronize];
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"kLoginNotification" object:nil];
                     }else
                     {
                         
                         [kWINDOW makeToast:[responseObject objectForKey:@"msg"]];
                     }

                 }
                 failure:^(NSError *error) {
                   //  [self.view makeToast:error.description];
                     
                 }];
}
#pragma mark UI getters

- (RegisterItemView *)introView {
    if (!_introView) {
        _introView = [[RegisterItemView alloc] init];
    }
    [_introView setLeftIcon:[UIImage imageNamed:@"registerperson"]
              textFeildText:[kMultiTool getMultiLanByKey:@"zhanghaotishi"]
                 rightLable:@""
           textFeildCanEdit:YES];
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
                textFeildText:[kMultiTool getMultiLanByKey:@"yanzhengma"]
                   rightLable:@""
             textFeildCanEdit:YES];
    [_enterVerify showButton:YES];
    
    __weak RegisterViewController *weakSelf = self;
    
    _enterVerify.getVerifyblock = ^{
        
        [weakSelf getVerifyCode];
        
    };
    
    return _enterVerify;
}
- (RegisterItemView *)enterPassView {
    if (!_enterPassView) {
        _enterPassView = [[RegisterItemView alloc] init];
    }
    [_enterPassView setLeftIcon:[UIImage imageNamed:@"registerpass"]
                  textFeildText:[kMultiTool getMultiLanByKey:@"qingshurumima"]                   rightLable:@""
               textFeildCanEdit:YES];
    _enterPassView.textFeild.secureTextEntry = YES;
    return _enterPassView;
}
- (RegisterItemView *)enterPassViewAgain {
    if (!_enterPassViewAgain) {
        _enterPassViewAgain = [[RegisterItemView alloc] init];
    }
    _enterPassViewAgain.textFeild.secureTextEntry = YES;
    [_enterPassViewAgain setLeftIcon:[UIImage imageNamed:@"registerpass"]
                       textFeildText:[kMultiTool getMultiLanByKey:@"querenmima"]
                          rightLable:@""
                    textFeildCanEdit:YES];
    return _enterPassViewAgain;
}

- (UIButton *)registerButton {
    if (!_registerButton) {
        _registerButton = [[UIButton alloc] init];
        [_registerButton setTitle:[kMultiTool getMultiLanByKey:@"register"] forState:UIControlStateNormal];
        [_registerButton setTitleColor:[UIColor whiteColor]
                              forState:UIControlStateNormal];
        [_registerButton setBackgroundImage:[UIImage imageNamed:@"navbackimage"]
                                   forState:UIControlStateNormal];
        [_registerButton addTarget:self
                            action:@selector(didtouchregister)
                  forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _registerButton;
}
- (UIButton *)checkButton {
    if (!_checkButton) {
        _checkButton = [[UIButton alloc] init];
        [_checkButton setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
        [_checkButton addTarget:self action:@selector(clickcheck) forControlEvents:UIControlEventTouchUpInside];
        _ischecked = YES;
    }
    
    return _checkButton;
}

- (void)clickcheck
{
    _ischecked = !_ischecked;
    if (_ischecked) {
        [_checkButton setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
    }else
    {
        [_checkButton setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
    }
    
}
@end
