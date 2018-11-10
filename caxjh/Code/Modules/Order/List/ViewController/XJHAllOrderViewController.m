//
//  XJHAllOrderViewController.m
//  caxjh
//
//  Created by niuxinghua on 2017/9/3.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import "XJHAllOrderViewController.h"
#import "UIViewController+StatusBar.h"
#import "AllOrderTableViewCell.h"
#import "UIBarButtonItem+UC.h"
#import "Const.h"
#import "UIColor+EAHexColor.h"
#import "MBProgressHUD.h"
#import "PPNetworkHelper.h"
#import "UIView+Toast.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "XJHWechatSign.h"
#import "MJExtension.h"
#import "XJHPayMethodView.h"
#import "XJHUserStuffViewController.h"
#import "XJHOrderObject.h"

@interface XJHAllOrderViewController ()<UITableViewDelegate,UITableViewDataSource, XJHPayMethodViewDelegate>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *datalist;
@property (nonatomic,strong)NSMutableDictionary *selectIndexlist;
@property (nonatomic,strong)NSMutableDictionary *selectParentlist;
@property (nonatomic,assign)float totalPrice;

@property (nonatomic,strong)UILabel *totalPriceLable;
@property (nonatomic,strong)UIButton *commitButton;
@property (nonatomic,strong)UIButton *studentTextfield;
@property (nonatomic,strong)UIButton *arrowButton;
@property (nonatomic,strong)AllOrderTableViewCell *currentCell;

@property (nonatomic, readwrite, copy) NSString *lastID; // 最后一次成功创建订单的时候返回的id 用来填到payCode里
@property (nonatomic, readwrite, assign) float payablePrice; // 最后一次成功创建订单的时候返回的价格

@property (nonatomic, readwrite, strong) UIView *payMethodViewBackgroundView;
@property (nonatomic, readwrite, strong) XJHPayMethodView *payMethodView;

@property (nonatomic,strong)NSMutableArray *studentList;

@property (nonatomic,strong)NSMutableArray *applyParentList;//分配的家长数组
@property (nonatomic,copy)NSString *selectedStudentId;
@property (nonatomic,copy)NSDictionary *selectedStudentSchoolType;

@property (nonatomic, readwrite, copy) NSString *address;
@property (nonatomic, readwrite, copy) NSString *nickname;
@property (nonatomic, readwrite, copy) NSString *avatar;

@end

@implementation XJHAllOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"全部套餐";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setStatusBarDefaultColor];
    _tableView = [[UITableView alloc]init];
    _datalist = [[NSMutableArray alloc]init];
    _selectIndexlist = [[NSMutableDictionary alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    _studentTextfield = [[UIButton alloc]initWithFrame:CGRectMake(20, 5, self.view.frame.size.width - 40, 30)];
    [self.view addSubview:_studentTextfield];
    _studentTextfield.backgroundColor = [UIColor whiteColor];
    _studentTextfield.layer.borderWidth = 0.5;
    _studentTextfield.layer.borderColor = [UIColor grayColor].CGColor;
    _studentTextfield.layer.cornerRadius = 5;
    _studentTextfield.layer.masksToBounds = YES;
    [_studentTextfield setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    // _studentTextfield.userInteractionEnabled = NO;
    _arrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_arrowButton setImage:[UIImage imageNamed:@"下箭头"] forState:UIControlStateNormal];
    _arrowButton.frame = CGRectMake(self.view.frame.size.width/2.0 + 40, 5, 30, 30);
    [_studentTextfield addTarget:self action:@selector(didTouchArrowButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_arrowButton];
    _arrowButton.userInteractionEnabled = NO;
    _arrowButton.hidden = YES;
    _tableView.frame = CGRectMake(0, 35, self.view.frame.size.width, self.view.frame.size.height - 64 - 50 - 35);
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [UIView new];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[AllOrderTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem uc_backBarButtonItemWithAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self getBindStudent];
    _totalPriceLable = [[UILabel alloc]initWithFrame:CGRectMake(30, [UIScreen mainScreen].bounds.size.height-50-64, self.view.frame.size.width - 120-30, 50)];
    [self.view addSubview:_totalPriceLable];
    _totalPriceLable.font = [UIFont systemFontOfSize:15];
    _totalPriceLable.text = [NSString stringWithFormat:@"合计:%.1f元",_totalPrice];
    _totalPriceLable.textColor = [UIColor colorWithHex:@"#333333"];
    // _totalPriceLable.backgroundColor = [UIColor blueColor];
    [self.view bringSubviewToFront:_totalPriceLable];
    
    _commitButton =[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-120, self.view.frame.size.height-50-64, 120, 50)];
    [self.view addSubview:_commitButton];
    [_commitButton setTitle:@"立即购买" forState:UIControlStateNormal];
    [_commitButton setBackgroundColor:[UIColor colorWithHex:@"#fe6768"]];
    [_commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_commitButton addTarget:self action:@selector(didTouchApplyOrder) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.payMethodViewBackgroundView];
    [self.view addSubview:self.payMethodView];
    
    [self.payMethodViewBackgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(CGRectGetHeight(self.view.bounds)));
        make.top.equalTo(self.view.mas_bottom);
    }];
    
    [self.payMethodView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@210);
        make.bottom.equalTo(self.view).with.offset(210);
    }];
}

