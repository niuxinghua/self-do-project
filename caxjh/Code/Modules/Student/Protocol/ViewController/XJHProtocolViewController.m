//
//  XJHProtocolViewController.m
//  caxjh
//
//  Created by Yingchao Zou on 04/09/2017.
//  Copyright © 2017 Yingchao Zou. All rights reserved.
//

#import "XJHProtocolViewController.h"
#import "XJHStudentBindViewController.h"

@interface XJHProtocolViewController ()

@property (nonatomic, readwrite, strong) UIWebView *webView;

@property (nonatomic, readwrite, strong) UIView *bottomContainer;
@property (nonatomic, readwrite, strong) UIView *lineView;
@property (nonatomic, readwrite, strong) UIButton *agreeButton;
@property (nonatomic, readwrite, strong) UILabel *hintLabel;
@property (nonatomic, readwrite, strong) UIButton *nextButton;

@end

@implementation XJHProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"免责声明";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem uc_backBarButtonItemWithAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [self.view addSubview:self.webView];
    [self.view addSubview:self.bottomContainer];
    
    [self.bottomContainer addSubview:self.lineView];
    [self.bottomContainer addSubview:self.agreeButton];
    [self.bottomContainer addSubview:self.hintLabel];
    [self.bottomContainer addSubview:self.nextButton];
    
    if (self.agreeButton.selected) {
        self.nextButton.enabled = YES;
    } else {
        self.nextButton.enabled = NO;
    }
    
    
    [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.bottomContainer.mas_top);
    }];
    
    [self.bottomContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomContainer.mas_top);
        make.left.right.equalTo(self.bottomContainer);
        make.height.equalTo(@1);
    }];
    
    [self.agreeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomContainer);
        make.left.equalTo(self.bottomContainer.mas_left).with.offset(15);
        make.width.height.equalTo(@15);
    }];
    
    [self.hintLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.agreeButton.mas_right).with.offset(10);
        make.centerY.equalTo(self.bottomContainer);
    }];
    
    [self.nextButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@120);
        make.top.bottom.equalTo(self.bottomContainer);
        make.right.equalTo(self.bottomContainer.mas_right);
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    

    
    [self getProtocol];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getProtocol {
    
    NSDictionary *dictionary = @{
                                 @"columns" : @[@"id", @"name", @"detail"],
                                 @"order" : @{},
                                 @"filter" : @{@"name" : @{@"eq" : @"agreements"}},
                                 @"table" : @"KvConfig"
                                 };
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerJSON];
    [PPNetworkHelper POST:kAPIQueryUrl parameters:dictionary success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([[responseObject objectForKey:@"type"] isEqualToString:@"success"]) {
            NSString *detail = [[responseObject objectForKey:@"data"][0] objectForKey:@"detail"];
            [self.webView loadHTMLString:detail baseURL:nil];
        } else {
            // 提示
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)didTouchAgreeButton {
    self.agreeButton.selected = !self.agreeButton.selected;
    
    if (self.agreeButton.selected) {
        self.nextButton.enabled = YES;
    } else {
        self.nextButton.enabled = NO;
    }
}

- (void)didTouchNextButton {
    
    // 额外的校验
    if (self.agreeButton.selected) {
        NSString *userID = [[NSUserDefaults standardUserDefaults] stringForKey:@"USER_ID"];
        NSString *key = [userID stringByAppendingString:@"_PROTOCOL_ED"];
        [[NSUserDefaults standardUserDefaults] setObject:@"ALREADY" forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    XJHStudentBindViewController *studentBindViewController = [[XJHStudentBindViewController alloc] init];
    [self.navigationController pushViewController:studentBindViewController animated:YES];
}

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    return _webView;
}

- (UIView *)bottomContainer {
    if (!_bottomContainer) {
        _bottomContainer = [[UIView alloc] init];
        _bottomContainer.backgroundColor = [UIColor whiteColor];
    }
    return _bottomContainer;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHex:@"#e1e1e1"];
    }
    return _lineView;
}

- (UIButton *)agreeButton {
    if (!_agreeButton) {
        _agreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_agreeButton setBackgroundImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
        [_agreeButton setBackgroundImage:[UIImage imageNamed:@"选中"] forState:UIControlStateSelected];
        [_agreeButton addTarget:self action:@selector(didTouchAgreeButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _agreeButton;
}

- (UILabel *)hintLabel {
    if (!_hintLabel) {
        _hintLabel = [[UILabel alloc] init];
        _hintLabel.text = @"阅读并同意";
    }
    return _hintLabel;
}

- (UIButton *)nextButton {
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_nextButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:@"#ff6867"]] forState:UIControlStateNormal];
        [_nextButton setBackgroundImage:[UIImage imageWithColor:[[UIColor colorWithHex:@"#ff6867"] darken:0.2]] forState:UIControlStateHighlighted];
        [_nextButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:@"#6b6b6b"]] forState:UIControlStateDisabled];
        [_nextButton addTarget:self action:@selector(didTouchNextButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextButton;
}

@end
