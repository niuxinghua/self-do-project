//
//  XJHPostIndexViewController.m
//  caxjh
//
//  Created by Yingchao Zou on 30/08/2017.
//  Copyright © 2017 Yingchao Zou. All rights reserved.
//

#import "XJHPostIndexViewController.h"
#import "Masonry.h"
#import "Const.h"
#import "GGBannerView.h"
#import "UIImageView+WebCache.h"
#import "HistoryArticleViewController.h"
#import "BannerDataController.h"
#import "UIViewController+StatusBar.h"
#import "XJHPostMemberListViewController.h"
#import "XJHPostSecurityListViewController.h"
#import "XJHPostLostListViewController.h"
#import "XJHParentListViewController.h"
#import "XJHDonateViewController.h"
#import "ArticleDetilViewController.h"
#import "GYZChooseCityController.h"
@interface XJHPostIndexViewController ()<GGBannerViewDelegate,CLLocationManagerDelegate,BMKDistrictSearchDelegate,GYZChooseCityDelegate,UIAlertViewDelegate>
@property (nonatomic,strong)UICollectionView *mainView;
@property (nonatomic,strong)GGBannerView *bannerView;

@property (nonatomic,strong)UIScrollView *backScrollView;

@property (nonatomic,strong)UIButton *vipButton;

@property (nonatomic,strong)UIButton *safeButton;

@property (nonatomic,strong)UIButton *parentButton;

@property (nonatomic,strong)UIButton *missButton;

@property (nonatomic,strong)UIButton *donateButton;

@property (nonatomic,strong)NSMutableArray *bannerArray;

@property (nonatomic,strong)NSMutableArray *bannerData;

@property (nonatomic,strong)UIButton *cityButton;

@property (nonatomic,copy)NSString *currCity;
@end

