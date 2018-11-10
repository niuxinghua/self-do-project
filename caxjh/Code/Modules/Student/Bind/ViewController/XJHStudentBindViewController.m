//
//  XJHStudentBindViewController.m
//  caxjh
//
//  Created by Yingchao Zou on 30/08/2017.
//  Copyright © 2017 Yingchao Zou. All rights reserved.
//

#import "XJHStudentBindViewController.h"
#import "XJHCallView.h"
#import "XJHUserIndexViewController.h"
#import "XJHStudentCardScanViewController.h"
#import "XJHLoginResponse.h"

@interface XJHStudentBindViewController ()

<
XJHCallViewDelegate,
UITextFieldDelegate,
XJHStudentCardScanViewControllerDelegate
>

@property (nonatomic, readwrite, strong) UILabel *hintLabel;
@property (nonatomic, readwrite, strong) UITextField *textField;
@property (nonatomic, readwrite, strong) UIButton *scanButton;
@property (nonatomic, readwrite, strong) UIButton *theButton;

@property (nonatomic, readwrite, strong) UIView *lineView;

@property (nonatomic, readwrite, strong) UILabel *bottomLabel;
@property (nonatomic, readwrite, strong) XJHCallView *callView;

@end

@implementation XJHStudentBindViewController

#pragma mark - 回到 我的界面

- (void)tryNavigateToUserIndexViewController {
    BOOL foundUserIndex = NO;
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[XJHUserIndexViewController class]]) {
            foundUserIndex = YES;
            [self.navigationController popToViewController:viewController animated:YES];
        }
    }
    
    if (!foundUserIndex) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"学生绑定";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem uc_backBarButtonItemWithAction:^{
        [self tryNavigateToUserIndexViewController];
    }];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.hintLabel];
    [self.view addSubview:self.textField];
    [self.view addSubview:self.scanButton];
    [self.view addSubview:self.lineView];
    [self.view addSubview:self.theButton];
    [self.view addSubview:self.bottomLabel];
    [self.view addSubview:self.callView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.hintLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(15);
        make.centerY.equalTo(self.textField);
    }];
    
    [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@50);
        make.top.equalTo(self.view);
        make.right.equalTo(self.view).with.offset(-60);
        make.left.equalTo(self.hintLabel.mas_right).with.offset(15);
    }];
    
    [self.scanButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).with.offset(-15);
        make.centerY.equalTo(self.textField);
        make.width.height.equalTo(@20);
    }];
    
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textField.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@1);
    }];
    
    [self.theButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textField.mas_bottom).with.offset(30);
        make.height.equalTo(@50);
        make.left.equalTo(self.view).with.offset(25);
        make.right.equalTo(self.view).with.offset(-25);
    }];
    
    [self.bottomLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.callView.mas_top).with.offset(-20);
    }];
    
    [self.callView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-30);
        make.width.equalTo(@170);
        make.height.equalTo(@35);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didTouchScanButton {
    XJHStudentCardScanViewController *scanViewController = [[XJHStudentCardScanViewController alloc] init];
    scanViewController.delegate = self;
    [self.navigationController pushViewController:scanViewController animated:YES];
}

- (void)didTouchConfirmButton {
    
    if (self.textField.text.length == 0) {
        return ;
    }
    
    NSString *userID = [[NSUserDefaults standardUserDefaults] stringForKey:@"USER_ID"];
    NSDictionary *dictionary = @{
                                 @"identificationId" : self.textField.text,
                                 @"userId" : userID,
                                 @"action" : @"bind",
                                 @"platform":@"ios"
                                 };
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerJSON];
    [PPNetworkHelper POST:kAPIQRURL parameters:dictionary success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        XJHLoginResponse *loginResponse = [XJHLoginResponse mj_objectWithKeyValues:responseObject];
        
        if ([loginResponse.type isEqualToString:@"success"]) {
            [self.view makeToast:loginResponse.content duration:1.0 position:CSToastPositionTop];
            [self tryNavigateToUserIndexViewController];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshdevice" object:nil];
        } else {
            [self.view makeToast:loginResponse.content duration:1.0 position:CSToastPositionTop];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

// XJHCallViewDelegate

- (void)didTouchCallView:(XJHCallView *)callView {
    NSString *phoneNumber = [@"tel://" stringByAppendingString:@"010-6938-3422"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}

// UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.textField) {
        return YES; // 改
    }
    return YES;
}

#pragma mark - XJHStudentCardScanViewControllerDelegate

- (void)finishScanWithText:(NSString *)text {
    
    // http://www.baidu.com?studentId=124124&service=13330094415
    
    NSArray *array = [text componentsSeparatedByString:@"&"];
    if (array.count != 2) {
        return ;
    }
    
    NSString *firstPart = array[0];
    NSArray *anotherArray = [firstPart componentsSeparatedByString:@"studentId="];
    if (anotherArray.count != 2) {
        return ;
    }
    
    self.textField.text = anotherArray[1];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UILabel *)hintLabel {
    if (!_hintLabel) {
        _hintLabel = [[UILabel alloc] init];
        _hintLabel.text = @"";
    }
    return _hintLabel;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.placeholder = @"输入身份证号或扫描安全卡";
        _textField.delegate = self;
    }
    return _textField;
}

- (UIButton *)scanButton {
    if (!_scanButton) {
        _scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_scanButton setBackgroundImage:[UIImage imageNamed:@"扫描"] forState:UIControlStateNormal];
        [_scanButton addTarget:self action:@selector(didTouchScanButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _scanButton;
}

- (UIButton *)theButton {
    if (!_theButton) {
        _theButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_theButton setTitle:@"确认绑定" forState:UIControlStateNormal];
        [_theButton setTitleColor:[UIColor colorWithHex:@"#ffffff"] forState:UIControlStateNormal];
        [_theButton setTitleColor:[UIColor colorWithHex:@"#ffffff"] forState:UIControlStateHighlighted];
        [_theButton setBackgroundColor:[UIColor colorWithHex:@"#ff6867"]];
        _theButton.layer.cornerRadius = 3;
        _theButton.layer.masksToBounds = YES;
        [_theButton addTarget:self action:@selector(didTouchConfirmButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _theButton;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHex:@"#e1e1e1"];
    }
    return _lineView;
}

- (UILabel *)bottomLabel {
    if (!_bottomLabel) {
        _bottomLabel = [[UILabel alloc] init];
        _bottomLabel.textColor = [UIColor colorWithHex:@"#333333"];
        _bottomLabel.text = @"儿童安全系统服务中心";
    }
    return _bottomLabel;
}

- (XJHCallView *)callView {
    if (!_callView) {
        _callView = [[XJHCallView alloc] init];
        _callView.delegate = self;
    }
    return _callView;
}

@end
