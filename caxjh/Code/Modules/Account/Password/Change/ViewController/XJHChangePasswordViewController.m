//
//  XJHForgetPasswordViewController.m
//  caxjh
//
//  Created by Yingchao Zou on 30/08/2017.
//  Copyright © 2017 Yingchao Zou. All rights reserved.
//

#import "XJHChangePasswordViewController.h"
#import "XJHCaptchaResponse.h"
#import <CommonCrypto/CommonDigest.h>
#import "XJHLoginResponse.h"

@interface XJHChangePasswordViewController ()

<
UITextFieldDelegate
>

@property (nonatomic, readwrite, strong) UIView *containerView;

@property (nonatomic, readwrite, strong) UIImageView *imageViewRole;
@property (nonatomic, readwrite, strong) UIImageView *imageViewNumber;
@property (nonatomic, readwrite, strong) UIImageView *imageViewCaptcha;
@property (nonatomic, readwrite, strong) UIImageView *imageViewPassword;
@property (nonatomic, readwrite, strong) UIImageView *imageViewConfirm;

@property (nonatomic, readwrite, strong) UITextField *textFieldRole;
@property (nonatomic, readwrite, strong) UITextField *textFieldNumber;
@property (nonatomic, readwrite, strong) UITextField *textFieldCaptcha;
@property (nonatomic, readwrite, strong) UITextField *textFieldPassword;
@property (nonatomic, readwrite, strong) UITextField *textFieldConfirm;

@property (nonatomic, readwrite, strong) UIButton *roleArrowButton;

@property (nonatomic, readwrite, strong) UIButton *resetButton;

@property (nonatomic, readwrite, strong) UIView *line1;
@property (nonatomic, readwrite, strong) UIView *line2;
@property (nonatomic, readwrite, strong) UIView *line3;
@property (nonatomic, readwrite, strong) UIView *line4;

@property (nonatomic, readwrite, strong) NSTimer *codeTimer;
@property (nonatomic, readwrite, assign) NSUInteger codeTime;

@end

