//
//  XJHCommonLoginViewController.m
//  caxjh
//
//  Created by Yingchao Zou on 30/08/2017.
//  Copyright © 2017 Yingchao Zou. All rights reserved.
//

#import "XJHCommonLoginViewController.h"
#import "XJHLoginInputView.h"
#import "XJHCaptchaLoginViewController.h"
#import "XJHRegistViewController.h"
#import "XJHForgetPasswordViewController.h"
#import "XJHLoginResponse.h"
#import "XJHUser.h"
#import <CommonCrypto/CommonDigest.h>
#import "SocketManager.h"

@interface XJHCommonLoginViewController ()

<
UITextFieldDelegate
>

@property (nonatomic, readwrite, strong) UIImageView *logoImageView;

@property (nonatomic, readwrite, strong) XJHLoginInputView *inputView;

@property (nonatomic, readwrite, strong) UIButton *loginButton;
@property (nonatomic, readwrite, strong) UIButton *registButton;
@property (nonatomic, readwrite, strong) UIButton *forgetButton;

@property (nonatomic, readwrite, strong) UIButton *viaCaptchaButton;

@end

@implementation XJHCommonLoginViewController

- (NSString *) md5:(NSString *) input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"登录";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.logoImageView];
    [self.view addSubview:self.inputView];
    [self.view addSubview:self.loginButton];
    [self.view addSubview:self.registButton];
    [self.view addSubview:self.forgetButton];
    [self.view addSubview:self.viaCaptchaButton];
    
    //    [XJHUser mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
    //        return @{@"theID" : @"id"};
    //    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.logoImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(30);
        make.width.equalTo(@220);
        make.height.equalTo(@70);
    }];
    
    [self.inputView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@101);
        make.top.equalTo(self.logoImageView.mas_bottom).with.offset(30);
        make.left.equalTo(self.view).with.offset(25);
        make.right.equalTo(self.view).with.offset(-25);
    }];
    
    [self.loginButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.inputView);
        make.top.equalTo(self.inputView.mas_bottom).with.offset(30);
        make.height.equalTo(@50);
    }];
    
    [self.registButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.loginButton.mas_left);
        make.top.equalTo(self.loginButton.mas_bottom).with.offset(25);
    }];
    
    [self.forgetButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.loginButton.mas_right);
        make.top.equalTo(self.loginButton.mas_bottom).with.offset(25);
    }];
    
    [self.viaCaptchaButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-10);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)didTouchArrowButton {
    [self changeRole];
}

