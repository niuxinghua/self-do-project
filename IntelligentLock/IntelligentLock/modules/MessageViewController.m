//
//  MessageViewController.m
//  IntelligentLock
//
//  Created by niuxinghua on 2018/1/30.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "MessageViewController.h"
#import "BindAdminiViewController.h"
#import "MessageTableViewCell.h"
#import "MJRefresh.h"
#define KMessageIdKey @"message_id"
#define KMessageList  @"message_lists"
@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)NSMutableArray *dataList;

@property (nonatomic,strong)NSMutableArray *dataListtoShow;

@property (nonatomic,assign)NSInteger pageIndex;
@property (nonatomic,strong)UIButton *clearButton;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
     self.navigationItem.title = [kMultiTool getMultiLanByKey:@"message"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(plustouch:) name:@"didtapplus" object:nil];
    
    _clearButton = [[UIButton alloc]init];
    [self.view addSubview:_clearButton];
    [_clearButton setTitleColor:[UIColor colorWithRed:67/255.0 green:80/255.0 blue:38/255.0 alpha:1.0] forState:UIControlStateNormal];
    _clearButton.titleLabel.textAlignment = NSTextAlignmentRight;
    [_clearButton addTarget:self action:@selector(clear) forControlEvents:UIControlEventTouchUpInside];
    _clearButton.titleLabel.font = [UIFont systemFontOfSize:14];
       [_clearButton setTitle:[kMultiTool getMultiLanByKey:@"qingkongxiaoxi"] forState:UIControlStateNormal];
    _clearButton.titleLabel.textAlignment=NSTextAlignmentRight;

    [self.view addSubview:self.tableView];
    
   
    [self makeConstrains];
    NSDictionary *logindic =
    [[NSUserDefaults standardUserDefaults] objectForKey:@"loginmodel"];
    LoginModel *loginModel = [LoginModel yy_modelWithJSON:logindic];
    NSString *messagelistkey = [NSString stringWithFormat:@"%@-%@",loginModel.retval.user_id,KMessageList];
    _dataList = [[NSMutableArray alloc]init];
    _dataList = [[NSUserDefaults standardUserDefaults] objectForKey:messagelistkey];
    _pageIndex = 1;
    _dataListtoShow = [[NSMutableArray alloc]init];
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc]init];
    }
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _pageIndex = 1;
        [self getData];
    }];
    
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _pageIndex ++;
        [self getShowData];
    }];
    [self.tableView.mj_header beginRefreshing];
  
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setNewTabImage) name:@"NEWMESSAGE" object:nil];
}
- (void)setNewTabImage
{
    self.tabBarItem = [[UITabBarItem alloc]initWithTitle:@""
                                              image:[UIImage imageNamed:@"xiaoxi_new"]
                                      selectedImage:[UIImage imageNamed:@"xiaoxi_new"]];
}
- (void)clear{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[kMultiTool getMultiLanByKey:@"qingchuxiaoxitishi"] message:nil preferredStyle:UIAlertControllerStyleAlert];
    alert.popoverPresentationController.sourceView = self.view;
    alert.popoverPresentationController.sourceRect = CGRectMake(0, 0, 1.0, 1.0);
    
    UIAlertAction * takingPicAction = [UIAlertAction actionWithTitle:[kMultiTool getMultiLanByKey:@"queding"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSDictionary *logindic =
        [[NSUserDefaults standardUserDefaults] objectForKey:@"loginmodel"];
        LoginModel *loginModel = [LoginModel yy_modelWithJSON:logindic];
        NSString *messagelistkey = [NSString stringWithFormat:@"%@-%@",loginModel.retval.user_id,KMessageList];

        [[NSUserDefaults standardUserDefaults] removeObjectForKey:messagelistkey];
        _dataList = [NSMutableArray new];
        _pageIndex = 1;
        _dataListtoShow = @[].mutableCopy;
        [_tableView reloadData];
    }];
    [alert addAction:takingPicAction];
    [alert addAction:[UIAlertAction actionWithTitle:[kMultiTool getMultiLanByKey:@"cancell"] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
    }]];
    [self.navigationController presentViewController:alert animated:NO completion:^{
        
    }];
}
- (void)plustouch:(NSNotification *)notification
{
    if (![notification.object isEqual:@2]) {
        return;
    }
    if (![self.navigationController.viewControllers.lastObject isKindOfClass:[BindAdminiViewController class]]) {
        BindAdminiViewController *bind = [[BindAdminiViewController alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:bind];
        [self presentViewController:nav animated:NO completion:^{
            
        }];
        
        
    }
    

   
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // [self setNavigationUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getData) name:@"refreshMessage" object:nil];
    
    [self.navigationController setNavigationBarHidden:YES];
    NSDictionary *logindic =
    [[NSUserDefaults standardUserDefaults] objectForKey:@"loginmodel"];
    LoginModel *loginModel = [LoginModel yy_modelWithJSON:logindic];
    NSString *messagelistkey = [NSString stringWithFormat:@"%@-%@",loginModel.retval.user_id,KMessageList];
    _dataList = [[NSUserDefaults standardUserDefaults] objectForKey:messagelistkey];
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc]init];
    }
    _pageIndex = 1;
    _dataListtoShow = @[].mutableCopy;
    [_tableView reloadData];
    [self.tableView.mj_header beginRefreshing];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // [self setNavigationUI];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshMessage" object:nil];
    [self.navigationController setNavigationBarHidden:NO];
}
#pragma mark -methods

