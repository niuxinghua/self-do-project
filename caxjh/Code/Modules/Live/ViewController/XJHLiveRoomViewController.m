//
//  XJHLiveRoomViewController.m
//  caxjh
//
//  Created by niuxinghua on 2017/9/2.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import "XJHLiveRoomViewController.h"
#import "LiveRoomTableViewCell.h"
#import "HMNodeObject.h"
#import "HMSDKManager.h"
#import "VIPRoomDataController.h"
#import "UIView+Toast.h"
#import <Bugly/Bugly.h>
#import "CustomButton.h"
#import "UIViewController+PlaceHolderImageView.h"
#import "DeviceStore.h"
#import <IQKeyboardManager.h>
#import "MBProgressHUD.h"
#import "MJRefresh.h"

@interface XJHLiveRoomViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *realDatalist;
@property(nonatomic,strong)NSMutableArray *realIdDatalist;
@property(nonatomic,strong)UIButton *studentTextfield;
@property(nonatomic,strong)CustomButton *arrowButton;
@property(nonatomic,strong)NSArray *indexArray;
@property(nonatomic,copy)NSString *selectStuName;
@property(nonatomic,copy)NSString *selectID;
@end

@implementation XJHLiveRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tableView = [[UITableView alloc]init];
    _realDatalist = [[NSMutableArray alloc]init];
    _realIdDatalist = [[NSMutableArray alloc]init];
    _indexArray = [[NSArray alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _studentTextfield = [[UIButton alloc]initWithFrame:CGRectMake(20, 270, self.view.frame.size.width - 40, 30)];
    [self.view addSubview:_studentTextfield];
    _studentTextfield.hidden = YES;
    _studentTextfield.backgroundColor = [UIColor whiteColor];
    _studentTextfield.layer.borderWidth = 0.5;
    _studentTextfield.layer.borderColor = [UIColor grayColor].CGColor;
    _studentTextfield.layer.cornerRadius = 5;
    _studentTextfield.layer.masksToBounds = YES;
    [_studentTextfield setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _arrowButton = [CustomButton buttonWithType:UIButtonTypeCustom];
    [_arrowButton setImage:[UIImage imageNamed:@"下箭头"] forState:UIControlStateNormal];
    _arrowButton.userInteractionEnabled = NO;
    _arrowButton.hidden = YES;
    _arrowButton.frame = CGRectMake(self.view.frame.size.width/2.0 + 40, 270, 30, 30);
    
    [_studentTextfield addTarget:self action:@selector(didTouchArrowButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_arrowButton];
    _arrowButton.hidden = YES;
    
    
    _tableView.frame = CGRectMake(0, 270, self.view.frame.size.width, self.view.frame.size.height - 270);
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [UIView new];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[LiveRoomTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
    [_tableView setContentInset:UIEdgeInsetsMake(0, 0, 100, 0)];
    [self getVIPRoom];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getVIPRoom];
    }];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getVIPRoom) name:@"refreshdevice" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //    [IQKeyboardManager sharedManager].enable = YES;
}

