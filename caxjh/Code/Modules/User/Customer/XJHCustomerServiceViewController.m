//
//  XJHCustomerServiceViewController.m
//  caxjh
//
//  Created by Yingchao Zou on 03/09/2017.
//  Copyright © 2017 Yingchao Zou. All rights reserved.
//

#import "XJHCustomerServiceViewController.h"
#import "XJHCallView.h"

@interface XJHCustomerServiceViewController ()

<
XJHCallViewDelegate
>

@property (nonatomic, readwrite, strong) UIImageView *theImageView;
@property (nonatomic, readwrite, strong) UILabel *theLabel;
@property (nonatomic, readwrite, strong) XJHCallView *callView;

@end

@implementation XJHCustomerServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"客服";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setStatusBarDefaultColor];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem uc_backBarButtonItemWithAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [self.view addSubview:self.theImageView];
    [self.view addSubview:self.theLabel];
    [self.view addSubview:self.callView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.theImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@100);
        make.height.equalTo(@60);
        make.top.equalTo(self.view).with.offset(50);
        make.centerX.equalTo(self.view);
    }];
    
    [self.theLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.theImageView.mas_bottom).with.offset(20);
    }];
    
    [self.callView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@170);
        make.height.equalTo(@35);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.theLabel.mas_bottom).with.offset(20);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// XJHCallViewDelegate

- (void)didTouchCallView:(XJHCallView *)callView {
    NSString *phoneNumber = [@"tel://" stringByAppendingString:@"010-6938-3422"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UIImageView *)theImageView {
    if (!_theImageView) {
        _theImageView = [[UIImageView alloc] init];
        _theImageView.image = [UIImage imageNamed:@"客服中心"];
    }
    return _theImageView;
}

- (UILabel *)theLabel {
    if (!_theLabel) {
        _theLabel = [[UILabel alloc] init];
        _theLabel.text = @"儿童安全系统服务中心";
    }
    return _theLabel;
}

- (XJHCallView *)callView {
    if (!_callView) {
        _callView = [[XJHCallView alloc] init];
        _callView.delegate = self;
    }
    return _callView;
}

@end