- (void)makeConstrains
{
  
    
    
    [_clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.view).offset(10);
        make.top.equalTo(self.mas_topLayoutGuide);
        make.height.equalTo(@50);
        make.width.equalTo(@150);
        
    }];
    
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_clearButton.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];

    
    
}
- (void)getShowData
{
    NSDictionary *logindic =
    [[NSUserDefaults standardUserDefaults] objectForKey:@"loginmodel"];
    LoginModel *loginModel = [LoginModel yy_modelWithJSON:logindic];
    NSString *messagelistkey = [NSString stringWithFormat:@"%@-%@",loginModel.retval.user_id,KMessageList];

    _dataList = [[NSUserDefaults standardUserDefaults] objectForKey:messagelistkey];
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc]init];
    }
    NSInteger last = _pageIndex * 10 > _dataList.count ? _dataList.count:_pageIndex * 10;
    
    NSRange range = NSMakeRange(0, last);
    NSArray *array = [[_dataList reverseObjectEnumerator] allObjects];
    _dataListtoShow = [array subarrayWithRange:range].mutableCopy;
   // [self.view hideToastActivity];
    [_tableView.mj_footer endRefreshing];
    [_tableView.mj_header endRefreshing];
    [_tableView reloadData];
}
- (void)getData
{
    if (![PPNetworkHelper isNetwork]) {
        //无网络
        [self.view hideToastActivity];
        [_tableView.mj_footer endRefreshing];
        [_tableView.mj_header endRefreshing];
        [self getShowData];
        return;
    }
    NSDictionary *logindic =
    [[NSUserDefaults standardUserDefaults] objectForKey:@"loginmodel"];
    LoginModel *loginModel = [LoginModel yy_modelWithJSON:logindic];
     NSString *messageIdkey = [NSString stringWithFormat:@"%@-%@",loginModel.retval.user_id,KMessageIdKey];
    NSString *msgId = [[NSUserDefaults standardUserDefaults] objectForKey:messageIdkey];
    if ([msgId isEqual:[NSNull null]] || !msgId.length) {
        msgId = @"0";
    }
    NSDictionary *dic = @{@"app":@"userloginapp",@"act":@"get_message",@"token":loginModel.retval.token,@"msg_id":msgId};
    [self.view makeToastActivity:CSToastPositionCenter];
    NSString *url = [NSString stringWithFormat:@"%@?app=userloginapp&act=get_message&token=%@&msg_id=%@",kBaseMessageUrl,loginModel.retval.token,msgId];
    NSLog(@"messageurl---%@",url);
    [PPNetworkHelper GET:kBaseUrl parameters:dic success:^(id responseObject) {
        [self.view hideToastActivity];
        [_tableView.mj_footer endRefreshing];
        [_tableView.mj_header endRefreshing];
        if (!_dataList) {
            _dataList=[[NSMutableArray alloc]init];
        }
        _dataList = _dataList.mutableCopy;
        NSArray *array = [responseObject objectForKey:@"retval"];
        if (array&&array.count>0) {
            for (int i=0; i<array.count; i++) {
                NSDictionary *dic = array[i];
                if (![_dataList containsObject:dic]) {
                    [_dataList addObject:dic];
                }
            }
            //  [_dataList addObjectsFromArray:[responseObject objectForKey:@"retval"]];
            // [_dataList sortUsingFunction:compare context:NULL];
            NSDictionary *logindic =
            [[NSUserDefaults standardUserDefaults] objectForKey:@"loginmodel"];
            LoginModel *loginModel = [LoginModel yy_modelWithJSON:logindic];
            NSString *messagelistkey = [NSString stringWithFormat:@"%@-%@",loginModel.retval.user_id,KMessageList];
            [[NSUserDefaults standardUserDefaults] setObject:_dataList forKey:messagelistkey];
            NSDictionary *dic = _dataList.lastObject;
            NSString *messageIdkey = [NSString stringWithFormat:@"%@-%@",loginModel.retval.user_id,KMessageIdKey];
            [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"msg_id"] forKey:messageIdkey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        [self getShowData];
    } failure:^(NSError *error) {
        [self getShowData];
        [self.view hideToastActivity];
        [_tableView.mj_footer endRefreshing];
        [_tableView.mj_header endRefreshing];
    }];
   
}

NSComparisonResult compare(NSDictionary *firstDict, NSDictionary *secondDict, void *context) {
  
    int fdate = [[firstDict objectForKey:@"msg_id"]intValue];
     int sdate = [[secondDict objectForKey:@"msg_id"]intValue];

    if (fdate > sdate)
        return NSOrderedAscending;
    else if (fdate < sdate)
        return NSOrderedDescending;
    else
        return NSOrderedSame;
}
#pragma mark -ui getters

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[MessageTableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    
    return  _tableView;
}
#pragma mark-tableview delegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
    
}



#pragma mark-datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(!_dataListtoShow)
    {
        return 0;
        
    }
    
    return _dataListtoShow.count;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MessageTableViewCell* cell=[[MessageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    NSDictionary *dic = [_dataListtoShow objectAtIndex:[indexPath row]];
    cell.dic = dic;
    return cell;
    
}




@end
