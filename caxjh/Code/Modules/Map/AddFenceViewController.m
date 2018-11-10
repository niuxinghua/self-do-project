//
//  AddFenceViewController.m
//  caxjh
//
//  Created by niuxinghua on 2017/11/30.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import "AddFenceViewController.h"
#import "UIBarButtonItem+UC.h"
#import "Masonry.h"
#import "AddFenceView.h"
#import "PPNetworkHelper.h"
#import "SocketManager.h"
#import "UIView+Toast.h"
#import "YJLocationConverter.h"
@interface AddFenceViewController ()<BMKMapViewDelegate,BMKGeoCodeSearchDelegate,BMKLocationServiceDelegate>
{
    BMKMapView* mapView;
    BMKLocationService *_locService;
    AddFenceView *addFence;
    UIImageView *point;
    BMKGeoCodeSearch *_geoCodeSearch;
    BMKCircle* circle;
    
}
@property(nonatomic,assign)BOOL hasShow;
@property(nonatomic,assign)BOOL hasShowlocation;
@property(nonatomic,assign)CGFloat currentRadius;

@property (nonatomic,assign)CGFloat latitude;

@property (nonatomic,assign)CGFloat longtitudetude;

@end

@implementation AddFenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem uc_backBarButtonItemWithAction:^{
        [self.navigationController popViewControllerAnimated:NO];
    }];
    self.title = @"电子围栏";
    
    
    mapView = [[BMKMapView alloc]init];
    [mapView setZoomLevel:16];
    mapView.delegate = self;
    _currentRadius = 200;
    [self.view addSubview:mapView];
    
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    if (!_dic) {
     [_locService startUserLocationService];
    }
    __weak AddFenceViewController * weakSelf = self;
    addFence = [[AddFenceView alloc]init];
    addFence.dic = [_dic copy];
    addFence.block = ^(CGFloat radius) {
        weakSelf.currentRadius = radius;
        [weakSelf didChangeSlider:radius];
    };
    addFence.confirmBlock = ^(NSString *name, NSString *radius, NSString *alarmType, NSString *state,NSString *ad) {
        
        [weakSelf confirm:name radius:radius alarm:alarmType state:state ad:ad];
        
    };
    
    [self.view addSubview:addFence];
    
    //addFence.backgroundColor = [UIColor blueColor];
    point = [[UIImageView alloc]init];
    point.image = [UIImage imageNamed:@"smallmap"];
    [mapView addSubview:point];
    
    
    [self makeConstrains];
    if (_dic) {
        _latitude = [[_dic objectForKey:@"latitude"] floatValue];
        _longtitudetude = [[_dic objectForKey:@"longitude"] floatValue];
        mapView.showsUserLocation = YES;//显示定位图层
        CLLocationCoordinate2D userLocation = CLLocationCoordinate2DMake(_latitude, _longtitudetude);
        [mapView setCenterCoordinate:userLocation];
        _hasShowlocation = YES;
        _hasShow = YES;
       self.currentRadius =  [[_dic objectForKey:@"radius"] floatValue];
       // [self didChangeSlider:[[_dic objectForKey:@"radius"] floatValue]];
        if (![[_dic objectForKey:@"location"] isEqual:[NSNull null]]) {
            [addFence setTopAddress:[_dic objectForKey:@"location"]];
            [addFence setBootomAddress:[_dic objectForKey:@"location"]];
        }
       
    }
    UITapGestureRecognizer *re = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endEdit)];
    
    [self.view addGestureRecognizer:re];
   
}

- (void)endEdit
{
    
    [self.view endEditing:YES];
    
}

#pragma mark - mapdelegate

//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //NSLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    if (!_hasShow && !_dic) {
        mapView.showsUserLocation = YES;//显示定位图层
        [mapView setCenterCoordinate:userLocation.location.coordinate];
        _latitude = userLocation.location.coordinate.latitude;
        _longtitudetude = userLocation.location.coordinate.longitude;
        _hasShow = YES;
    }
}
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if (circle) {
        [mapView removeOverlay:circle];
        circle = nil;
    }
    NSLog(@"change-----");
    CLLocationCoordinate2D centerCoordinate = mapView.region.center;
    
    if (!_geoCodeSearch) {
        _geoCodeSearch = [[BMKGeoCodeSearch alloc]init];
        _geoCodeSearch.delegate = self;
    }
    [self didChangeSlider:self.currentRadius];
    BMKReverseGeoCodeOption *reverseGeoCodeOption= [[BMKReverseGeoCodeOption alloc] init];
    reverseGeoCodeOption.reverseGeoPoint = centerCoordinate;
    _latitude = centerCoordinate.latitude;
    _longtitudetude = centerCoordinate.longitude;
    [_geoCodeSearch reverseGeoCode:reverseGeoCodeOption];
    
}
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    
    [self didChangeSlider:self.currentRadius];
    if (!_hasShowlocation) {
        [addFence setTopAddress:result.sematicDescription];
        
        [addFence setBootomAddress:result.address];
    }
    
    _hasShowlocation = NO;
    
    
}

- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay
{
    
    if ([overlay isKindOfClass:[BMKCircle class]]){
        BMKCircleView* circleView = [[BMKCircleView alloc] initWithOverlay:overlay] ;
        circleView.fillColor = [UIColor colorWithRed:249/255.0 green:238/255.0 blue:236/255.0 alpha:0.4];
        circleView.strokeColor = [UIColor colorWithHex:@"#ff6767"];
        circleView.lineWidth = 0.2;
        
        return circleView;
    }
    
    if ([overlay isKindOfClass:[BMKGroundOverlay class]]){
        BMKGroundOverlayView *groundView = [[BMKGroundOverlayView alloc] initWithOverlay:overlay];
        return groundView;
    }
    
    return nil;
    
    
    
    
}

#pragma mark -methods
- (void)didChangeSlider:(CGFloat)radisu
{
    if (circle) {
        [mapView removeOverlay:circle];
        circle = nil;
    }
    circle = [BMKCircle circleWithCenterCoordinate:mapView.region.center radius:radisu];
    [mapView addOverlay:circle];
    
}
//编辑围栏信息
//https://children.xiangjianhai.com:998/app/update?token=7205589feec837eba4ae654e200daa40
//{ "table": "Fence",
//    "fields":{
//        "name":"电子围栏4",
//        "latDireaction":"E",
//        "latitude":"120.62367",
//        "lonDirection":"N",
//        "longitude":"36.82384782478",
//        "radius":"200",
//        "alarmType":"outFenceAlarm",
//        "state":"yes"
//    },
//    "id":"bbb1af9e5fe6f1f6015fe720faf70009"
//}
//返回：
//{
//    "type": "success",
//    "code": "0",
//    "text": "ok",
//    "error": null,
//    "data": null
//}
//dic = @{
//
//        @"table": @"Fence",
//        @"fields":@{
//                @"name":name,
//                @"latDireaction":@"E",
//                @"latitude":latitude,
//                @"lonDirection":@"N",
//                @"longitude":longtitude,
//                @"radius":radius,
//                @"alarmType":alarmType,
//                @"state":state,
//                },
//        @"id":[_dic objectForKey:@"id"]
//
//        }.mutableCopy;


//NSString *name, NSString *radius, NSString *alarmType, NSString *state
- (void)confirm:(NSString *)name radius:(NSString *)radius alarm:(NSString *)alarmType state:(NSString *)state ad:(NSString *)loc
{

    
    CLLocationCoordinate2D current = [YJLocationConverter yj_BD09ConvertToWGS84:mapView.centerCoordinate];
    NSString *latitude = [NSString stringWithFormat:@"%f",current.latitude];
    NSString *longtitude = [NSString stringWithFormat:@"%f",current.longitude];
    NSDictionary *locationDic = [SocketManager sharedInstance].locationDic;
    NSString *watchId = [locationDic objectForKey:@"id"];
    
    NSMutableDictionary *dic = @{
                          
                          @"table": @"Fence",
                                  @"fields":@{
                                      @"name":name,
                                      @"location":loc,
                                      @"latDireaction":@"E",
                                      @"latitude":latitude,
                                      @"lonDirection":@"N",
                                      @"longitude":longtitude,
                                      @"radius":[NSNumber numberWithInt:[radius intValue]],
                                      @"alarmType":alarmType,
                                      @"state":state,
                                      @"watch.id":watchId}
                          
                          
                          
                          }.mutableCopy;
    
    
    if (_dic) {
        
        dic = @{
                
                @"table": @"Fence",
                @"fields":@{
                        @"name":name,
                        @"location":loc,
                        @"latDireaction":@"E",
                        @"latitude":latitude,
                        @"lonDirection":@"N",
                        @"longitude":longtitude,
                        @"radius":[NSNumber numberWithInt:[radius intValue]],
                        @"alarmType":alarmType,
                        @"state":state,
                        },
                @"id":[_dic objectForKey:@"id"]
                
                }.mutableCopy;
    }
    NSString *url = kAPIAddFence;
    if (_dic) {
        url = kAPIEditFence;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    [PPNetworkHelper POST:url parameters:dic success:^(id responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue] == 0) {
            [MBProgressHUD hideHUDForView:self.view animated:NO];
            [self.view makeToast:@"成功"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"didaddsuccess" object:nil];
            [self.navigationController popViewControllerAnimated:NO];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
    }];
    
    
}
#pragma mark -layout

- (void)makeConstrains
{
    [mapView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.mas_topLayoutGuide);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@300);
        
    }];
    [point mas_makeConstraints:^(MASConstraintMaker *make) {

        make.width.height.equalTo(@40);
        make.centerX.equalTo(mapView.mas_centerX);
        make.centerY.equalTo(mapView.mas_centerY);
    }];
    
    [addFence mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(mapView.mas_bottom);
    }];
}

@end
