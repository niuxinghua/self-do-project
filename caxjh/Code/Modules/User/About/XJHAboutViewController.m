//
//  XJHAboutViewController.m
//  caxjh
//
//  Created by Yingchao Zou on 03/09/2017.
//  Copyright © 2017 Yingchao Zou. All rights reserved.
//

#import "XJHAboutViewController.h"

@interface XJHAboutViewController ()

@property (nonatomic, readwrite, strong) UIImageView *imageView;
@property (nonatomic, readwrite, strong) UILabel *versionLabel;

@property (nonatomic, readwrite, strong) UIWebView *contentWebView;

@property (nonatomic, readwrite, strong) UILabel *bottomLabel1;
@property (nonatomic, readwrite, strong) UILabel *bottomLabel2;

@end

@implementation XJHAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"关于我们";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem uc_backBarButtonItemWithAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    self.view.backgroundColor = [UIColor colorWithHex:@"#ffffff"];
    
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.versionLabel];
    
    [self.view addSubview:self.contentWebView];
    
    [self.view addSubview:self.bottomLabel1];
    [self.view addSubview:self.bottomLabel2];
    
    NSDictionary *dictionary = @{
                                 @"table" : @"KvConfig",
                                 @"order" : @{@"createTime" : @"desc"},
                                 @"id" : @"",
                                 @"fields" : @{},
                                 @"columns" : @[@"detail"],
                                 @"filter" : @{@"name" : @{@"eq" : @"App简介"}}
                                 };
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerJSON];
    [PPNetworkHelper POST:kAPIQueryUrl parameters:dictionary success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([[responseObject objectForKey:@"type"] isEqualToString:@"success"]) {
            NSString *detail = [[responseObject objectForKey:@"data"][0] objectForKey:@"detail"];
            [self.contentWebView loadHTMLString:detail baseURL:nil];
        } else {
            // 提示
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    
    // 获取App的版本号
    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    _versionLabel.text = [NSString stringWithFormat:@"版本 %@",appVersion];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(35);
        make.width.equalTo(@150);
        make.height.equalTo(@50);
    }];
    
    [self.versionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.imageView.mas_bottom).with.offset(15);
    }];
    
    [self.contentWebView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(15);
        make.right.equalTo(self.view).with.offset(-15);
        make.top.equalTo(self.versionLabel.mas_bottom).with.offset(30);
        make.bottom.equalTo(self.bottomLabel1.mas_top).with.offset(-30);
    }];

    [self.bottomLabel1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.bottomLabel2.mas_top).with.offset(-5);
    }];
    
    [self.bottomLabel2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-20);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.image = [UIImage imageNamed:@"关于我们-logo"];
    }
    return _imageView;
}

- (UILabel *)versionLabel {
    if (!_versionLabel) {
        _versionLabel = [[UILabel alloc] init];
       // _versionLabel.text = @"版本 V1.0.0";
        _versionLabel.textAlignment = NSTextAlignmentCenter;
        _versionLabel.textColor = [UIColor colorWithHex:@"#ff6767"];
        _versionLabel.font = [UIFont systemFontOfSize:12.0];
    }
    return _versionLabel;
}

- (UIWebView *)contentWebView {
    if (!_contentWebView) {
        _contentWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
        _contentWebView.scrollView.bounces = NO;
        _contentWebView.scrollView.showsVerticalScrollIndicator = NO;
        _contentWebView.scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _contentWebView;
}

- (UILabel *)bottomLabel1 {
    if (!_bottomLabel1) {
        _bottomLabel1 = [[UILabel alloc] init];
        _bottomLabel1.text = @"Copyright © 2017";
        _bottomLabel1.textAlignment = NSTextAlignmentCenter;
        _bottomLabel1.textColor = [UIColor colorWithHex:@"#aaaaaa"];
        _bottomLabel1.font = [UIFont systemFontOfSize:12.0];
    }
    return _bottomLabel1;
}

- (UILabel *)bottomLabel2 {
    if (!_bottomLabel2) {
        _bottomLabel2 = [[UILabel alloc] init];
        _bottomLabel2.text = @"北京诚安天下网络技术股份有限公司";
        _bottomLabel2.textAlignment = NSTextAlignmentCenter;
        _bottomLabel2.textColor = [UIColor colorWithHex:@"#aaaaaa"];
        _bottomLabel2.font = [UIFont systemFontOfSize:12.0];
    }
    return _bottomLabel2;
}

@end