-(void)didTouchArrowButton
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    alertController.popoverPresentationController.sourceView = self.view;
    alertController.popoverPresentationController.sourceRect = CGRectMake(0, 0, 1.0, 1.0);
    if ([_studentList isKindOfClass:[NSNull class]] || !_studentList.count) {
        return;
    }
    for(NSDictionary *dic in _studentList)
    {
        NSString *name = [dic objectForKey:@"name"];
        if ([name isKindOfClass:[NSNull class]]) {
            name = @"";
        }
        UIAlertAction *actionTeacher = [UIAlertAction actionWithTitle:name style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [_studentTextfield setTitle:[NSString stringWithFormat:@"%@   ",name] forState:UIControlStateNormal];
            // _studentTextfield.text = [NSString stringWithFormat:@"%@   ",[dic objectForKey:@"stuName"]];
            _selectedStudentId = [dic objectForKey:@"id"];
            _selectedStudentSchoolType = [dic objectForKey:@"school"];
            [self getData];
        }];
        [alertController addAction:actionTeacher];
        
    }
    [self.navigationController presentViewController:alertController animated:YES completion:^{
        
    }];
}
-(void)getBindStudent
{
    //    {"columns":["id","name",{"bindStudent":["id","name"]}],"order":{},"filter":{"id":{"eq":"000000005e40b718015e40c1c6210001"}},"table":"Member"}
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"USER_ID"];
    NSDictionary *dic =  @{@"columns":@[@"id",@"name",@{@"bindStudent":@[@"id",@"name",@{@"school":@[@"type"]}]}],@"order":@{},@"filter":@{@"id":@{@"eq":userId}},@"table":@"Member"};
    // NSDictionary *dic = @{@"userId":userId,@"packageEType":@"1"};
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerJSON];
    [PPNetworkHelper POST:kAPIQueryUrl parameters:dic success:^(id responseObject) {
        NSArray *dataArray = [responseObject objectForKey:@"data"];
        if (![dataArray isKindOfClass:[NSNull class]] && dataArray.count) {
            _studentList = [dataArray[0] objectForKey:@"bindStudent"];
        }
        // _studentList = [responseObject objectForKey:@"data"];
        if (![_studentList isKindOfClass:[NSNull class]] && _studentList.count) {
            if (_studentList.count > 1) {
                _arrowButton.hidden = NO;
            }
            if (_studentList.count > 0) {
                [self setStudentName];
            }
        }
           [self getData];
    } failure:^(NSError *error) {
        
    }];
    
    
}

