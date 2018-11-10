//
//  XJHRegistViewController.m
//  caxjh
//
//  Created by Yingchao Zou on 30/08/2017.
//  Copyright © 2017 Yingchao Zou. All rights reserved.
//

#import "XJHRegistViewController.h"
#import "XJHLoginResponse.h"
#import "XJHCaptchaResponse.h"
#import <CommonCrypto/CommonDigest.h>

@interface XJHRegistViewController ()

<
UITextFieldDelegate
>

@property (nonatomic, readwrite, strong) UIView *containerView;
@property (nonatomic, readwrite, strong) UIButton *registButton;

@property (nonatomic, readwrite, strong) UIImageView *imageViewRole;
@property (nonatomic, readwrite, strong) UIImageView *imageViewNumber;
@property (nonatomic, readwrite, strong) UIImageView *imageViewCaptcha;
@property (nonatomic, readwrite, strong) UIImageView *imageViewPassword;
@property (nonatomic, readwrite, strong) UIImageView *imageViewID;

@property (nonatomic, readwrite, strong) UITextField *textFieldRole;
@property (nonatomic, readwrite, strong) UITextField *textFieldNumber;
@property (nonatomic, readwrite, strong) UITextField *textFieldCaptcha;
@property (nonatomic, readwrite, strong) UITextField *textFieldPassword;
@property (nonatomic, readwrite, strong) UITextField *textFieldID;

@property (nonatomic, readwrite, strong) UIView *line1;
@property (nonatomic, readwrite, strong) UIView *line3;
@property (nonatomic, readwrite, strong) UIView *line4;
@property (nonatomic, readwrite, strong) UIView *line5;

@property (nonatomic, readwrite, strong) UIButton *arrowButtonRole;

@property (nonatomic, readwrite, strong) UIButton *getCaptchaButton;

@property (nonatomic, readwrite, strong) NSTimer *codeTimer;
@property (nonatomic, readwrite, assign) NSUInteger codeTime;

@end