- (void)didTouchLoginButton {
    if (self.inputView.textFieldNumber.text.length == 0) {
        [self.view makeToast:@"账号不能为空" duration:1.0 position:CSToastPositionTop];
        return ;
    }
    if (self.inputView.textFieldCode.text.length == 0) {
        [self.view makeToast:@"密码不能为空" duration:1.0 position:CSToastPositionTop];
        return ;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *dictionary = @{@"phone" : self.inputView.textFieldNumber.text, @"password" : [self md5:self.inputView.textFieldCode.text]};
    
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerJSON];
    [PPNetworkHelper POST:kAPILoginURL parameters:dictionary success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        XJHLoginResponse *loginResponse = [XJHLoginResponse mj_objectWithKeyValues:responseObject];
        NSLog(@"%@", loginResponse);
        
        if ([loginResponse.type isEqualToString:@"success"]) {
            
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"][@"id"] forKey:@"USER_ID"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSUserDefaults standardUserDefaults] setObject:self.inputView.textFieldNumber.text forKey:@"USER_PHONE"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSString *userDataPhone = responseObject[@"data"][@"phone"];
            userDataPhone = [userDataPhone isEqual:[NSNull null]] ? @"" : userDataPhone;
            [[NSUserDefaults standardUserDefaults] setObject:userDataPhone forKey:@"USER_DATA_PHONE"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSString *userDataLoginName = responseObject[@"data"][@"loginName"];
            userDataLoginName = [userDataLoginName isEqual:[NSNull null]] ? @"" : userDataLoginName;
            [[NSUserDefaults standardUserDefaults] setObject:userDataLoginName forKey:@"USER_DATA_LOGINNAME"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            // 0主账户 1子账户
            NSString *userDataIsMain = responseObject[@"data"][@"isMain"];
            userDataIsMain = [userDataIsMain isEqual:[NSNull null]] ? @"" : userDataIsMain;
            [[NSUserDefaults standardUserDefaults] setObject:userDataIsMain forKey:@"USER_DATA_ISMAIN"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            // 0老师 1家长 2学生
            NSString *userDataType = responseObject[@"data"][@"type"];
            userDataType = [userDataType isEqual:[NSNull null]] ? @"" : userDataType;
            [[NSUserDefaults standardUserDefaults] setObject:userDataType forKey:@"USER_DATA_TYPE"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSString *userDataToken = responseObject[@"data"][@"token"];
            userDataToken = [userDataToken isEqual:[NSNull null]] ? @"" : userDataToken;
            [[NSUserDefaults standardUserDefaults] setObject:userDataToken forKey:@"USER_DATA_TOKEN"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSString *userNickName = responseObject[@"data"][@"nickName"];
            userNickName = [userDataPhone isEqual:[NSNull null]] ? @"" : userDataPhone;
            if (userNickName.length > 0) {
                [[NSUserDefaults standardUserDefaults] setObject:userDataPhone forKey:@"USER_DATA_NAME"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            
            [self.view makeToast:@"登录成功"];
            [self performSelector:@selector(navigateToTab) withObject:nil afterDelay:2.0];
        } else {
            [self.view makeToast:loginResponse.content duration:1.0 position:CSToastPositionTop];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
}

#pragma mark -
- (void)navigateToTab {
    if (self.delegate && [self.delegate respondsToSelector:@selector(toTab)]) {
        [self.delegate toTab];
    }
}
#pragma mark -

- (void)didTouchRegistButton {
    XJHRegistViewController *registViewController = [[XJHRegistViewController alloc] init];
    [self.navigationController pushViewController:registViewController animated:YES];
}

- (void)didTouchForgetButton {
    XJHForgetPasswordViewController *forgetPasswordViewController = [[XJHForgetPasswordViewController alloc] init];
    [self.navigationController pushViewController:forgetPasswordViewController animated:YES];
}

- (void)didTouchViaCaptchaButton {
    XJHCaptchaLoginViewController *captchaLoginViewController = [[XJHCaptchaLoginViewController alloc] init];
    captchaLoginViewController.delegate = self.delegate;
    [self.navigationController pushViewController:captchaLoginViewController animated:YES];
}

- (void)didLongPress {
#ifdef DEBUG
    self.inputView.textFieldNumber.text = @"15954082701";
    self.inputView.textFieldCode.text = @"1234";
#endif
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

// UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.inputView.textFieldRole) {
        [self changeRole];
        return NO;
    }
    return YES;
}

- (void)changeRole {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    alertController.popoverPresentationController.sourceView = self.view;
    alertController.popoverPresentationController.sourceRect = CGRectMake(0, 0, 1.0, 1.0);
    UIAlertAction *actionTeacher = [UIAlertAction actionWithTitle:@"非学生" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.inputView.textFieldRole.text = @"非学生";
        self.inputView.textFieldNumber.placeholder = @"请输入手机号码";
        self.inputView.textFieldNumber.keyboardType = UIKeyboardTypePhonePad;
    }];
    UIAlertAction *actionStudent = [UIAlertAction actionWithTitle:@"学生" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.inputView.textFieldRole.text = @"学生";
        self.inputView.textFieldNumber.placeholder = @"请输入账号";
        self.inputView.textFieldNumber.keyboardType = UIKeyboardTypeDefault;
    }];
    [alertController addAction:actionTeacher];
    [alertController addAction:actionStudent];
    [self.navigationController presentViewController:alertController animated:YES completion:^{
        
    }];
}

- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] init];
        _logoImageView.image = [UIImage imageNamed:@"关于我们-logo"];
        _logoImageView.userInteractionEnabled = YES;
        
#ifdef DEBUG
        UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPress)];
        recognizer.minimumPressDuration = 2;
        [_logoImageView addGestureRecognizer:recognizer];
#endif
    }
    return _logoImageView;
}

- (XJHLoginInputView *)inputView {
    if (!_inputView) {
        _inputView = [[XJHLoginInputView alloc] init];
        // _inputView.textFieldRole.text = @"非学生";
        // _inputView.textFieldNumber.keyboardType = UIKeyboardTypeNumberPad;
        _inputView.textFieldNumber.placeholder = @"请输入手机号或登录名";
        _inputView.textFieldCode.placeholder = @"请输入密码";
        _inputView.textFieldCode.secureTextEntry = YES;
        _inputView.textFieldRole.delegate = self;
        _inputView.imageViewCode.image = [UIImage imageNamed:@"密码"];
        [_inputView.arrowButton addTarget:self action:@selector(didTouchArrowButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _inputView;
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor colorWithHex:@"#ffffff"] forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor colorWithHex:@"#ffffff"] forState:UIControlStateHighlighted];
        [_loginButton setBackgroundColor:[UIColor colorWithHex:@"#ff6867"]];
        _loginButton.layer.cornerRadius = 3;
        _loginButton.layer.masksToBounds = YES;
        [_loginButton addTarget:self action:@selector(didTouchLoginButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

- (UIButton *)registButton {
    if (!_registButton) {
        _registButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_registButton setTitleColor:[UIColor colorWithHex:@"#6b6b6b"] forState:UIControlStateNormal];
        _registButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [_registButton setTitle:@"注册账号" forState:UIControlStateNormal];
        [_registButton addTarget:self action:@selector(didTouchRegistButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registButton;
}

- (UIButton *)forgetButton {
    if (!_forgetButton) {
        _forgetButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_forgetButton setTitleColor:[UIColor colorWithHex:@"#6b6b6b"] forState:UIControlStateNormal];
        _forgetButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [_forgetButton setTitle:@"忘记密码？" forState:UIControlStateNormal];
        [_forgetButton addTarget:self action:@selector(didTouchForgetButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgetButton;
}

- (UIButton *)viaCaptchaButton {
    if (!_viaCaptchaButton) {
        _viaCaptchaButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_viaCaptchaButton setTitleColor:[UIColor colorWithHex:@"#6b6b6b"] forState:UIControlStateNormal];
        _viaCaptchaButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [_viaCaptchaButton setTitle:@"验证码登录" forState:UIControlStateNormal];
        [_viaCaptchaButton addTarget:self action:@selector(didTouchViaCaptchaButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _viaCaptchaButton;
}

@end