-(void)setStudentName
{
    NSDictionary *dic = _studentList[0];
    //_studentTextfield.text = [dic objectForKey:@"stuName"];
    [_studentTextfield setTitle:[NSString stringWithFormat:@"%@   ",[dic objectForKey:@"name"]] forState:UIControlStateNormal];
    _selectedStudentId = [dic objectForKey:@"id"];
    _selectedStudentSchoolType = [dic objectForKey:@"school"];
}
//获取所有套餐
-(void)getData{
    NSDictionary *schoolType = _selectedStudentSchoolType;
    NSDictionary *dic;
    if (schoolType) {
        dic = @{
                @"table": @"Contract",
                @"filter": @{
                        @"gradeType":@{@"eq":[schoolType valueForKey:@"type"]},
                        @"state":@{@"in":@[@"onShelf",@"onlyIOS"]}
                        },
                @"order": @{
                        @"createTime": @"desc"
                        },
                @"columns": @[
                        @"id",
                        @"name",
                        @"gradeType",
                        @"contractType",
                        @"content",
                        @"state",
                        @{@"contractContractSpec":@[@"id",@"name",@"duration",@"price",@"memberCount"]}]
                };
        
    }else{
        dic =  @{
                 @"table": @"Contract",
                 @"filter": @{@"state":@{@"in":@[@"onShelf",@"onlyIOS"]}},
                 @"order": @{@"createTime": @"desc" },
                 @"columns": @[ @"id", @"name",@"gradeType",@"contractType", @"content",@"state",@{@"contractContractSpec":@[@"id",@"name",@"duration",@"price",@"memberCount"]}]};
    }
    NSLog(@"%@",kAPIQueryUrl);
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerJSON];
    [PPNetworkHelper POST:kAPIQueryUrl parameters:dic success:^(id responseObject) {
        _datalist = [responseObject objectForKey:@"data"];
        [_selectParentlist removeAllObjects];
        [_selectIndexlist removeAllObjects];
        _totalPrice = 0.0;
        _totalPriceLable.text = [NSString stringWithFormat:@"合计:%.2f元",_totalPrice];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = [_datalist objectAtIndex:[indexPath row]];
    NSArray *array  = [dic objectForKey:@"contractContractSpec"];
    
    return  [array count] * 30 + 60 + [self getLabelHeight:[dic objectForKey:@"content"]] + 80;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
#pragma mark-datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([_datalist isKindOfClass:[NSNull class]]) {
        return 0;
    }
    return [_datalist count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AllOrderTableViewCell *cell = [[AllOrderTableViewCell alloc]init];
    cell.block = ^(NSNumber *index,float price) {
        [_selectIndexlist setObject:index forKey:[NSString stringWithFormat:@"%zd",[indexPath row]]];
        _totalPrice += price;
        _totalPriceLable.text = [NSString stringWithFormat:@"合计:%.2f元",_totalPrice];
    };
    cell.deselectblock = ^(NSNumber *index,float price) {
        [_selectIndexlist removeObjectForKey:[NSString stringWithFormat:@"%zd",[indexPath row]]];
        _totalPrice -= price;
        _totalPriceLable.text = [NSString stringWithFormat:@"合计:%.2f元",_totalPrice];
    };
    cell.tapApply = ^{
        _currentCell = cell;
        [self getApplyView];
    };
    cell.deselectApply = ^(NSString *parentName) {
        NSMutableArray *array =  [_selectParentlist objectForKey:[NSString stringWithFormat:@"%zd",indexPath.row]];
        if ([array containsObject:parentName]) {
            [array removeObject:parentName];
            [_selectParentlist setObject:array forKey:[NSString stringWithFormat:@"%zd",indexPath.row]];
        }
    };
    NSMutableArray *selectedParentList = [_selectParentlist objectForKey:[NSString stringWithFormat:@"%zd",[indexPath row]]];
    if (selectedParentList) {
        [cell setSelectedParentList:selectedParentList];
    }
    cell.dic = [_datalist objectAtIndex:[indexPath row]];
    if ([_selectIndexlist objectForKey:[NSString stringWithFormat:@"%zd",[indexPath row]]]) {
        cell.selectedNum = [_selectIndexlist objectForKey:[NSString stringWithFormat:@"%zd",[indexPath row]]];
    }
    
    
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)getApplyView
{
    if (!_selectedStudentId) {
        return;
    }
    NSDictionary * dic = @{@"columns":@[@"name",@{@"bindStudentMember":@[@"id",@"name",@"phone"]}],@"filter":@{
                                   @"id":@{@"eq":_selectedStudentId}
                                   },@"table":@"Student"};
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerJSON];
    [PPNetworkHelper POST:kAPIQueryUrl parameters:dic success:^(id responseObject) {
        if (![[responseObject objectForKey:@"data"] isKindOfClass:[NSNull class]]) {
            _applyParentList = [responseObject objectForKey:@"data"];
            if (_applyParentList.count) {
                [self showParent];
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}
- (void)showParent
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    alertController.popoverPresentationController.sourceView = self.view;
    alertController.popoverPresentationController.sourceRect = CGRectMake(0, 0, 1.0, 1.0);
    if ([_applyParentList isKindOfClass:[NSNull class]] || !_applyParentList.count) {
        return;
    }
    NSDictionary *dic = _applyParentList[0];
    NSArray *array1 = [dic objectForKey:@"bindStudentMember"];
    for(NSDictionary *dic in array1)
    {
        
        NSString *phone = [dic objectForKey:@"phone"];
        NSString *name = [dic objectForKey:@"name"];
        if ([phone isKindOfClass:[NSNull class]]) {
            phone = @"";
        }
        if ([name isKindOfClass:[NSNull class]]) {
            name = @"";
        }
        NSString *phoneandname = [NSString stringWithFormat:@"%@%@",phone,name];

        UIAlertAction *actionTeacher = [UIAlertAction actionWithTitle:phoneandname style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [_currentCell reloadCellWith:phoneandname];
            if (!_selectParentlist) {
                _selectParentlist = [[NSMutableDictionary alloc]init];
            }
            NSIndexPath *path = [_tableView indexPathForCell:_currentCell];
            if ([_selectParentlist objectForKey:[NSString stringWithFormat:@"%zd",path.row]]) {
                NSMutableArray *array = [_selectParentlist objectForKey:[NSString stringWithFormat:@"%zd",path.row]];
                if (![array containsObject:phoneandname]) {
                    [array addObject:phoneandname];
                    //  [_currentCell setSelectedParentList:array];
                }else
                {
                    // [_currentCell setSelectedParentList:array];
                    
                }
            }else{
                NSMutableArray *array = [[NSMutableArray alloc]init];
                [array addObject:phoneandname];
                [_selectParentlist setObject:array forKey:[NSString stringWithFormat:@"%zd",path.row]];
            }
        }];
        [alertController addAction:actionTeacher];
        
    }
    [self.navigationController presentViewController:alertController animated:YES completion:^{
        
    }];
    
    
}
//

- (void)didTouchPayMethodBackgroundView {
    [self hidePayMethodPopView];
}

- (void)didTouchApplyOrder {
    
    if (![self ifChosenStudent]) {
        [self.view makeToast:@"请选择学生" duration:1.0 position:CSToastPositionTop];
        return ;
    }
    
    if (![self ifChosenPlan]) {
        [self.view makeToast:@"请选择套餐" duration:1.0 position:CSToastPositionTop];
        return ;
    }
    
    [self checkInfo];
}

#pragma mark - 检查有没有选择学生

- (BOOL)ifChosenStudent {
    return _selectedStudentId.length > 0;
}

#pragma mark - 检查有没有只有一个勾选

- (BOOL)ifChosenPlan {
    return _selectIndexlist.allKeys.count > 0;
}

#pragma mark - 检查信息全不全

- (void)checkInfo {
    
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
        
        NSArray *data = [responseObject objectForKey:@"data"];
        if (data.count > 0) {
            NSDictionary *d = [data objectAtIndex:0];
            NSString *address = [d objectForKey:@"address"];
            NSString *nickname = [d objectForKey:@"name"];
            NSString *avatar = [d objectForKey:@"avatar"];
            
            if ([address isEqual:[NSNull null]] || [nickname isEqual:[NSNull null]]) {
                if ([address isEqual:[NSNull null]]) {
                    [self.view makeToast:@"请完善收货地址" duration:1.0 position:CSToastPositionTop];
                } else if ([nickname isEqual:[NSNull null]]) {
                    [self.view makeToast:@"请完善收货姓名" duration:1.0 position:CSToastPositionTop];
                }
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    XJHUserStuffViewController *viewController = [[XJHUserStuffViewController alloc] init];
                    viewController.address = address;
                    viewController.userName = nickname;
                    viewController.avatar = avatar;
                    viewController.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:viewController animated:YES];
                });
                
                return ;
            }
            
            else if (address.length == 0 || nickname.length == 0) {
                if (address.length == 0) {
                    [self.view makeToast:@"请完善收货地址" duration:1.0 position:CSToastPositionTop];
                } else if (nickname.length == 0) {
                    [self.view makeToast:@"请完善收货姓名" duration:1.0 position:CSToastPositionTop];
                }
                
                // 复制了上边一块
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    XJHUserStuffViewController *viewController = [[XJHUserStuffViewController alloc] init];
                    viewController.address = address;
                    viewController.userName = nickname;
                    viewController.avatar = avatar;
                    viewController.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:viewController animated:YES];
                });
                
                return ;
            }
            
            else if (address.length > 0 && nickname.length > 0) {
                
                self.address = address;
                self.nickname = nickname;
                self.avatar = avatar;
                
                if ([self.nickname isEqual:[NSNull null]]) {
                    self.nickname = @"";
                }
                
                // 下一步
                [self createOrder];
            }
            
        } else {
            // 提示
            [self.view makeToast:@"请求失败" duration:1.0 position:CSToastPositionTop];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
}