@implementation XJHRegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"注册";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem uc_backBarButtonItemWithAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    self.view.backgroundColor = [UIColor colorWithHex:@"#fafafa"];
    
    [self.view addSubview:self.containerView];
    [self.view addSubview:self.registButton];
    
    [self.containerView addSubview:self.imageViewRole];
    [self.containerView addSubview:self.imageViewNumber];
    [self.containerView addSubview:self.imageViewCaptcha];
    [self.containerView addSubview:self.imageViewPassword];
    [self.containerView addSubview:self.imageViewID];
    
    [self.containerView addSubview:self.textFieldRole];
    [self.containerView addSubview:self.textFieldNumber];
    [self.containerView addSubview:self.textFieldCaptcha];
    [self.containerView addSubview:self.textFieldPassword];
    [self.containerView addSubview:self.textFieldID];
    
    [self.containerView addSubview:self.line1];
    [self.containerView addSubview:self.line3];
    [self.containerView addSubview:self.line4];
    [self.containerView addSubview:self.line5];
    
    [self.containerView addSubview:self.arrowButtonRole];
    
    [self.containerView addSubview:self.getCaptchaButton];
    

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // h 50 + 1 + 50 + 1 + 50 + 1 + 50 + 1 + 50  = 254
    
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(30);
        make.height.equalTo(@254);
        make.left.equalTo(self.view).with.offset(25);
        make.right.equalTo(self.view).with.offset(-25);
    }];
    
    [self.registButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.containerView);
        make.top.equalTo(self.containerView.mas_bottom).with.offset(30);
        make.height.equalTo(@50);
    }];
    
    // 框和线
    
    [self.textFieldRole mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).with.offset(60);
        make.right.equalTo(self.containerView).with.offset(-60);
        make.height.equalTo(@50);
        make.top.equalTo(self.containerView);
    }];
    
    [self.line1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView);
        make.right.equalTo(self.containerView);
        make.height.equalTo(@1);
        make.top.equalTo(self.textFieldRole.mas_bottom);
    }];
    
    [self.textFieldNumber mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).with.offset(60);
        make.right.equalTo(self.containerView).with.offset(-60);
        make.height.equalTo(@50);
        make.top.equalTo(self.line1.mas_bottom);
    }];
    
    [self.line3 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView);
        make.right.equalTo(self.containerView);
        make.height.equalTo(@1);
        make.top.equalTo(self.textFieldNumber.mas_bottom);
    }];
    
    [self.textFieldCaptcha mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).with.offset(60);
        make.right.equalTo(self.containerView).with.offset(-60);
        make.height.equalTo(@50);
        make.top.equalTo(self.line3.mas_bottom);
    }];
    
    [self.line4 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView);
        make.right.equalTo(self.containerView);
        make.height.equalTo(@1);
        make.top.equalTo(self.textFieldCaptcha.mas_bottom);
    }];
    
    [self.textFieldPassword mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).with.offset(60);
        make.right.equalTo(self.containerView).with.offset(-60);
        make.height.equalTo(@50);
        make.top.equalTo(self.line4.mas_bottom);
    }];
    
    [self.line5 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView);
        make.right.equalTo(self.containerView);
        make.height.equalTo(@1);
        make.top.equalTo(self.textFieldPassword.mas_bottom);
    }];
    
    [self.textFieldID mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).with.offset(60);
        make.right.equalTo(self.containerView).with.offset(-30);
        make.height.equalTo(@50);
        make.top.equalTo(self.line5.mas_bottom);
    }];
    
    // 图
    
    [self.imageViewRole mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@20);
        make.centerY.equalTo(self.textFieldRole);
        make.left.equalTo(self.containerView).with.offset(20);
    }];
    
    [self.imageViewNumber mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@20);
        make.centerY.equalTo(self.textFieldNumber);
        make.left.equalTo(self.containerView).with.offset(20);
    }];
    
    [self.imageViewCaptcha mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@20);
        make.centerY.equalTo(self.textFieldCaptcha);
        make.left.equalTo(self.containerView).with.offset(20);
    }];
    
    [self.imageViewPassword mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@20);
        make.centerY.equalTo(self.textFieldPassword);
        make.left.equalTo(self.containerView).with.offset(20);
    }];
    
    [self.imageViewID mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@20);
        make.centerY.equalTo(self.textFieldID);
        make.left.equalTo(self.containerView).with.offset(20);
    }];
    
    // 箭头
    
    [self.arrowButtonRole mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@15);
        make.right.equalTo(self.containerView).with.offset(-15);
        make.centerY.equalTo(self.textFieldRole);
    }];
    
    // 验证码按钮
    
    [self.getCaptchaButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@25);
        make.right.equalTo(self.containerView).with.offset(-15);
        make.centerY.equalTo(self.textFieldCaptcha);
    }];
    
    // 有点突兀
    [self ifShouldHide];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didTouchArrowButtonRole {
    [self changeRole];
}

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
    if ([self.textFieldRole.text isEqualToString:@"非学生"]) {
        type = @"0";
    } else {
        type = @"1";
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *dictionary = @{@"type":type, @"phone":self.textFieldNumber.text, @"mode":@"register"};
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

- (NSString *) md5:(NSString *) input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

- (void)didTouchRegistButton {
    
    NSString *type = @"1";
    if ([self.textFieldRole.text isEqualToString:@"非学生"]) {
        type = @"0";
    } else {
        type = @"1";
    }
    
    NSString *phone = self.textFieldNumber.text;
    
    NSString *nickName = @"";
    
    NSString *password = self.textFieldPassword.text;
    
    NSString *confirmCode = self.textFieldCaptcha.text;
    
    NSString *idCard = self.textFieldID.text;
    
    if ([type isEqualToString:@"0"]) {
        if (phone.length == 0) {
            [self.view makeToast:@"手机号不能为空" duration:1.0 position:CSToastPositionTop];
            return ;
        }
        if (password.length == 0) {
            [self.view makeToast:@"密码不能为空" duration:1.0 position:CSToastPositionTop];
            return ;
        }
        if (confirmCode.length == 0) {
            [self.view makeToast:@"验证码不能为空" duration:1.0 position:CSToastPositionTop];
            return ;
        }
    }
    
    else if ([type isEqualToString:@"1"]) {
        if (phone.length == 0) {
            [self.view makeToast:@"手机号不能为空" duration:1.0 position:CSToastPositionTop];
            return ;
        }
        if (password.length == 0) {
            [self.view makeToast:@"密码不能为空" duration:1.0 position:CSToastPositionTop];
            return ;
        }
        if (idCard.length == 0) {
            [self.view makeToast:@"身份证号不能为空" duration:1.0 position:CSToastPositionTop];
            return ;
        }
    }
    
    NSDictionary *dictionary = @{
                                 @"type" : type,
                                 @"phone" : phone,
                                 @"nickname" : nickName,
                                 @"password" : [self md5:password],
                                 @"confirmCode" : confirmCode,
                                 @"idCard" : idCard
                                 };
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerJSON];
    [PPNetworkHelper POST:kAPIRegistURL parameters:dictionary success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        XJHLoginResponse *loginResponse = [XJHLoginResponse mj_objectWithKeyValues:responseObject];
        NSLog(@"%@", loginResponse);
        
        if ([loginResponse.type isEqualToString:@"success"]) {
            [self.view makeToast:@"注册成功"];
            [self performSelector:@selector(navigateBack) withObject:nil afterDelay:2.0];
        } else {
            [self.view makeToast:loginResponse.text];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark -

- (void)navigateBack {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -

- (void)changeRole {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    alertController.popoverPresentationController.sourceView = self.view;
    alertController.popoverPresentationController.sourceRect = CGRectMake(0, 0, 1.0, 1.0);
    UIAlertAction *actionTeacher = [UIAlertAction actionWithTitle:@"非学生" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.textFieldRole.text = @"非学生";
        self.textFieldNumber.placeholder = @"请输入手机号码";
        self.textFieldNumber.keyboardType = UIKeyboardTypePhonePad;
        
        [self ifShouldHide];
    }];
    UIAlertAction *actionStudent = [UIAlertAction actionWithTitle:@"学生" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.textFieldRole.text = @"学生";
        self.textFieldNumber.placeholder = @"请输入账号";
        self.textFieldNumber.keyboardType = UIKeyboardTypeDefault;
        
        [self ifShouldHide];
    }];
    [alertController addAction:actionTeacher];
    [alertController addAction:actionStudent];
    [self.navigationController presentViewController:alertController animated:YES completion:^{
        
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)ifShouldHide {
    if ([self.textFieldRole.text isEqualToString:@"非学生"]) {
        [self style1];
    }
    
    else {
        [self style2];
    }
}

- (void)style1 {
    
    // 非学生 显示验证码四件
    
    self.textFieldCaptcha.placeholder = @"请输入验证码";
    
    [self.textFieldCaptcha mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).with.offset(60);
        make.right.equalTo(self.containerView).with.offset(-60);
        make.height.equalTo(@50);
        make.top.equalTo(self.line3.mas_bottom);
    }];
    
    [self.line4 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView);
        make.right.equalTo(self.containerView);
        make.height.equalTo(@1);
        make.top.equalTo(self.textFieldCaptcha.mas_bottom);
    }];
    
    [self.getCaptchaButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@25);
        make.right.equalTo(self.containerView).with.offset(-15);
        make.centerY.equalTo(self.textFieldCaptcha);
    }];
    
    [self.imageViewCaptcha mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@20);
        make.centerY.equalTo(self.textFieldCaptcha);
        make.left.equalTo(self.containerView).with.offset(20);
    }];
    
    
    
    self.textFieldID.placeholder = @"";
    self.textFieldID.text = @"";
    
    [self.line5 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView);
        make.right.equalTo(self.containerView);
        make.height.equalTo(@0);
        make.top.equalTo(self.textFieldPassword.mas_bottom);
    }];
    
    [self.textFieldID mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).with.offset(60);
        make.right.equalTo(self.containerView).with.offset(-30);
        make.height.equalTo(@0);
        make.top.equalTo(self.line5.mas_bottom);
    }];
    
    [self.imageViewID mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@0);
        make.centerY.equalTo(self.textFieldID);
        make.left.equalTo(self.containerView).with.offset(20);
    }];
    
    [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(30);
        make.height.equalTo(@203);
        make.left.equalTo(self.view).with.offset(25);
        make.right.equalTo(self.view).with.offset(-25);
    }];
    

}

