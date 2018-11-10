//
//  XJHCaptchaLoginViewController.m
//  caxjh
//
//  Created by Yingchao Zou on 30/08/2017.
//  Copyright © 2017 Yingchao Zou. All rights reserved.
//

#import "XJHCaptchaLoginViewController.h"
#import "XJHLoginInputView.h"
#import "XJHCaptchaResponse.h"
#import <CommonCrypto/CommonDigest.h>
#import "SocketManager.h"
@interface XJHCaptchaLoginViewController ()

<
UITextFieldDelegate
>

@property (nonatomic, readwrite, strong) UIImageView *logoImageView;
@property (nonatomic, readwrite, strong) XJHLoginInputView *inputView;
@property (nonatomic, readwrite, strong) UIButton *loginButton;

@property (nonatomic, readwrite, strong) UIButton *getCaptchaButton;

@property (nonatomic, readwrite, strong) NSTimer *codeTimer;
@property (nonatomic, readwrite, assign) NSUInteger codeTime;

@end

@implementation XJHCaptchaLoginViewController

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
    
    self.title = @"验证码登录";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem uc_backBarButtonItemWithAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.logoImageView];
    [self.view addSubview:self.inputView];
    [self.view addSubview:self.loginButton];
    [self.view addSubview:self.getCaptchaButton];
    
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
        // make.height.equalTo(@152);
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
    
    [self.getCaptchaButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@25);
        make.right.equalTo(self.inputView).with.offset(-15);
        make.bottom.equalTo(self.inputView).with.offset(-12);
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didTouchArrowButton {
    [self changeRole];
}

- (void)didTouchLoginButton {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *dictionary = @{@"phone" : self.inputView.textFieldNumber.text, @"password" : self.inputView.textFieldCode.text};
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

- (void)startCountTime {
    self.codeTime = 60;
    
    self.getCaptchaButton.enabled = NO;
    [self.getCaptchaButton setTitleColor:[UIColor colorWithHex:@"#6b6b6b"] forState:UIControlStateNormal];
    [self.getCaptchaButton setTitleColor:[UIColor colorWithHex:@"#6b6b6b"] forState:UIControlStateNormal];
    [self.getCaptchaButton setBackgroundColor:[UIColor colorWithHex:@"#e1e1e1"]];
    
    UIBackgroundTaskIdentifier bgTask = UIBackgroundTaskInvalid;
    UIApplication *app = [UIApplication sharedApplication];
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:bgTask];
    }];
    self.codeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(update) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.codeTimer forMode:NSRunLoopCommonModes];
}

- (void)update {
    
    if (self.codeTime == 0) {
        self.getCaptchaButton.enabled = YES;
        [self.getCaptchaButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        
        [self.getCaptchaButton setTitleColor:[UIColor colorWithHex:@"#ffffff"] forState:UIControlStateNormal];
        [self.getCaptchaButton setTitleColor:[UIColor colorWithHex:@"#ffffff"] forState:UIControlStateHighlighted];
        [self.getCaptchaButton setBackgroundColor:[UIColor colorWithHex:@"#ff6867"]];
        
        [self.codeTimer invalidate];
        self.codeTimer = nil;
        return;
    }
    [self.getCaptchaButton setTitle:[NSString stringWithFormat:@"    %ld秒    ", (long)self.codeTime] forState:UIControlStateNormal];
    self.codeTime--;
    
}

- (void)didTouchGetCaptchaButton {
    NSString *type = @"1";
    if ([self.inputView.textFieldRole.text isEqualToString:@"非学生"]) {
        type = @"0";
    } else {
        type = @"1";
    }

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *dictionary = @{@"type":type, @"phone":self.inputView.textFieldNumber.text, @"mode":@"login"};
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerJSON];
    [PPNetworkHelper POST:kAPICaptchaURL parameters:dictionary success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        XJHCaptchaResponse *response = [XJHCaptchaResponse mj_objectWithKeyValues:responseObject];
        if ([response.type isEqualToString:@"success"]) {
            [self startCountTime];
            [self.view makeToast:response.content duration:1.0 position:CSToastPositionTop];
        } else {
            [self.view makeToast:response.content duration:1.0 position:CSToastPositionTop];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)changeRole {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    alertController.popoverPresentationController.sourceView = self.view;
    alertController.popoverPresentationController.sourceRect = CGRectMake(0, 0, 1.0, 1.0);
    
    UIAlertAction *actionTeacher = [UIAlertAction actionWithTitle:@"非学生" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.inputView.textFieldRole.text = @"非学生";
    }];
    [alertController addAction:actionTeacher];
    
//    UIAlertAction *actionStudent = [UIAlertAction actionWithTitle:@"学生" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        self.inputView.textFieldRole.text = @"学生";
//    }];
//    [alertController addAction:actionStudent];
    
    [self.navigationController presentViewController:alertController animated:YES completion:^{
        
    }];
}

// UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.inputView.textFieldRole) {
        [self changeRole];
        return NO;
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.inputView.textFieldNumber) {
        if (textField.text.length >= 11) {
            return NO;
        }
    }
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] init];
        _logoImageView.image = [UIImage imageNamed:@"关于我们-logo"];
    }
    return _logoImageView;
}

- (XJHLoginInputView *)inputView {
    if (!_inputView) {
        _inputView = [[XJHLoginInputView alloc] init];
        // _inputView.textFieldRole.text = @"非学生";
        _inputView.textFieldRole.delegate = self;
        _inputView.textFieldNumber.keyboardType = UIKeyboardTypePhonePad;
        _inputView.textFieldNumber.delegate = self;
        _inputView.textFieldCode.placeholder = @"请输入验证码";
        _inputView.imageViewCode.image = [UIImage imageNamed:@"短信"];
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

- (UIButton *)getCaptchaButton {
    if (!_getCaptchaButton) {
        _getCaptchaButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_getCaptchaButton setTitle:@" 获取验证码 " forState:UIControlStateNormal];
        _getCaptchaButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [_getCaptchaButton setTitleColor:[UIColor colorWithHex:@"#ffffff"] forState:UIControlStateNormal];
        [_getCaptchaButton setTitleColor:[UIColor colorWithHex:@"#ffffff"] forState:UIControlStateHighlighted];
        [_getCaptchaButton setBackgroundColor:[UIColor colorWithHex:@"#ff6867"]];
        _getCaptchaButton.layer.cornerRadius = 3;
        _getCaptchaButton.layer.masksToBounds = YES;
        [_getCaptchaButton addTarget:self action:@selector(didTouchGetCaptchaButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _getCaptchaButton;
}

@end