@implementation XJHPostIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setStatusBarDefaultColor];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //self.title = @"想见孩";
    
    _backScrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:_backScrollView];
    _bannerView = [self headerView];
    _bannerView.interval = 3.0;
    _bannerView.delegate = self;
    [_backScrollView addSubview:_bannerView];
    [self setUpRightBarItem];
    [self setupButtons];
    [self makeConstrains];
    
    _cityButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:_cityButton];
    //    [_cityButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [_cityButton addTarget:self action:@selector(pickupCity) forControlEvents:UIControlEventTouchUpInside];
    _cityButton.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = left;
    [_cityButton setImage:[UIImage imageNamed:@"下箭头1"] forState:UIControlStateNormal];
    [_cityButton addTarget:self action:@selector(pickupCity) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *cityname = [[NSUserDefaults standardUserDefaults] objectForKey:@"cityname"];
    NSString *cittyID = [[NSUserDefaults standardUserDefaults] objectForKey:@"cityid"];
    if (cittyID && cityname) {
        // _cityButton.title = cityname;
        [_cityButton setTitle:cityname forState:UIControlStateNormal];
        [self remakeButtonInset];
        [self locationStart];
        // [self getBannerData];
        return;
    }else{
        
        [self locationStart];
    }
    
}
- (void)pickupCity
{
    
    GYZChooseCityController *city = [[GYZChooseCityController alloc]init];
    city.hidesBottomBarWhenPushed = YES;
    city.delegate = self;
    [self.navigationController pushViewController:city animated:NO];
    
}
-(void)setupButtons
{
    _vipButton = [[UIButton alloc]init];
    [_vipButton setBackgroundImage:[UIImage imageNamed:@"热门文章.png"] forState:UIControlStateNormal];
    [_vipButton addTarget:self action:@selector(gotoVip) forControlEvents:UIControlEventTouchUpInside];
    [_backScrollView addSubview:_vipButton];
    
    
    _safeButton = [[UIButton alloc]init];
    [_safeButton setBackgroundImage:[UIImage imageNamed:@"safety.png"] forState:UIControlStateNormal];
    [_safeButton addTarget:self action:@selector(gotoSafety) forControlEvents:UIControlEventTouchUpInside];
    [_backScrollView addSubview:_safeButton];
    
    _parentButton = [[UIButton alloc]init];
    [_parentButton setBackgroundImage:[UIImage imageNamed:@"parentknow.png"] forState:UIControlStateNormal];
    [_parentButton addTarget:self action:@selector(gotoParent) forControlEvents:UIControlEventTouchUpInside];
    [_backScrollView addSubview:_parentButton];
    
    _missButton = [[UIButton alloc]init];
    [_missButton setBackgroundImage:[UIImage imageNamed:@"miss.png"] forState:UIControlStateNormal];
    [_missButton addTarget:self action:@selector(gotoLost) forControlEvents:UIControlEventTouchUpInside];
    [_backScrollView addSubview:_missButton];
    
    _donateButton = [[UIButton alloc]init];
    [_donateButton setBackgroundImage:[UIImage imageNamed:@"donate.png"] forState:UIControlStateNormal];
    [_donateButton addTarget:self action:@selector(gotoDonate) forControlEvents:UIControlEventTouchUpInside];
    [_backScrollView addSubview:_donateButton];
}
-(void)getBannerData
{
    
    NSString *cityid  =  [[NSUserDefaults standardUserDefaults]objectForKey:@"cityid"];
    NSDictionary *dic = @{@"table":@"Article",@"order":@{@"createTime":@"desc"},@"id":@"",@"fields":@{},@"columns":@[@"id",@"name",@"image",@"detail",@"createTime"],@"filter":@{@"city.id":@{@"eq":cityid},@"type":@{@"eq":@"slide"}}};
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerJSON];
    NSLog(@"%@",kAPIQueryUrl);
    [PPNetworkHelper POST:kAPIQueryUrl parameters:dic success:^(id responseObject) {
        _bannerArray = [[NSMutableArray alloc]init];
        NSArray *array = [responseObject objectForKey:@"data"];
        if (array && [array count]) {
            _bannerData = array.mutableCopy;
            for (NSDictionary *dic in array) {
                [_bannerArray addObject:[dic objectForKey:@"image"]];
            }
        }
        [_bannerView configBanner:_bannerArray];
    } failure:^(NSError *error) {
        
    }];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
}
- (void)makeConstrains
{
    
    _bannerView.frame = CGRectMake(0, 0, _backScrollView.frame.size.width, 180);
    _vipButton.frame = CGRectMake(15, 190, self.view.frame.size.width-30, 100);
    CGFloat kwidth = ((self.view.frame.size.width - 30 - 10)/2.0);
    
    _safeButton.frame = CGRectMake(15, 300, kwidth, 120);
    _parentButton.frame = CGRectMake(15 + kwidth + 5, 300, kwidth, 120);
    _missButton.frame = CGRectMake(15, 430, kwidth, 120);
    _donateButton.frame = CGRectMake(15 + kwidth + 5, 430, kwidth, 120);
    _backScrollView.contentSize = CGSizeMake(self.view.frame.size.width, _bannerView.frame.size.height + _safeButton.frame.size.height * 2.0 + _vipButton.frame.size.height + 64 + 48 + 40);
}

- (void)imageView:(UIImageView *)imageView loadImageForUrl:(NSString *)url
{
    [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
}
/**
 *  banner的点击回调
 */
- (void)bannerView:(GGBannerView *)bannerView didSelectAtIndex:(NSUInteger)index
{
    ArticleDetilViewController *detil = [[ArticleDetilViewController alloc]init];
    detil.dic = [_bannerData objectAtIndex:index];
    detil.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detil animated:NO];
}