- (void)style2 {
    
    // 学生 隐藏验证码四件
    
    self.textFieldCaptcha.placeholder = @"";
    
    [self.textFieldCaptcha mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).with.offset(60);
        make.right.equalTo(self.containerView).with.offset(-60);
        make.height.equalTo(@0);
        make.top.equalTo(self.line3.mas_bottom);
    }];
    
    [self.line4 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView);
        make.right.equalTo(self.containerView);
        make.height.equalTo(@0);
        make.top.equalTo(self.textFieldCaptcha.mas_bottom);
    }];
    
    [self.getCaptchaButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0);
        make.right.equalTo(self.containerView).with.offset(-15);
        make.centerY.equalTo(self.textFieldCaptcha);
    }];
    
    [self.imageViewCaptcha mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@0);
        make.centerY.equalTo(self.textFieldCaptcha);
        make.left.equalTo(self.containerView).with.offset(20);
    }];
    
    
    //
    self.textFieldID.placeholder = @"请输入学生身份证号";
    
    [self.line5 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView);
        make.right.equalTo(self.containerView);
        make.height.equalTo(@1);
        make.top.equalTo(self.textFieldPassword.mas_bottom);
    }];
    
    [self.textFieldID mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).with.offset(60);
        make.right.equalTo(self.containerView).with.offset(-30);
        make.height.equalTo(@50);
        make.top.equalTo(self.line5.mas_bottom);
    }];
    
    [self.imageViewID mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@20);
        make.centerY.equalTo(self.textFieldID);
        make.left.equalTo(self.containerView).with.offset(20);
    }];
    
    //
    [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(30);
        make.height.equalTo(@203);
        make.left.equalTo(self.view).with.offset(25);
        make.right.equalTo(self.view).with.offset(-25);
    }];
}

// UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.textFieldRole) {
        [self changeRole];
        return NO;
    }
    
    return YES;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.layer.borderWidth = 1;
        _containerView.layer.cornerRadius = 3;
        _containerView.layer.borderColor = [UIColor colorWithHex:@"#e1e1e1"].CGColor;
        _containerView.layer.masksToBounds = YES;
    }
    return _containerView;
}

- (UIButton *)registButton {
    if (!_registButton) {
        _registButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_registButton setTitle:@"注册" forState:UIControlStateNormal];
        [_registButton setTitleColor:[UIColor colorWithHex:@"#ffffff"] forState:UIControlStateNormal];
        [_registButton setTitleColor:[UIColor colorWithHex:@"#ffffff"] forState:UIControlStateHighlighted];
        [_registButton setBackgroundColor:[UIColor colorWithHex:@"#ff6867"]];
        _registButton.layer.cornerRadius = 3;
        _registButton.layer.masksToBounds = YES;
        [_registButton addTarget:self action:@selector(didTouchRegistButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registButton;
}

- (UIImageView *)imageViewRole {
    if (!_imageViewRole) {
        _imageViewRole = [[UIImageView alloc] init];
        _imageViewRole.image = [UIImage imageNamed:@"人"];
    }
    return _imageViewRole;
}

- (UIImageView *)imageViewNumber {
    if (!_imageViewNumber) {
        _imageViewNumber = [[UIImageView alloc] init];
        _imageViewNumber.image = [UIImage imageNamed:@"手机"];
    }
    return _imageViewNumber;
}

- (UIImageView *)imageViewCaptcha {
    if (!_imageViewCaptcha) {
        _imageViewCaptcha = [[UIImageView alloc] init];
        _imageViewCaptcha.image = [UIImage imageNamed:@"短信"];
    }
    return _imageViewCaptcha;
}

- (UIImageView *)imageViewPassword {
    if (!_imageViewPassword) {
        _imageViewPassword = [[UIImageView alloc] init];
        _imageViewPassword.image = [UIImage imageNamed:@"密码"];
    }
    return _imageViewPassword;
}

- (UIImageView *)imageViewID {
    if (!_imageViewID) {
        _imageViewID = [[UIImageView alloc] init];
        _imageViewID.image = [UIImage imageNamed:@"身份证"];
    }
    return _imageViewID;
}

- (UITextField *)textFieldRole {
    if (!_textFieldRole) {
        _textFieldRole = [[UITextField alloc] init];
        _textFieldRole.text = @"非学生";
        _textFieldRole.delegate = self;
    }
    return _textFieldRole;
}

- (UITextField *)textFieldNumber {
    if (!_textFieldNumber) {
        _textFieldNumber = [[UITextField alloc] init];
        _textFieldNumber.placeholder = @"请输入手机号码";
        _textFieldNumber.keyboardType = UIKeyboardTypePhonePad;
        [_textFieldNumber addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textFieldNumber;
}

- (void)textFieldDidChange:(UITextField *)textField {
    NSUInteger length = textField.text.length;
    if (length > 0) {
        self.getCaptchaButton.enabled = YES;
    } else {
        self.getCaptchaButton.enabled = NO;
    }
}

- (UITextField *)textFieldCaptcha {
    if (!_textFieldCaptcha) {
        _textFieldCaptcha = [[UITextField alloc] init];
        _textFieldCaptcha.placeholder = @"请输入验证码";
    }
    return _textFieldCaptcha;
}

- (UITextField *)textFieldPassword {
    if (!_textFieldPassword) {
        _textFieldPassword = [[UITextField alloc] init];
        _textFieldPassword.placeholder = @"请输入密码";
        _textFieldPassword.secureTextEntry = YES;
    }
    return _textFieldPassword;
}

- (UITextField *)textFieldID {
    if (!_textFieldID) {
        _textFieldID = [[UITextField alloc] init];
        _textFieldID.placeholder = @"请输入学生身份证号";
    }
    return _textFieldID;
}

- (UIView *)line1 {
    if (!_line1) {
        _line1 = [[UIView alloc] init];
        _line1.backgroundColor = [UIColor colorWithHex:@"#e1e1e1"];
    }
    return _line1;
}

- (UIView *)line3 {
    if (!_line3) {
        _line3 = [[UIView alloc] init];
        _line3.backgroundColor = [UIColor colorWithHex:@"#e1e1e1"];
    }
    return _line3;
}

- (UIView *)line4 {
    if (!_line4) {
        _line4 = [[UIView alloc] init];
        _line4.backgroundColor = [UIColor colorWithHex:@"#e1e1e1"];
    }
    return _line4;
}

- (UIView *)line5 {
    if (!_line5) {
        _line5 = [[UIView alloc] init];
        _line5.backgroundColor = [UIColor colorWithHex:@"#e1e1e1"];
    }
    return _line5;
}

- (UIButton *)arrowButtonRole {
    if (!_arrowButtonRole) {
        _arrowButtonRole = [UIButton buttonWithType:UIButtonTypeCustom];
        [_arrowButtonRole setImage:[UIImage imageNamed:@"下箭头"] forState:UIControlStateNormal];
        [_arrowButtonRole addTarget:self action:@selector(didTouchArrowButtonRole) forControlEvents:UIControlEventTouchUpInside];
    }
    return _arrowButtonRole;
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
        _getCaptchaButton.enabled = NO;
    }
    return _getCaptchaButton;
}

@end
