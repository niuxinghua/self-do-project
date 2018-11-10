//
//  XJHUserIndexViewController.m
//  caxjh
//
//  Created by Yingchao Zou on 30/08/2017.
//  Copyright © 2017 Yingchao Zou. All rights reserved.
//

#import "XJHUserIndexViewController.h"
#import "XJHUserIndexTableViewCell.h"
#import "XJHUserStuffViewController.h"
#import "XJHSettingViewController.h"
#import "XJHCustomerServiceViewController.h"
#import "XJHOrderListViewController.h"
#import "XJHAboutViewController.h"
#import "XJHStudentBindViewController.h"
#import "Order.h"
#import "XJHMyOrderViewController.h"
#import "XJHProtocolViewController.h"
#import "UIImageView+WebCache.h"

@interface XJHUserIndexViewController ()

<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, readwrite, strong) UIView *topView;
@property (nonatomic, readwrite, strong) UITableView *tableView;

@property (nonatomic, readwrite, strong) UIImageView *avatarImageView;
@property (nonatomic, readwrite, strong) UILabel *nameLabel;
@property (nonatomic, readwrite, strong) UILabel *phoneLabel;
@property (nonatomic, readwrite, strong) UIImageView *arrowImageView;

@property (nonatomic, readwrite, copy) NSString *userName;
@property (nonatomic, readwrite, copy) NSString *address;
@property (nonatomic, readwrite, copy) NSString *avatar;

@property (nonatomic, readwrite, assign) BOOL finishGetStuff;

@end

@implementation XJHUserIndexViewController

- (void)setUpRightBarItem
{
    UIButton*rightButton = [[UIButton  alloc]initWithFrame:CGRectMake(0,0,30,30)];
    [rightButton setImage:[UIImage imageNamed:@"设置"]forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(gotoSetting)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    
}

- (void)gotoSetting {
    XJHSettingViewController *viewController = [[XJHSettingViewController alloc] init];
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.finishGetStuff = NO;
    
    self.title = @"我的";
    [self setUpRightBarItem];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setStatusBarDefaultColor];
    
    [self.view addSubview:self.topView];
    [self.view addSubview:self.tableView];
    
    [self.topView addSubview:self.avatarImageView];
    [self.topView addSubview:self.nameLabel];
    [self.topView addSubview:self.phoneLabel];
    [self.topView addSubview:self.arrowImageView];
    
    NSString *phone = [[NSUserDefaults standardUserDefaults] stringForKey:@"USER_DATA_PHONE"];
    NSString *loginName = [[NSUserDefaults standardUserDefaults] stringForKey:@"USER_DATA_LOGINNAME"];
    
    if (phone.length > 0) {
        self.phoneLabel.text = phone;
    }
    
    else if (loginName.length > 0) {
        self.phoneLabel.text = loginName;
    }
    
#ifdef DEBUG
    UILongPressGestureRecognizer *r = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPress:)];
    r.minimumPressDuration = 2.0;
    [self.view addGestureRecognizer:r];
#endif
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reGetUserStuff) name:@"NEED_REGET_USER_STUFF" object:nil];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)reGetUserStuff {
    self.finishGetStuff = NO;
}

- (void)didLongPress:(UILongPressGestureRecognizer *)r {
#ifdef DEBUG
    
#endif
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@120);
    }];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.topView.mas_bottom);
    }];
    
    [self.avatarImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@60);
        make.left.equalTo(self.topView).with.offset(30);
        make.centerY.equalTo(self.topView);
    }];
    
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImageView.mas_right).with.offset(15);
        make.bottom.equalTo(self.avatarImageView.mas_centerY).with.offset(-5);
    }];
    
    [self.phoneLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImageView.mas_right).with.offset(15);
        make.top.equalTo(self.avatarImageView.mas_centerY).with.offset(5);
    }];
    
    [self.arrowImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView);
        make.right.equalTo(self.topView).with.offset(-15);
        make.width.height.equalTo(@25);
    }];
    
    [self getUserStuff];
}

