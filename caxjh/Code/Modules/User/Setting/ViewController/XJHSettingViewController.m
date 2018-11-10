//
//  XJHSettingViewController.m
//  caxjh
//
//  Created by Yingchao Zou on 30/08/2017.
//  Copyright © 2017 Yingchao Zou. All rights reserved.
//

#import "XJHSettingViewController.h"
#import "AppDelegate.h"
#import "XJHChangePasswordViewController.h"

@interface XJHSettingViewController ()

<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, readwrite, strong) UITableView *tableView;
@property (nonatomic, readwrite, strong) UIButton *logoutButton;

@end

@implementation XJHSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"设置";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem uc_backBarButtonItemWithAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [self setStatusBarDefaultColor];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.logoutButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    
    [self.logoutButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom).with.offset(30);
        make.height.equalTo(@50);
        make.left.equalTo(self.view).with.offset(25);
        make.right.equalTo(self.view).with.offset(-25);
    }];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//

- (void)didTouchlogoutButton {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"您是否要退出?" preferredStyle:UIAlertControllerStyleAlert];
    alert.popoverPresentationController.sourceView = self.view;
    alert.popoverPresentationController.sourceRect = CGRectMake(0, 0, 1.0, 1.0);
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTIFICATION_SHOULD_LOGOUT" object:nil];
    }];
    [alert addAction:confirmAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// UITableViewDelegate

// UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    cell.textLabel.text = @"修改密码";
    cell.textLabel.textColor = [UIColor colorWithHex:@"#333333"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    
    if (section == 0) {
        if (row == 0) {
            XJHChangePasswordViewController *viewController = [[XJHChangePasswordViewController alloc] init];
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        // http://www.cocoachina.com/bbs/read.php?tid=1725888
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor colorWithHex:@"#fafafa"];
    }
    return _tableView;
}

- (UIButton *)logoutButton {
    if (!_logoutButton) {
        _logoutButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_logoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
        [_logoutButton setTitleColor:[UIColor colorWithHex:@"#ffffff"] forState:UIControlStateNormal];
        [_logoutButton setTitleColor:[UIColor colorWithHex:@"#ffffff"] forState:UIControlStateHighlighted];
        [_logoutButton setBackgroundColor:[UIColor colorWithHex:@"#ff6867"]];
        _logoutButton.layer.cornerRadius = 3;
        _logoutButton.layer.masksToBounds = YES;
        [_logoutButton addTarget:self action:@selector(didTouchlogoutButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _logoutButton;
}

@end