#pragma mark - 创建订单

- (void)createOrder {
    NSLog(@"%f", self.totalPrice);
    NSLog(@"%@", self.datalist);
    NSLog(@"%@", self.selectIndexlist);
    NSLog(@"%@", self.selectParentlist);
    
    XJHOrderObject *orderObject = [[XJHOrderObject alloc] init];
    
    orderObject.memberId = [[NSUserDefaults standardUserDefaults] stringForKey:@"USER_ID"];
    orderObject.studentId = _selectedStudentId;
    
    NSMutableArray *mutableContracts = [[NSMutableArray alloc] init];
    
    for (NSString *key in self.selectIndexlist.allKeys) {
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithDictionary:[self.datalist objectAtIndex:[key integerValue]]];
        NSArray *contractContractSpec = [dictionary objectForKey:@"contractContractSpec"];
        [dictionary setObject:[contractContractSpec objectAtIndex:[[self.selectIndexlist objectForKey:key] integerValue]] forKey:@"contractContractSpec"];
        
        XJHOrderContract *contract = [[XJHOrderContract alloc] init];
        contract.contractId = dictionary[@"id"];
        contract.contractSpecId = dictionary[@"contractContractSpec"][@"id"];
        contract.memberCount = [self memberCountFromContractId:contract.contractSpecId];
        
        NSMutableArray *mutableMembers = [[NSMutableArray alloc] init];
        // selectParentlist 的 name 去找 id
        NSArray *parentNameArray = [self.selectParentlist objectForKey:key];
        for (NSString *name in parentNameArray) {
            NSString *parentID = [self parentIDForName:name];
            if (parentID.length > 0) {
                [mutableMembers addObject:parentID];
            }
        }
        contract.members = [NSArray arrayWithArray:mutableMembers];
        [mutableContracts addObject:contract];
    }

    orderObject.contracts = [NSArray arrayWithArray:mutableContracts];
    
    /* 检测有没有分配 */
    for (XJHOrderContract *contract in orderObject.contracts) {
        if (contract.members.count == 0) {
            [self.view makeToast:@"请选择分配给谁" duration:1.0 position:CSToastPositionTop];
            return ;
        }
    }
    /* 检测有没有分配 */
    
    /* 检测人数对不对 */
    for (XJHOrderContract *contract in orderObject.contracts) {
        if (contract.members.count != contract.memberCount) {
            [self.view makeToast:@"请确保套餐人数正确" duration:1.0 position:CSToastPositionTop];
            return ;
        }
    }
    /* 检测人数对不对 */
    
    NSDictionary *d = [orderObject mj_keyValues];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerJSON];
    [PPNetworkHelper POST:kAPICreateOrder parameters:d success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSLog(@"%@", responseObject);
        
        if (!responseObject) {
            // 提示
            [self.view makeToast:@"数据异常" duration:1.0 position:CSToastPositionTop];
            return ;
        }
        
        if (![[responseObject objectForKey:@"type"] isEqualToString:@"success"]) {
            // 提示
            [self.view makeToast:@"数据异常" duration:1.0 position:CSToastPositionTop];
            return ;
        }
        
        NSDictionary *data = [responseObject objectForKey:@"data"];
        
        if (data.count == 0) {
            // 提示
            [self.view makeToast:@"数据异常" duration:1.0 position:CSToastPositionTop];
            return ;
        }
        
        NSString *theIDString = [data objectForKey:@"orderId"];
        NSString *payablePrice = [data objectForKey:@"payablePrice"];
        self.payablePrice = [payablePrice floatValue];
        
        if (theIDString.length > 0) {
            self.lastID = theIDString;
            [self showPayMethodPopView];
        } else {
            return ;
        }
        
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (NSString *)priceFromDictionary:(NSDictionary *)dictionary {
    
    NSString *price = @"";
    
    NSString *durationName = [[dictionary objectForKey:@"duration"] objectForKey:@"name"];
    if ([durationName isEqualToString:@"每月"]) {
        price = [NSString stringWithFormat:@"%.2f", [[dictionary objectForKey:@"monthPrice"] floatValue]];
    }
    
    else if ([durationName isEqualToString:@"季度"]) {
        price = [NSString stringWithFormat:@"%.2f", [[dictionary objectForKey:@"quarterPrice"] floatValue]];
    }
    
    else if ([durationName isEqualToString:@"半年"]) {
        price = [NSString stringWithFormat:@"%.2f", [[dictionary objectForKey:@"halfYearPrice"] floatValue]];
    }
    
    else if ([durationName isEqualToString:@"年度"]) {
        price = [NSString stringWithFormat:@"%.2f", [[dictionary objectForKey:@"yearPrice"] floatValue]];
    }
    
    return price;
}

#pragma mark - 选择微信还是支付宝

// 选择支付方式的弹窗的位置

- (void)showPayMethodPopView {
    
    [self.payMethodViewBackgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
    
    [self.payMethodView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@210);
        make.bottom.equalTo(self.view).with.offset(0);
    }];
}