-(void)didTouchArrowButton
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    alertController.popoverPresentationController.sourceView = self.view;
    alertController.popoverPresentationController.sourceRect = CGRectMake(0, 0, 1.0, 1.0);
    if (!_indexArray.count) {
        return;
    }
    for(NSDictionary *dic in _indexArray)
    {
        UIAlertAction *actionTeacher = [UIAlertAction actionWithTitle:[dic objectForKey:@"stuName"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self filterStudentId:[dic objectForKey:@"stuId"]];
            [_studentTextfield setTitle:[NSString stringWithFormat:@"%@   ",[dic objectForKey:@"stuName"]] forState:UIControlStateNormal];
            _selectStuName = [dic objectForKey:@"stuName"];
            _selectID = [dic objectForKey:@"stuId"];
            if (self.selectStuBlock) {
                self.selectStuBlock([dic objectForKey:@"stuName"], [dic objectForKey:@"stuId"], _indexArray);
            }
        }];
        [alertController addAction:actionTeacher];
        
    }
    [self.navigationController presentViewController:alertController animated:YES completion:^{
        
    }];
}
-(void)getVIPRoom
{
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    [VIPRoomDataController getVIPRoomDataOnSuccess:^(id response) {
        NSArray *data = [response objectForKey:@"data"];
        if (_datalist.count==0) {
            [self showEmptyImageViewAtY:370];
        }else{
            [self hidePlaceHolderImageView];
        }
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            if (data && ![data isKindOfClass:[NSNull class]]) {
                [_datalist removeAllObjects];
                NSMutableArray *array = [NSMutableArray array];
                for (NSDictionary *dic in data)
                {
                    BOOL hasThesame = NO;
                    for (NSDictionary *dic1 in array) {
                        hasThesame = NO;
                        if ([[dic1 objectForKey:@"hmIp"]isEqualToString:[dic objectForKey:@"hmIp"]] && [[dic1 objectForKey:@"hmName"]isEqualToString:[dic objectForKey:@"hmName"]] && [[dic1 objectForKey:@"hmPort"]isEqualToString:[dic objectForKey:@"hmPort"]] && [[dic1 objectForKey:@"hmPassword"]isEqualToString:[dic objectForKey:@"hmPassword"]] && ![[dic objectForKey:@"hmIp"] isKindOfClass:[NSNull class]] && ![[dic objectForKey:@"hmName"] isKindOfClass:[NSNull class]] && ![[dic objectForKey:@"hmPort"] isKindOfClass:[NSNull class]] && ![[dic objectForKey:@"hmPassword"] isKindOfClass:[NSNull class]] && ![[dic1 objectForKey:@"hmIp"] isKindOfClass:[NSNull class]] && ![[dic1 objectForKey:@"hmName"] isKindOfClass:[NSNull class]] && ![[dic1 objectForKey:@"hmPort"] isKindOfClass:[NSNull class]] && ![[dic1 objectForKey:@"hmPassword"] isKindOfClass:[NSNull class]]) {
                            hasThesame = YES;
                        }
                    }
                    if (hasThesame) {
                        continue;
                    }
                    if ([dic objectForKey:@"hmIp"] && [dic objectForKey:@"hmName"] && [dic objectForKey:@"hmPort"] && [dic objectForKey:@"hmPassword"] && ![[dic objectForKey:@"hmIp"] isKindOfClass:[NSNull class]] && ![[dic objectForKey:@"hmName"] isKindOfClass:[NSNull class]] && ![[dic objectForKey:@"hmPort"] isKindOfClass:[NSNull class]] && ![[dic objectForKey:@"hmPassword"] isKindOfClass:[NSNull class]]) {
                        //监控sn获取的是否正确
                        [array addObject:dic];
                        _datalist = [[HMSDKManager sharedInstance]getAllDevice:[dic objectForKey:@"hmIp"] account:[dic objectForKey:@"hmName"] passWord:[dic objectForKey:@"hmPassword"] port:[[dic objectForKey:@"hmPort"] intValue]].mutableCopy;
                    }
                }
                [_realDatalist removeAllObjects];
                for (NSDictionary *dic in data) {
                    if (dic) {
                        NSArray *urls = [dic objectForKey:@"urls"];
                        if (urls && urls.count > 0) {
                            _realDatalist = [_realDatalist arrayByAddingObjectsFromArray:[self filter:urls]].mutableCopy;
                            
                        }
                    }
                    
                }
                
                _indexArray = data;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"bindchange" object:_indexArray];
                if (_indexArray.count > 1 ) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                    _arrowButton.hidden = NO;
                    });
                }
                if (![_indexArray isKindOfClass:[NSNull class]] && [_indexArray count] && !_selectID) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                       [_studentTextfield setTitle:[NSString stringWithFormat:@"%@   ",[_indexArray[0] objectForKey:@"stuName"]] forState:UIControlStateNormal];
                    });
                    
                    [self filterStudentId:[_indexArray[0] objectForKey:@"stuId"]];
                }else if (_selectStuName && _selectID){
                    [_studentTextfield setTitle:[NSString stringWithFormat:@"%@   ",_selectStuName] forState:UIControlStateNormal];
                    [self filterStudentId:_selectID];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:NO];
                [self.tableView.mj_header endRefreshing];
            });
            
        });
    } fail:^(id error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:NO];
            [self.tableView.mj_header endRefreshing];
        });
        [self.view makeToast:@"加载失败"];
    }];
}
-(NSMutableArray *)filter:(NSArray *)array{
    NSMutableArray *snarray  = [[NSMutableArray alloc]init];
    for (NSDictionary *dic in array) {
        NSArray *sna = [dic objectForKey:@"url"];
        NSString *sn = sna[0];
        for (HMNodeObject *node in _datalist) {
            if ([node.SN isEqualToString:sn]) {
                node.nodeName = [dic objectForKey:@"name"];
                [snarray addObject:node];
            }
        }
    }
    return snarray;
}
-(void)filterStudentId:(NSString *)stuId
{
    dispatch_async(dispatch_get_main_queue(), ^{
      
        if ([stuId isEqualToString:_selectStuName]) {
            return;
        }
        [_realIdDatalist removeAllObjects];
        NSArray *array;
        for (NSDictionary *dic in _indexArray) {
            if ([[dic objectForKey:@"stuId"] isEqualToString:stuId]) {
                array = [dic objectForKey:@"urls"];
                _selectID = [stuId copy];
                if (self.selectStuBlock) {
                    self.selectStuBlock([dic objectForKey:@"stuName"],[dic objectForKey:@"stuId"], _indexArray);
                }
            }
        }
        
        if (array && ![array isKindOfClass:[NSNull class]]) {
            for (NSDictionary *dic in array) {
                for (HMNodeObject *node in _realDatalist) {
                    if ([node.SN isEqualToString:[dic objectForKey:@"url"][0]] && ![_realIdDatalist containsObject:node]) {
                        
                        node.showName = [dic objectForKey:@"name"];
                        [_realIdDatalist addObject:node];
                    }
                }
            }
        }
        [self.tableView reloadData];
        [DeviceStore sharedInstance].deviceList = _realIdDatalist;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"devicechange" object:_realIdDatalist];
        if (_realIdDatalist.count==0) {
            [self showEmptyImageViewAtY:460];
        }else{
            [self hidePlaceHolderImageView];
        }
        for (LiveRoomTableViewCell *cell in [_tableView visibleCells]) {
            [cell setSelected:NO];
        }
        if ([[_tableView visibleCells] count]) {
            LiveRoomTableViewCell *first = [_tableView visibleCells][0];
            HMNodeObject *node = _realIdDatalist[0];
            [first setSelected:YES];
            if (self.tapRoomBlock) {
                if (node.SN) {
                    self.tapRoomBlock(node);
                }
            }
        }
        
    });
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
#pragma mark-datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!_realIdDatalist) {
        return 0;
    }
    return [_realIdDatalist count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LiveRoomTableViewCell *cell = [[LiveRoomTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    HMNodeObject *node = [_realIdDatalist objectAtIndex:[indexPath row]];
    [cell setName:node.showName];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HMNodeObject *node = [_realIdDatalist objectAtIndex:[indexPath row]];
    LiveRoomTableViewCell *selectedcell = [tableView cellForRowAtIndexPath:indexPath];
    for (LiveRoomTableViewCell *cell in [tableView visibleCells]) {
        [cell setSelected:NO];
    }
    [selectedcell setSelected:YES];
    if (self.tapRoomBlock) {
        if (node.SN) {
            self.tapRoomBlock(node);
        }
    }
    
}


- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

@end
