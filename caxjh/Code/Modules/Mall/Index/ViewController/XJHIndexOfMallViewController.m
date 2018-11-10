//
//  XJHIndexOfMallViewController.m
//  caxjh
//
//  Created by Yingchao Zou on 30/08/2017.
//  Copyright © 2017 Yingchao Zou. All rights reserved.
//

#import "XJHIndexOfMallViewController.h"
#import "UIViewController+StatusBar.h"
#import "MallCollectionViewCell.h"
#import "MJRefresh.h"
#import "MallDetilViewController.h"
@interface XJHIndexOfMallViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong)UIImageView *imageView1;

@property(nonatomic,strong)UILabel *textLable1;

@property(nonatomic,strong)UICollectionView *collectionView;

@property (nonatomic,strong)NSMutableArray *dataList;

@property(nonatomic,assign)int start;

@end

@implementation XJHIndexOfMallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setStatusBarDefaultColor];
    //1.初始化layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
 
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [self.view addSubview:_collectionView];
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[MallCollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _dataList = [NSMutableArray new];
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _start = 0;
        _dataList = @[].mutableCopy;
        [self getData];
    }];
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getData)];
    [self getData];
    
    
}

- (void)getData
{
    _collectionView.userInteractionEnabled = NO;
    NSDictionary *dic = @{@"columns":@[@"thumb",@"name",@"price",@"resume",@"detail",@"id"], @"start":[NSNumber numberWithInt:_start],@"length":@10, @"order":@{@"createTime":@"desc"},@"filter":@{@"state":@{@"eq":@"onShelf"}},@"table":@"Goods"};
    [PPNetworkHelper POST:kAPIMallInfo parameters:dic success:^(id responseObject) {
        if (![responseObject isKindOfClass:[NSNull class]]) {
            NSArray *data = [responseObject objectForKey:@"data"];
            if (data && ![data isKindOfClass:[NSNull class]]) {
                _start += [data count];
                _dataList = [_dataList arrayByAddingObjectsFromArray:data].mutableCopy;
  
                [_collectionView reloadData];
                if ([self.collectionView.mj_header isRefreshing]) {
                    [self.collectionView.mj_header endRefreshing];
                }
                if ([self.collectionView.mj_footer isRefreshing]) {
                    [self.collectionView.mj_footer endRefreshing];
                }
               _collectionView.userInteractionEnabled = YES;
            }
        }
    } failure:^(NSError *error) {
        if ([self.collectionView.mj_header isRefreshing]) {
            [self.collectionView.mj_header endRefreshing];
        }
        if ([self.collectionView.mj_footer isRefreshing]) {
            [self.collectionView.mj_footer endRefreshing];
        }
        _collectionView.userInteractionEnabled = YES;
    }];
}


#pragma mark collectionView代理方法
//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_dataList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    MallCollectionViewCell *cell = (MallCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    if (!cell) {
        cell = [[MallCollectionViewCell alloc]initWithFrame:CGRectZero];
    }
    
    cell.dic = [_dataList objectAtIndex:[indexPath row]];
    cell.tapDetilBlock = ^(NSDictionary *dic) {
        MallDetilViewController *detil = [[MallDetilViewController alloc]init];
        detil.hidesBottomBarWhenPushed = YES;
        detil.dic = [_dataList objectAtIndex:[indexPath row]];
        [self.navigationController pushViewController:detil animated:NO];
    };
    return cell;
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.frame.size.width/2.0 - 5, 260);
}


//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}


//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}



//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   
}
















-(void)makeConstrains
{
    [_imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@190);
        make.height.equalTo(@75);
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
    }];
    [_textLable1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imageView1.mas_bottom);
        make.width.equalTo(@200);
        make.height.equalTo(@40);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