@implementation XJHChangePasswordViewController

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
    
    self.title = @"修改密码";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem uc_backBarButtonItemWithAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    self.view.backgroundColor = [UIColor colorWithHex:@"#fafafa"];
    
    [self.view addSubview:self.containerView];
    [self.view addSubview:self.resetButton];
    
    [self.containerView addSubview:self.imageViewRole];
    [self.containerView addSubview:self.imageViewNumber];
    [self.containerView addSubview:self.imageViewCaptcha];
    [self.containerView addSubview:self.imageViewPassword];
    [self.containerView addSubview:self.imageViewConfirm];
    
    [self.containerView addSubview:self.textFieldRole];
    [self.containerView addSubview:self.textFieldNumber];
    [self.containerView addSubview:self.textFieldCaptcha];
    [self.containerView addSubview:self.textFieldPassword];
    [self.containerView addSubview:self.textFieldConfirm];
    
    [self.containerView addSubview:self.roleArrowButton];
    
    [self.containerView addSubview:self.line1];
    [self.containerView addSubview:self.line2];
    [self.containerView addSubview:self.line3];
    [self.containerView addSubview:self.line4];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        // make.height.equalTo(@254);
        make.height.equalTo(@(203-51));
        make.top.equalTo(self.view).with.offset(30);
        make.left.equalTo(self.view).with.offset(25);
        make.right.equalTo(self.view).with.offset(-25);
    }];
    
    [self.resetButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.containerView);
        make.top.equalTo(self.containerView.mas_bottom).with.offset(30);
        make.height.equalTo(@50);
    }];
    
    [self.textFieldRole mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).with.offset(60);
        make.right.equalTo(self.containerView).with.offset(-60);
        // make.height.equalTo(@50);
        make.height.equalTo(@0);
        make.top.equalTo(self.containerView);
    }];
    
    [self.line1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        // make.height.equalTo(@1);
        make.height.equalTo(@0);
        make.left.equalTo(self.containerView);
        make.right.equalTo(self.containerView);
        make.top.equalTo(self.textFieldRole.mas_bottom);
    }];
    
    [self.textFieldNumber mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).with.offset(60);
        make.right.equalTo(self.containerView).with.offset(-60);
        make.height.equalTo(@0);
        make.top.equalTo(self.line1.mas_bottom);
    }];
    
    [self.line2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0);
        make.left.equalTo(self.containerView);
        make.right.equalTo(self.containerView);
        make.top.equalTo(self.textFieldNumber.mas_bottom);
    }];
    
    [self.textFieldCaptcha mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).with.offset(60);
        make.right.equalTo(self.containerView).with.offset(-60);
        make.height.equalTo(@50);
        make.top.equalTo(self.line2.mas_bottom);
    }];
    
    [self.line3 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@1);
        make.left.equalTo(self.containerView);
        make.right.equalTo(self.containerView);
        make.top.equalTo(self.textFieldCaptcha.mas_bottom);
    }];
    
    [self.textFieldPassword mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).with.offset(60);
        make.right.equalTo(self.containerView).with.offset(-60);
        make.height.equalTo(@50);
        make.top.equalTo(self.line3.mas_bottom);
    }];
    
    [self.line4 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@1);
        make.left.equalTo(self.containerView);
        make.right.equalTo(self.containerView);
        make.top.equalTo(self.textFieldPassword.mas_bottom);
    }];
    
    [self.textFieldConfirm mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).with.offset(60);
        make.right.equalTo(self.containerView).with.offset(-60);
        make.height.equalTo(@50);
        make.top.equalTo(self.line4.mas_bottom);
    }];
    
    [self.imageViewRole mas_remakeConstraints:^(MASConstraintMaker *make) {
        // make.width.height.equalTo(@20);
        make.width.height.equalTo(@0);
        make.left.equalTo(self.containerView).with.offset(20);
        make.centerY.equalTo(self.textFieldRole);
    }];
    
    [self.imageViewNumber mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@0);
        make.left.equalTo(self.containerView).with.offset(20);
        make.centerY.equalTo(self.textFieldNumber);
    }];
    
    [self.imageViewCaptcha mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@20);
        make.left.equalTo(self.containerView).with.offset(20);
        make.centerY.equalTo(self.textFieldCaptcha);
    }];
    
    [self.imageViewPassword mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@20);
        make.left.equalTo(self.containerView).with.offset(20);
        make.centerY.equalTo(self.textFieldPassword);
    }];
    
    [self.imageViewConfirm mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@20);
        make.left.equalTo(self.containerView).with.offset(20);
        make.centerY.equalTo(self.textFieldConfirm);
    }];
    
    [self.roleArrowButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        // make.width.height.equalTo(@15);
        make.width.height.equalTo(@0);
        make.right.equalTo(self.containerView).with.offset(-15);
        make.centerY.equalTo(self.textFieldRole);
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didTouchRoleArrowButton {
    [self changeRole];
}

- (void)didTouchResetButton {
    
    /*
    NSString *type = @"1";
    if ([self.textFieldRole.text isEqualToString:@"非学生"]) {
        type = @"0";
    } else {
        type = @"1";
    }
     */
    
    if (self.textFieldCaptcha.text.length == 0 || self.textFieldPassword.text.length == 0 || self.textFieldConfirm.text.length == 0) {
        [self.view makeToast:@"请填写完整" duration:1.0 position:CSToastPositionTop];
        return ;
    }
    
    if (![self.textFieldPassword.text isEqualToString:self.textFieldConfirm.text]) {
        [self.view makeToast:@"两次输入密码不一致" duration:1.0 position:CSToastPositionTop];
        return ;
    }
    
    NSString *userID = [[NSUserDefaults standardUserDefaults] stringForKey:@"USER_ID"];
    
    NSDictionary *dictionary1 = @{@"columns":@[@"id"], @"order":@{}, @"filter" : @{@"id" : @{@"eq" : userID}, @"password": @{@"eq": [self md5:self.textFieldCaptcha.text]}}, @"table": @"Member"};
    
    // 验证旧密码
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerJSON];
    [PPNetworkHelper POST:kAPIQueryUrl parameters:dictionary1 success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        XJHLoginResponse *loginResponse = [XJHLoginResponse mj_objectWithKeyValues:responseObject];
        if ([loginResponse.type isEqualToString:@"success"]) {
            NSArray *data = [responseObject objectForKey:@"data"];
            if (data.count > 0) {
                
                // // // // // // // // // //
                // 设置新密码
                NSDictionary *dictionary2 = @{@"fields" : @{@"password" : [self md5:self.textFieldPassword.text]}, @"id" : userID, @"table" : @"Member"};
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [PPNetworkHelper setRequestSerializer:PPRequestSerializerJSON];
                [PPNetworkHelper POST:kAPIUpdateURL parameters:dictionary2 success:^(id responseObject) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    XJHLoginResponse *loginResponse = [XJHLoginResponse mj_objectWithKeyValues:responseObject];
                    if ([loginResponse.type isEqualToString:@"success"]) {
                        
                        [self.view makeToast:@"修改成功" duration:1.0 position:CSToastPositionTop];
                        [self performSelector:@selector(goToSetting) withObject:nil afterDelay:1.0];
                    } else {
                        [self.view makeToast:@"修改失败" duration:1.0 position:CSToastPositionTop];
                    }
                } failure:^(NSError *error) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                }];
                // // // // // // // // // //
                
            } else {
                [self.view makeToast:@"旧密码错误" duration:1.0 position:CSToastPositionTop];
            }
            
        } else {
            [self.view makeToast:@"旧密码验证出现问题" duration:1.0 position:CSToastPositionTop];
        }

    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
}