- (void)getUserStuff {
    
    if (self.finishGetStuff) {
        return ;
    }
    
    NSString *userID = [[NSUserDefaults standardUserDefaults] stringForKey:@"USER_ID"];
    
    NSDictionary *dictionary = @{
                                 @"columns" : @[@"id", @"avatar", @"name", @"address"],
                                 @"order" : @{},
                                 @"filter" : @{@"id" : @{@"eq" : userID}},
                                 @"table" : @"Member"
                                 };
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerJSON];
    [PPNetworkHelper POST:kAPIQueryUrl parameters:dictionary success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        self.finishGetStuff = YES;
        
        NSArray *array = [responseObject objectForKey:@"data"];
        
        if ([array isEqual:[NSNull null]]) {
            return ;
        }
        
        if (array.count == 0) {
            return ;
        }
        
        NSString *address = [responseObject objectForKey:@"data"][0][@"address"];
        NSString *name = [responseObject objectForKey:@"data"][0][@"name"];
        NSString *avatar = [responseObject objectForKey:@"data"][0][@"avatar"];
        
        NSLog(@"%@", address);
        NSLog(@"%@", name);
        NSLog(@"%@", avatar);
        
        self.address = address;
        self.userName = name;
        self.avatar = avatar;

        if (![name isEqual:[NSNull null]]) {
            self.nameLabel.text = name;
        }
        
        if (![avatar isEqual:[NSNull null]]) {
            [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:[UIImage imageNamed:@"默认头像"]];
        }

    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didTouchMyInfo {
    XJHUserStuffViewController *viewController = [[XJHUserStuffViewController alloc] init];
    viewController.address = self.address;
    viewController.userName = self.userName;
    viewController.avatar = self.avatar;
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
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

- (BOOL)isParent {
    
    // 0老师 1家长 2学生
    
    NSString *userDataType = [[NSUserDefaults standardUserDefaults] stringForKey:@"USER_DATA_TYPE"];
    if ([userDataType isEqualToString:@"1"]) {
        return YES;
    }
    
    else if ([userDataType isEqualToString:@"0"] || [userDataType isEqualToString:@"2"]) {
        return NO;
    }
    
    // 如果是家长
    // 如果是学生或者老师 学生绑定 我的套餐 我的订单 需要隐藏
    
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return 10;
    }
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if ([self isParent]) {
        // return 2;
        // 隐藏套餐
        return 1;
    }
    
    else {
        return 1;
    }
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // 如果是家长 用原来的
    // 如果是学生或者老师 学生绑定 我的套餐 我的订单 需要隐藏
    if ([self isParent]) {
//        if (section == 0) {
//            return 1;
//        }
//
//        else if (section == 1) {
//            return 3;
//        }
        if (section == 0) {
            return 3;
        }
    }
    
    else {
        if (section == 0) {
            return 2;
        }
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XJHUserIndexTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XJHUserIndexTableViewCell"];
    if (!cell) {
        cell = [[XJHUserIndexTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XJHUserIndexTableViewCell"];
    }
    
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    
    if ([self isParent]) {
//        if (section == 0) {
//             if (row == 0) {
//                cell.theImageView.image = [UIImage imageNamed:@"我的套餐"];
//                cell.theLabel.text = @"我的套餐";
//            }
//        }
//
//        else if (section == 1) {
//            if (row == 0) {
//                cell.theImageView.image = [UIImage imageNamed:@"学生绑定"];
//                cell.theLabel.text = @"学生绑定";
//            }
//
//            else if (row == 1) {
//                cell.theImageView.image = [UIImage imageNamed:@"客服"];
//                cell.theLabel.text = @"客服";
//            }
//
//            else if (row == 2) {
//                cell.theImageView.image = [UIImage imageNamed:@"关于我们"];
//                cell.theLabel.text = @"关于我们";
//            }
//        }
        if (section == 0) {
            if (row == 0) {
                cell.theImageView.image = [UIImage imageNamed:@"学生绑定"];
                cell.theLabel.text = @"学生绑定";
            }

            else if (row == 1) {
                cell.theImageView.image = [UIImage imageNamed:@"客服"];
                cell.theLabel.text = @"客服";
            }

            else if (row == 2) {
                cell.theImageView.image = [UIImage imageNamed:@"关于我们"];
                cell.theLabel.text = @"关于我们";
            }
        }
    }
    
    else {
        if (section == 0) {
            if (row == 0) {
                cell.theImageView.image = [UIImage imageNamed:@"客服"];
                cell.theLabel.text = @"客服";
            }
            
            else if (row == 1) {
                cell.theImageView.image = [UIImage imageNamed:@"关于我们"];
                cell.theLabel.text = @"关于我们";
            }
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    
    if ([self isParent]) {
//        if (section == 0) {
//            if (row == 0) {
//                // 套餐
//                XJHOrderListViewController *order = [[XJHOrderListViewController alloc]init];
//                order.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:order animated:NO];
//            }
//        }
        
        if (section == 0) {
            if (row == 0) {
                
                NSString *userID = [[NSUserDefaults standardUserDefaults] stringForKey:@"USER_ID"];
                NSString *key = [userID stringByAppendingString:@"_PROTOCOL_ED"];
                NSString *value = [[NSUserDefaults standardUserDefaults] stringForKey:key];
                
                if ([value isEqual:[NSNull null]] || value.length == 0) {
                    // 免责声明
                    XJHProtocolViewController *viewController = [[XJHProtocolViewController alloc] init];
                    viewController.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:viewController animated:YES];
                }
                
                else {
                    // 学生绑定
                    XJHStudentBindViewController *viewController = [[XJHStudentBindViewController alloc] init];
                    viewController.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:viewController animated:YES];
                }
                
            }
            
            else if (row == 1) {
                // 客服
                XJHCustomerServiceViewController *viewController = [[XJHCustomerServiceViewController alloc] init];
                viewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:viewController animated:YES];
            }
            
            else if (row == 2) {
                // 关于我们
                XJHAboutViewController *viewController = [[XJHAboutViewController alloc] init];
                viewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:viewController animated:YES];
            }
        }
    }
    
    else {
        if (row == 0) {
            // 客服
            XJHCustomerServiceViewController *viewController = [[XJHCustomerServiceViewController alloc] init];
            viewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:viewController animated:YES];
        }
        
        else if (row == 1) {
            // 关于我们
            XJHAboutViewController *viewController = [[XJHAboutViewController alloc] init];
            viewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
    
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = [UIColor colorWithHex:@"#fe6766"];
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouchMyInfo)];
        [_topView addGestureRecognizer:recognizer];
    }
    return _topView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor colorWithHex:@"#fafafa"];
    }
    return _tableView;
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.layer.cornerRadius = 30;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.layer.borderColor = [UIColor colorWithHex:@"#ffffff"].CGColor;
        _avatarImageView.layer.borderWidth = 1;
        _avatarImageView.image = [UIImage imageNamed:@"默认头像"];
    }
    return _avatarImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor colorWithHex:@"#ffffff"];
        _nameLabel.font = [UIFont systemFontOfSize:16.0];
    }
    return _nameLabel;
}

- (UILabel *)phoneLabel {
    if (!_phoneLabel) {
        _phoneLabel = [[UILabel alloc] init];
        _phoneLabel.textColor = [UIColor colorWithHex:@"#ffffff"];
        _phoneLabel.font = [UIFont systemFontOfSize:14.0];
    }
    return _phoneLabel;
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.image = [UIImage imageNamed:@"右箭头-灰"];
    }
    return _arrowImageView;
}

@end