- (GGBannerView *)headerView{
    
    GGBannerView *bannerView = [[GGBannerView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
    // bannerView.backgroundColor = [UIColor blueColor];
    return bannerView;
}


- (void)gotoVip
{
    XJHPostMemberListViewController *vip = [[XJHPostMemberListViewController alloc]init];
    vip.type = ArticleTypeVIP;
    [self.navigationController pushViewController:vip animated:NO];
}
- (void)gotoSafety
{
    XJHPostSecurityListViewController *safety = [[XJHPostSecurityListViewController alloc]init];
    safety.type = ArticleTypeSafety;
    [self.navigationController pushViewController:safety animated:NO];
}
- (void)gotoLost
{
    XJHPostLostListViewController *safety = [[XJHPostLostListViewController alloc]init];
    safety.type = ArticleTypeLost;
    [self.navigationController pushViewController:safety animated:NO];
}
-(void)gotoParent
{
    XJHParentListViewController *safety = [[XJHParentListViewController alloc]init];
    safety.type = ArticleTypeParent;
    [self.navigationController pushViewController:safety animated:NO];
}
- (void)gotoDonate
{
    XJHDonateViewController *safety = [[XJHDonateViewController alloc]init];
    safety.type = ArticleTypeDonate;
    [self.navigationController pushViewController:safety animated:NO];
    
}

- (void)setUpRightBarItem
{
    UIButton*rightButton = [[UIButton  alloc]initWithFrame:CGRectMake(0,0,30,30)];
    [rightButton setImage:[UIImage imageNamed:@"search.png"]forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(gotoHistoryArticle)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    
}

- (void)gotoHistoryArticle
{
    HistoryArticleViewController *history = [[HistoryArticleViewController alloc]init];
    
    [self.navigationController pushViewController:history animated:NO];
}


#pragma mark --location
//开始定位
-(void)locationStart{
    //判断定位操作是否被允许
    self.locationManager = [[CLLocationManager alloc] init] ;
    self.locationManager.delegate = self;
    //设置定位精度
    self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLLocationAccuracyHundredMeters;//每隔多少米定位一次（这里的设置为每隔百米)
    if (IOS8) {
        //使用应用程序期间允许访问位置数据
        [self.locationManager requestWhenInUseAuthorization];
    }
    
}
#pragma mark - CoreLocation Delegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusDenied) {
        // The user denied authorization
        NSString *cityname = [[NSUserDefaults standardUserDefaults] objectForKey:@"cityname"];
        NSString *cittyID = [[NSUserDefaults standardUserDefaults] objectForKey:@"cityid"];
        if (cittyID && cityname) {
            // _cityButton.title = cityname;
            [_cityButton setTitle:cityname forState:UIControlStateNormal];
            [self remakeButtonInset];
            [self getBannerData];
            return;
        }
        NSLog(@"%@",@"定位服务当前可能尚未打开，请设置打开！");
        //没开定位权限
        // _cityButton.title = @"北京市";
        [_cityButton setTitle:@"北京市" forState:UIControlStateNormal];
        [self remakeButtonInset];
        [self code4id:@"110100"];
    }
    else if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        // The user accepted authorization
        //        [_cityButton setTitle:@"正在定位中..." forState:UIControlStateNormal];
        //        [self remakeButtonInset];
        [self.locationManager startUpdatingLocation];
    }
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations

{
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [self.locationManager stopUpdatingLocation];
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    CLLocation *currentLocation = [locations lastObject];
    
    //获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error)
     {
         if (array.count >0)
         {
             CLPlacemark *placemark = [array objectAtIndex:0];
             //获取城市
             _currCity = placemark.locality;
             if (!_currCity) {
                 //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                 _currCity = placemark.administrativeArea;
             }
             
             NSString *cityname1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"cityname"];
             NSString *cittyID1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"cityid"];
             if (!(cittyID1 && cityname1)){
               //没有缓存城市
                 
                 [[NSUserDefaults standardUserDefaults]setObject:_currCity forKey:@"cityname"];
                 [_cityButton setTitle:_currCity forState:UIControlStateNormal];
                 [self remakeButtonInset];
                 [self getCityId:_currCity];
                 return ;
                 
                 
             }
            
             
             
             NSString *cityname = [[NSUserDefaults standardUserDefaults] objectForKey:@"cityname"];
             if ([_currCity isEqualToString:cityname]) {
                 [[NSUserDefaults standardUserDefaults]setObject:_currCity forKey:@"cityname"];
                 [self remakeButtonInset];
                 [self getCityId:_currCity];
             }else{
                 UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                                 message:@"定位城市与缓存的城市不同，是否切换到当前定位的城市"
                                                                delegate:self
                                                       cancelButtonTitle:@"取消"
                                                       otherButtonTitles:@"确定", nil];
                 [alert show];
                 
                 
             }
             
             
             
         } else if (error ==nil && [array count] == 0)
         {
             NSLog(@"No results were returned.");
         }else if (error !=nil)
         {
             NSLog(@"An error occurred = %@", error);
         }
         
     }];
    
}
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    if (error.code ==kCLErrorDenied) {
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
    }
    
}