- (void)hidePayMethodPopView {
    
    [self.payMethodViewBackgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(CGRectGetHeight(self.view.bounds)));
        make.top.equalTo(self.view.mas_bottom);
    }];
    
    [self.payMethodView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@210);
        make.bottom.equalTo(self.view).with.offset(210);
    }];
}

#pragma mark - 签名

- (NSDictionary *)dictionaryForMethod:(NSString *)method {
    NSDictionary *dictionary = @{
                                 @"toPay" : [NSString stringWithFormat:@"%.2f", self.payablePrice],
                                 @"payCode" : self.lastID,
                                 @"sellerCode" : @"",
                                 @"sellerName" : @"诚安相见孩",
                                 @"orderCode" : @"xjh",
                                 @"invalidTime" : @"",
                                 @"createTime" : @"",
                                 @"onLineStyle" : method,
                                 @"browseType" : @"app"
                                 };
    return dictionary;
}

- (void)authAlipay {
    
    NSDictionary *dictionary = [self dictionaryForMethod:@"alipay"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerJSON];
    
    [PPNetworkHelper POST:kAPISignURl parameters:dictionary success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSString *sign = [[responseObject objectForKey:@"data"] objectForKey:@"signature"];
        if (sign.length > 0) {
            [self aliPayWithSign:sign];
        } else {
            // 提示
            [self.view makeToast:@"数据异常" duration:1.0 position:CSToastPositionTop];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
}

- (void)authWechat {
    
    NSDictionary *dictionary = [self dictionaryForMethod:@"wechat"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerJSON];
    
    [PPNetworkHelper POST:kAPISignURl parameters:dictionary success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSString *sign = [[responseObject objectForKey:@"data"] objectForKey:@"signature"];
        if (sign.length > 0) {
            [self wechatPayWithSign:sign];
        } else {
            // 提示
            [self.view makeToast:@"数据异常" duration:1.0 position:CSToastPositionTop];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark - 调起支付

- (void)aliPayWithSign:(NSString *)sign {
    [[AlipaySDK defaultService] payOrder:sign fromScheme:@"xjh" callback:^(NSDictionary *resultDic) {
        
        // 只要有起调，不管结果是什么，就通知一下，用来刷新套餐
        [[NSNotificationCenter defaultCenter] postNotificationName:@"XJH_PAYMENT_HAVE_RESULT" object:nil];
        
        NSLog(@"alipay result = %@", resultDic);
        NSString *resultStatus = [resultDic objectForKey:@"resultStatus"];
        if ([resultStatus isEqualToString:@"9000"]) {
            [self.view makeToast:@"订单支付成功" duration:2.0 position:CSToastPositionTop];
        }
        
        else if ([resultStatus isEqualToString:@"8000"]) {
            [self.view makeToast:@"正在处理中，支付结果未知" duration:2.0 position:CSToastPositionTop];
        }
        
        else if ([resultStatus isEqualToString:@"4000"]) {
            [self.view makeToast:@"订单支付失败" duration:2.0 position:CSToastPositionTop];
        }
        
        else if ([resultStatus isEqualToString:@"5000"]) {
            [self.view makeToast:@"重复请求" duration:2.0 position:CSToastPositionTop];
        }
        
        else if ([resultStatus isEqualToString:@"6001"]) {
            [self.view makeToast:@"用户中途取消" duration:2.0 position:CSToastPositionTop];
        }
        
        else if ([resultStatus isEqualToString:@"6002"]) {
            [self.view makeToast:@"网络连接出错" duration:2.0 position:CSToastPositionTop];
        }
        
        else if ([resultStatus isEqualToString:@"6004"]) {
            [self.view makeToast:@"支付结果未知" duration:2.0 position:CSToastPositionTop];
        }
        
        else {
            [self.view makeToast:@"其他支付错误" duration:2.0 position:CSToastPositionTop];
        }
        
    }];
}

- (void)wechatPayWithSign:(NSString *)sign {
    // [WXApi registerApp:@"wxa1fbfdb142a2f2e1"];
    
    XJHWechatSign *wechatSign = [XJHWechatSign mj_objectWithKeyValues:sign];
    
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = wechatSign.partnerid;
    request.prepayId = wechatSign.prepayid;
    request.nonceStr = wechatSign.noncestr;
    request.timeStamp = [wechatSign.timestamp longLongValue];
    request.package = @"Sign=WXPay";
    request.sign = wechatSign.sign;
    
    [WXApi sendReq:request];
}

#pragma mark - XJHPayMethodViewDelegate

- (void)confirmWithMethod:(NSUInteger)method {
    [self hidePayMethodPopView];
    
    if (method == 1) {
        [self authAlipay];
    }
    
    else if (method == 2) {
        [self authWechat];
    }
}

#pragma mark -

- (UIView *)payMethodViewBackgroundView {
    if (!_payMethodViewBackgroundView) {
        _payMethodViewBackgroundView = [[UIView alloc] init];
        _payMethodViewBackgroundView.backgroundColor = [[UIColor colorWithHex:@"#000000"] colorWithAlphaComponent:0.4];
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouchPayMethodBackgroundView)];
        [_payMethodViewBackgroundView addGestureRecognizer:recognizer];
    }
    return _payMethodViewBackgroundView;
}

- (XJHPayMethodView *)payMethodView {
    if (!_payMethodView) {
        _payMethodView = [[XJHPayMethodView alloc] init];
        _payMethodView.delegate = self;
    }
    return _payMethodView;
}

-(CGFloat)getLabelHeight:(NSString*)str
{
    if ([str isKindOfClass:[NSNull class]]) {
        return 0;
    }
    NSDictionary *dict = @{NSFontAttributeName : [UIFont systemFontOfSize:15]};
    CGSize maxSize = CGSizeMake(self.view.frame.size.width - 30, 100);
    CGSize size =  [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size.height;
    
    
}

#pragma mark - 根据 ContractId 找 memberCount

- (NSUInteger)memberCountFromContractId:(NSString *)theID {
    for (NSDictionary *dictionary in self.datalist) {
        NSArray *array = [dictionary objectForKey:@"contractContractSpec"];
        for (NSDictionary *d in array) {
            if ([d[@"id"] isEqualToString:theID]) {
                return [d[@"memberCount"] integerValue];
            }
        }
    }
    return 0;
}

#pragma mark - 从家长数组里根据名字取id

- (NSString *)parentIDForName:(NSString *)name {
    
    NSLog(@"%@", _applyParentList);
    
    for (NSDictionary *dictionary in _applyParentList) {
        NSArray *array = dictionary[@"bindStudentMember"];
        
        for (NSDictionary *d in array) {
            NSString *phone = [d objectForKey:@"phone"];
            NSString *name1 = [d objectForKey:@"name"];
            if ([phone isKindOfClass:[NSNull class]]) {
                phone = @"";
            }
            if ([name isKindOfClass:[NSNull class]]) {
                name = @"";
            }
            NSString *phoneandname = [NSString stringWithFormat:@"%@%@",phone,name1];

            if ([phoneandname isEqualToString:name]) {
                return d[@"id"];
            }
        }
    }
    
    return @"";
}

@end