- (void)goToSetting {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)changeRole {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    alertController.popoverPresentationController.sourceView = self.view;
    alertController.popoverPresentationController.sourceRect = CGRectMake(0, 0, 1.0, 1.0);
    
    UIAlertAction *actionTeacher = [UIAlertAction actionWithTitle:@"非学生" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.textFieldRole.text = @"非学生";
        // self.textFieldNumber.placeholder = @"请输入手机号码";
        self.textFieldNumber.placeholder = @"";
    }];
    [alertController addAction:actionTeacher];
    
    UIAlertAction *actionStudent = [UIAlertAction actionWithTitle:@"学生" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.textFieldRole.text = @"学生";
        // self.textFieldNumber.placeholder = @"请输入账号";
        self.textFieldNumber.placeholder = @"";
    }];
    [alertController addAction:actionStudent];
    
    [self.navigationController presentViewController:alertController animated:YES completion:^{
        
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

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

- (UIImageView *)imageViewConfirm {
    if (!_imageViewConfirm) {
        _imageViewConfirm = [[UIImageView alloc] init];
        _imageViewConfirm.image = [UIImage imageNamed:@"密码"];
    }
    return _imageViewConfirm;
}

- (UITextField *)textFieldRole {
    if (!_textFieldRole) {
        _textFieldRole = [[UITextField alloc] init];
        _textFieldRole.placeholder = @"";
        // _textFieldRole.text = @"非学生";
        _textFieldRole.delegate = self;
    }
    return _textFieldRole;
}

- (UITextField *)textFieldNumber {
    if (!_textFieldNumber) {
        _textFieldNumber= [[UITextField alloc] init];
        // _textFieldNumber.placeholder = @"请输入手机号码";
        _textFieldNumber.placeholder = @"";
        _textFieldNumber.keyboardType = UIKeyboardTypePhonePad;
    }
    return _textFieldNumber;
}

- (UITextField *)textFieldCaptcha {
    if (!_textFieldCaptcha) {
        _textFieldCaptcha = [[UITextField alloc] init];
        _textFieldCaptcha.placeholder = @"请输入旧密码";
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

- (UITextField *)textFieldConfirm {
    if (!_textFieldConfirm) {
        _textFieldConfirm = [[UITextField alloc] init];
        _textFieldConfirm.placeholder = @"请确认密码";
        _textFieldConfirm.secureTextEntry = YES;
    }
    return _textFieldConfirm;
}

- (UIButton *)roleArrowButton {
    if (!_roleArrowButton) {
        _roleArrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_roleArrowButton setImage:[UIImage imageNamed:@"下箭头"] forState:UIControlStateNormal];
        [_roleArrowButton addTarget:self action:@selector(didTouchRoleArrowButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _roleArrowButton;
}

- (UIButton *)resetButton {
    if (!_resetButton) {
        _resetButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_resetButton setTitle:@"修改密码" forState:UIControlStateNormal];
        [_resetButton setTitleColor:[UIColor colorWithHex:@"#ffffff"] forState:UIControlStateNormal];
        [_resetButton setTitleColor:[UIColor colorWithHex:@"#ffffff"] forState:UIControlStateHighlighted];
        [_resetButton setBackgroundColor:[UIColor colorWithHex:@"#ff6867"]];
        _resetButton.layer.cornerRadius = 3;
        _resetButton.layer.masksToBounds = YES;
        [_resetButton addTarget:self action:@selector(didTouchResetButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resetButton;
}

- (UIView *)line1 {
    if (!_line1) {
        _line1 = [[UIView alloc] init];
        _line1.backgroundColor = [UIColor colorWithHex:@"#e1e1e1"];
    }
    return _line1;
}

- (UIView *)line2 {
    if (!_line2) {
        _line2 = [[UIView alloc] init];
        _line2.backgroundColor = [UIColor colorWithHex:@"#e1e1e1"];
    }
    return _line2;
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

@end