- (void)getCityId:(NSString *)cityName
{
    NSString *str = [NSString stringWithFormat:@"http://restapi.amap.com/v3/config/district"];
    NSDictionary *dic = @{
                          @"key":@"d5679ec2f2927bc73af8f23dfe010ca7",
                          @"keywords":cityName,
                          @"subdistrict":@"2",
                          @"extensions":@"base"
                          
                          };
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerJSON];
    [PPNetworkHelper GET:str parameters:dic success:^(id responseObject) {
        if ([responseObject objectForKey:@"districts"]) {
            NSArray *city = [responseObject objectForKey:@"districts"];
            if (![city isEqual:[NSNull null]] && city.count) {
                NSDictionary *dic = city.firstObject;
                [self code4id:[dic objectForKey:@"adcode"]];
            }
        }
    } failure:^(NSError *error) {
        
    }];
    
}
- (void)code4id:(NSString *)code
{
    
    NSDictionary *dic = @{
                          @"columns":@[@"name",@"id"],
                          @"start":@(0),@"length":@(1),
                          @"filter":@{
                                  @"regionType":@{@"eq":@"city"},
                                  @"code":@{@"eq":code}
                                  },
                          @"table":@"Region"
                          };
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerJSON];
    [PPNetworkHelper POST:kAPICityID parameters:dic success:^(id responseObject) {
        if ([responseObject objectForKey:@"data"]) {
            NSArray *data = [responseObject objectForKey:@"data"];
            if (![data isEqual:[NSNull null]] && data.count) {
                NSDictionary *dic = data.firstObject;
                NSString *cityid = [dic objectForKey:@"id"];
                [[NSUserDefaults standardUserDefaults]setObject:cityid forKey:@"cityid"];
                [self getBannerData];
            }
        }
    } failure:^(NSError *error) {
        
    }];
    
}
- (void) cityPickerController:(GYZChooseCityController *)chooseCityController
                didSelectCity:(NSDictionary *)dic
{

    [_cityButton setTitle:[dic objectForKey:@"name"] forState:UIControlStateNormal];
    //  [self.navigationController.navigationBar reloadInputViews];
    [[NSUserDefaults standardUserDefaults]setObject:[dic objectForKey:@"id"] forKey:@"cityid"];
    [[NSUserDefaults standardUserDefaults]setObject:[dic objectForKey:@"name"] forKey:@"cityname"];
    [self remakeButtonInset];
    [self getBannerData];
}

- (void)remakeButtonInset
{
    [_cityButton sizeToFit];
    [_cityButton setTitleEdgeInsets:UIEdgeInsetsMake(0, - _cityButton.imageView.image.size.width, 0, _cityButton.imageView.image.size.width)];
    [_cityButton setImageEdgeInsets:UIEdgeInsetsMake(0, _cityButton.titleLabel.bounds.size.width, 0, -_cityButton.titleLabel.bounds.size.width)];
    
    
}
#pragma mark -uialertview


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //取消
        NSString *cityname = [[NSUserDefaults standardUserDefaults] objectForKey:@"cityname"];
        NSString *cittyID = [[NSUserDefaults standardUserDefaults] objectForKey:@"cityid"];
        if (cittyID && cityname) {
            // _cityButton.title = cityname;
            [_cityButton setTitle:cityname forState:UIControlStateNormal];
            [self remakeButtonInset];
            [self getBannerData];
            return;
        }else{
            //没有缓存
            
            
        }
        
    }else{
        [[NSUserDefaults standardUserDefaults]setObject:_currCity forKey:@"cityname"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [_cityButton setTitle:_currCity forState:UIControlStateNormal];
        [self remakeButtonInset];
        [self getCityId:_currCity];
        
    }
    
    
}
@end
