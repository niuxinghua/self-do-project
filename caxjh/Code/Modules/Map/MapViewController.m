//
//  MapViewController.m
//  caxjh
//
//  Created by niuxinghua on 2017/11/23.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import "MapViewController.h"
#import "Const.h"
#import "PPNetworkHelper.h"
#import "SocketManager.h"
#import "MapPlaceHolder.h"
#import "WatchBindViewController.h"
#import "UIViewController+StatusBar.h"
#import "UIBarButtonItem+UC.h"
#import "LocationGuideView.h"
#import "MapTimeSelectView.h"
#import "VerticalButton.h"
#import "HistoryMapViewController.h"
#import "MapSettingViewController.h"
#import "AddFenceViewController.h"
#import "FenceListViewController.h"
#import "UIButton+WebCache.h"
#import "MapLeftButton.h"
#import "CustomMapLocationView.h"
#import "JMDropMenu.h"
#import "YJLocationConverter.h"
@interface MapViewController ()<BMKMapViewDelegate,BMKGeoCodeSearchDelegate,JMDropMenuDelegate>
{
    BMKMapView* mapView;
    UIView *emptyView;
    BMKPointAnnotation *point;
    LocationGuideView *guideView;
    BMKCircle* circle;
    MapLeftButton *leftbtn;
    UIButton *rightbtn;
    MapTimeSelectView *timeSelectView;
    VerticalButton *historyButton;
    VerticalButton *electronicButton;
    BOOL shouldChoose;
    CustomMapLocationView *newAnnotationView;
}
@property (nonatomic,strong)NSMutableArray *watchArr;

@property (nonatomic,strong)NSDictionary *selectDic;

@property (nonatomic,strong)UIBarButtonItem *leftItem;

@property (nonatomic,strong)UILabel *titleLable;



@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    mapView = [[BMKMapView alloc]initWithFrame:self.view.bounds];
    [mapView setZoomLevel:18];
    mapView.delegate = self;
    emptyView = [[UIView alloc]initWithFrame:self.view.bounds];
    _watchArr = [[NSMutableArray alloc]init];
    leftbtn = [[MapLeftButton alloc]initWithFrame:CGRectMake(0, 0, 40, 60)];
    [leftbtn addTarget:self action:@selector(didtouchLeftButton) forControlEvents:UIControlEventTouchUpInside];
    _leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftbtn];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacer.width = -100;
    [leftbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    leftbtn.changeIconView.hidden = YES;
    self.navigationItem.leftBarButtonItem = _leftItem;
    
    leftbtn.imageView.layer.masksToBounds = YES;
    leftbtn.imageView.layer.cornerRadius = 18;

  
    _titleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 40)];
    _titleLable.font = [UIFont systemFontOfSize:20];
    _titleLable.textColor = [UIColor whiteColor];
    _titleLable.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = _titleLable;
    

  
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    if (!_isFromAlert) {
        rightbtn = [[UIButton alloc]init];
        [rightbtn setTitle:@"设备信息" forState:UIControlStateNormal];
        [rightbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [rightbtn addTarget:self action:@selector(didtouchRightButton) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightbtn];
        [rightbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = rightItem;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getNewLocation:) name:LocationNew object:nil];
        historyButton = [[VerticalButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 50, 25 + 45, 40, 40)];
        historyButton.titleLabel.font = [UIFont systemFontOfSize:8];
        [historyButton setBackgroundColor:[UIColor whiteColor]];
        [historyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [historyButton setTitle:@"历史轨迹" forState:UIControlStateNormal];
        [historyButton setImage:[UIImage imageNamed:@"history.png"] forState:UIControlStateNormal];
        [historyButton addTarget:self action:@selector(gotohistory) forControlEvents:UIControlEventTouchUpInside];
        [mapView addSubview:historyButton];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(watchnamechange) name:@"watchname" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(watchImage) name:@"watchImage" object:nil];
    }
   
    [self setStatusBarDefaultColor];
   
    if (!_isFromAlert) {
        
    
    electronicButton = [[VerticalButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 50, 25, 40, 40)];
    electronicButton.titleLabel.font = [UIFont systemFontOfSize:8];
    [electronicButton setBackgroundColor:[UIColor whiteColor]];
    [electronicButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [electronicButton setTitle:@"电子围栏" forState:UIControlStateNormal];
//    electronicButton setBackgroundImage:[UIImage imageNamed:@"fenceback"] forState:UIControlStateNormal
    [electronicButton setImage:[UIImage imageNamed:@"electronic.png"] forState:UIControlStateNormal];
    [electronicButton addTarget:self action:@selector(gotoFence) forControlEvents:UIControlEventTouchUpInside];
    [mapView addSubview:electronicButton];
    
    }
    
    
    
    
    if (_isFromAlert) {
         [self.view addSubview:mapView];
        _titleLable.text = [_alertDic objectForKey:@"title"];
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem uc_backBarButtonItemWithAction:^{
       
            [[NSNotificationCenter defaultCenter]removeObserver:self];
            [self.navigationController popViewControllerAnimated:NO];
        }];
        
        if ([[_alertDic objectForKey:@"title"] containsString:@"围栏"]) {
            electronicButton.hidden = NO;
        }else
        {
            electronicButton.hidden = YES;
            
        }
        
        CLLocationCoordinate2D coor ;
            coor.latitude =  [[_alertDic objectForKey:@"latitude"] doubleValue];
            coor.longitude =[[_alertDic objectForKey:@"longitude"] doubleValue];
            coor= [YJLocationConverter yj_WGS84ConvertToBD09:coor];
        if (!point) {
            point = [[BMKPointAnnotation alloc]init];
        }
        [mapView setCenterCoordinate:coor];
        circle = [BMKCircle circleWithCenterCoordinate:coor radius:0];
        [mapView addOverlay:circle];
        point.coordinate = coor;
        [mapView addAnnotation:point];
        
    }
    
    
    
}





#pragma mark -location

- (LocationGuideView *)getLocationGuideView
{
    if (!guideView) {
        guideView = [[LocationGuideView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 60, self.view.frame.size.width, 60)];
        [mapView addSubview:guideView];
        [mapView bringSubviewToFront:guideView];
    }
    
    return guideView;
}
- (void)getNewLocation:(NSNotification *)notification
{
    if (!point) {
        point = [[BMKPointAnnotation alloc]init];
    }
    
    [mapView removeAnnotation:point];
    CLLocationCoordinate2D test=CLLocationCoordinate2DMake([[notification.object objectForKey:@"latitude"] doubleValue], [[notification.object objectForKey:@"longitude"] doubleValue]);
    NSDictionary *testdic =BMKConvertBaiduCoorFrom(test,BMK_COORDTYPE_GPS);
    //转换GPS坐标至百度坐标
    NSString *xstr=[testdic objectForKey:@"x"];
    NSString *ystr=[testdic objectForKey:@"y"];
    NSData *xdata=[[NSData alloc] initWithBase64EncodedString:xstr options:0];
    NSData *ydata=[[NSData alloc] initWithBase64EncodedString:ystr options:0];
    NSString *xlat=[[NSString alloc] initWithData:ydata encoding:NSUTF8StringEncoding];
    NSString *ylng=[[NSString alloc] initWithData:xdata encoding:NSUTF8StringEncoding];
    test.latitude=[xlat doubleValue];
    test.longitude=[ylng doubleValue];
    
    [mapView setCenterCoordinate:test animated:YES];
    point.coordinate = test;
    if (circle) {
    [mapView removeOverlay:circle];
        circle = nil;
    }
    
    circle = [BMKCircle circleWithCenterCoordinate:test radius:200];
    [mapView addOverlay:circle];
    [mapView addAnnotation:point];
    BMKGeoCodeSearch *_geoCodeSearch = [[BMKGeoCodeSearch alloc]init];
    _geoCodeSearch.delegate = self;
    BMKReverseGeoCodeOption *reverseGeoCodeOption= [[BMKReverseGeoCodeOption alloc] init];
    reverseGeoCodeOption.reverseGeoPoint = point.coordinate;
    [_geoCodeSearch reverseGeoCode:reverseGeoCodeOption];
   
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    if (!_selectDic && !_isFromAlert) {
        
        [self getWatches];
    }
    
}
#pragma mark - api

- (void)showAvatar
{
    
    
    
    
}
- (void)getWatches
{
    NSString *userID = [[NSUserDefaults standardUserDefaults] stringForKey:@"USER_ID"];
    NSDictionary *dic = @{@"table":@"Member",@"columns":@[@"id",@{@"watch":@[@"name",@"imei",@"id",@"phone",@"image"]}],@"filter":@{@"id":@{@"eq":userID}}};
    
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerJSON];
    [PPNetworkHelper POST:kAPIQueryWatch parameters:dic success:^(id responseObject) {
        if (responseObject) {
            NSArray *data = [responseObject objectForKey:@"data"];
            if(data && ![data isEqual:[NSNull null]] && [data count]){
                NSDictionary *dicdata = data[0];
                NSArray *watches = [dicdata objectForKey:@"watch"];
                if (![watches isEqual:[NSNull null]] && [watches count]) {
                    _watchArr = watches.mutableCopy;
                    [SocketManager sharedInstance].watchArray = _watchArr.mutableCopy;
                    if (shouldChoose) {
                        shouldChoose = NO;
                        return ;
                    }
                    NSDictionary *dic = watches[0];
                  //  [leftbtn setTitle:[dic objectForKey:@"name"] forState:UIControlStateNormal];
                   // [leftbtn.titleLabel sizeToFit];
                    //leftbtn.title = [dic objectForKey:@"name"];
                    _selectDic = dic;
                    [[[SDWebImageManager sharedManager] imageDownloader] downloadImageWithURL:[NSURL URLWithString:[dic objectForKey:@"image"]] options:SDWebImageDownloaderLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                        
                    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                        if (error) {
                            [leftbtn setImage:[self imageByScalingAndCroppingForSize:CGSizeMake(40, 40) image:[UIImage imageNamed:@"uploaddevice"]] forState:UIControlStateNormal];
                            leftbtn.changeIconView.hidden = NO;
                        }
                        else{
                            [leftbtn setImage:[self imageByScalingAndCroppingForSize:CGSizeMake(30, 30) image:image] forState:UIControlStateNormal];
                            leftbtn.changeIconView.hidden = NO;
                        }
                    }];
                    _titleLable.text = [_selectDic objectForKey:@"name"];
                    //self.tabBarItem.title = @"地图";
                    [SocketManager sharedInstance].locationDic = dic;
                    [self.view addSubview:mapView];
                    [self getLocationGuideView];
                    [[SocketManager sharedInstance] connectToServer];
                    [self beginGetLocation:[dic objectForKey:@"imei"]];
                }else{
                    MapPlaceHolder *holder = [[MapPlaceHolder alloc]initWithFrame:self.view.bounds];
                    [self.view addSubview:holder];
                    holder.bindBlock = ^{
                        WatchBindViewController *bind = [[WatchBindViewController alloc]init];
                         bind.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:bind animated:NO];
                        
                        
                        
                    };
                    
                }
                
                
            }else{
                MapPlaceHolder *holder = [[MapPlaceHolder alloc]initWithFrame:self.view.bounds];
                holder.bindBlock = ^{
                    WatchBindViewController *bind = [[WatchBindViewController alloc]init];
                    bind.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:bind animated:NO];
                    
                    
                    
                };
                
                [self.view addSubview:holder];
                
            }
        }
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark - methods

- (void)watchnamechange
{
    
    
    NSDictionary *dic = [SocketManager sharedInstance].locationDic;
   // [leftbtn setTitle:[dic objectForKey:@"name"] forState:UIControlStateNormal];
    _titleLable.text = [_selectDic objectForKey:@"name"];
    shouldChoose = YES;
    [self getWatches];
}

- (void)watchImage
{
    NSDictionary *dic = [SocketManager sharedInstance].locationDic;
    [[[SDWebImageManager sharedManager] imageDownloader] downloadImageWithURL:[NSURL URLWithString:[dic objectForKey:@"image"]] options:SDWebImageDownloaderLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        if (error) {
            [leftbtn setImage:[UIImage imageNamed:@"uploaddevice"] forState:UIControlStateNormal];
        }
        else{
            [leftbtn setImage:[self imageByScalingAndCroppingForSize:CGSizeMake(44, 44) image:image] forState:UIControlStateNormal];
        }
    }];
    shouldChoose = YES;
    [self getWatches];
    
}

- (void)gotohistory

{
    HistoryMapViewController *history  = [[HistoryMapViewController alloc]init];
    history.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:history animated:NO];
    
    
    
}

- (void)gotoFence

{
    FenceListViewController *fencelist = [[FenceListViewController alloc]init];
    fencelist.hidesBottomBarWhenPushed = YES;
     [self.navigationController pushViewController:fencelist animated:NO];
  
    
    
}
- (void)didtouchRightButton
{
    
    if(!_selectDic)
    {
     
        [self.view makeToast:@"您还未绑定过手表，请先添加设备"];
        
        return;
        
    }
    
    MapSettingViewController *mapsetting  = [[MapSettingViewController alloc]init];
    mapsetting.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:mapsetting animated:NO];
    
    
}

//选择框的回调
- (void)didSelectRowAtIndex:(NSInteger)index Title:(NSString *)title Image:(NSString *)image
{
    if (_selectDic) {
        [self endGetLocation:[_selectDic objectForKey:@"imei"]];
    }
    if (index == (_watchArr.count)) {
        WatchBindViewController *bind = [[WatchBindViewController alloc]init];
        bind.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:bind animated:NO];
        return;
    }
    NSDictionary *dic = [_watchArr objectAtIndex:index];
    [[[SDWebImageManager sharedManager] imageDownloader] downloadImageWithURL:[NSURL URLWithString:[dic objectForKey:@"image"]] options:SDWebImageDownloaderLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        if (error) {
            [leftbtn setImage:[self imageByScalingAndCroppingForSize:CGSizeMake(30, 30) image:[UIImage imageNamed:@"uploaddevice"]] forState:UIControlStateNormal];
            
        }
        else{
            [leftbtn setImage:[self imageByScalingAndCroppingForSize:CGSizeMake(30, 30) image:image] forState:UIControlStateNormal];
        }
        [newAnnotationView setHeadImage:[self imageByScalingAndCroppingForSize:CGSizeMake(30, 30) image:image]];
    }];
    _selectDic = dic;
    _titleLable.text = [_selectDic objectForKey:@"name"];
    
    [SocketManager sharedInstance].locationDic = dic;
    //            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [self beginGetLocation:[_selectDic objectForKey:@"imei"]];
    //            });
    
    
}
- (void)didtouchLeftButton
{
    NSMutableArray *titleArr = [[NSMutableArray alloc]init];
    NSMutableArray *imageArr = [[NSMutableArray alloc]init];
    for(NSDictionary *dic in _watchArr) {
        [titleArr addObject:[dic objectForKey:@"name"]];
        [imageArr addObject:[dic objectForKey:@"image"]];
    }
    if (_watchArr.count) {
        //last objetc for  addxxxx
        [titleArr addObject:@"添加新设备"];
        [JMDropMenu showDropMenuFrame:CGRectMake(15, 70, 130, titleArr.count * 40 + 5) ArrowOffset:25.f TitleArr:titleArr ImageArr:imageArr Type:JMDropMenuTypeWeChat LayoutType:JMDropMenuLayoutTypeNormal RowHeight:40.f Delegate:self];
    }
    
    
    
    return;
    //todo change imagelist
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    alertController.popoverPresentationController.sourceView = self.view;
    alertController.popoverPresentationController.sourceRect = CGRectMake(0, 0, 1.0, 1.0);
    
    for(NSDictionary *dic in _watchArr)
    {
        UIAlertAction *actionTeacher = [UIAlertAction actionWithTitle:[dic objectForKey:@"name"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (_selectDic) {
                [self endGetLocation:[_selectDic objectForKey:@"imei"]];
            }
           // leftbtn.title = [dic objectForKey:@"name"];
          //  [leftbtn setTitle:[dic objectForKey:@"name"] forState:UIControlStateNormal];
            [[[SDWebImageManager sharedManager] imageDownloader] downloadImageWithURL:[NSURL URLWithString:[dic objectForKey:@"image"]] options:SDWebImageDownloaderLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                
            } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                if (error) {
                     [leftbtn setImage:[self imageByScalingAndCroppingForSize:CGSizeMake(30, 30) image:[UIImage imageNamed:@"uploaddevice"]] forState:UIControlStateNormal];
                   
                }
                else{
                 [leftbtn setImage:[self imageByScalingAndCroppingForSize:CGSizeMake(30, 30) image:image] forState:UIControlStateNormal];
                }
                 [newAnnotationView setHeadImage:[self imageByScalingAndCroppingForSize:CGSizeMake(30, 30) image:image]];
            }];
            _selectDic = dic;
           _titleLable.text = [_selectDic objectForKey:@"name"];
           
            [SocketManager sharedInstance].locationDic = dic;
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self beginGetLocation:[_selectDic objectForKey:@"imei"]];
//            });
        }];
        [alertController addAction:actionTeacher];
        
    }
    UIAlertAction *addAction = [UIAlertAction actionWithTitle:@"添加设备" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        WatchBindViewController *bind = [[WatchBindViewController alloc]init];
        bind.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:bind animated:NO];
        
    }];
    [alertController addAction:addAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self.navigationController presentViewController:alertController animated:YES completion:^{
        
    }];
    
}

- (void)beginGetLocation:(NSString *)imei
{
    
    [[SocketManager sharedInstance]beginGetLocation:imei];
    
}
- (void)endGetLocation:(NSString *)imei
{
    
    [[SocketManager sharedInstance]endGetLocation:imei];
    
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}

#pragma mark - mapview delegate

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation{
    if (!newAnnotationView) {
        newAnnotationView = [[CustomMapLocationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        
    }
   // newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
    newAnnotationView.annotation = annotation;
     //把大头针换成别的图片
    NSDictionary *dic = [SocketManager sharedInstance].locationDic;
    [[[SDWebImageManager sharedManager] imageDownloader] downloadImageWithURL:[NSURL URLWithString:[dic objectForKey:@"image"]] options:SDWebImageDownloaderLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        if (error) {
            
            [newAnnotationView setHeadImage:[UIImage imageNamed:@"uploaddevice"]];
             newAnnotationView.image = [UIImage imageNamed:@"datouzhen"];
        }
        else{
            [newAnnotationView setHeadImage:[self imageByScalingAndCroppingForSize:CGSizeMake(40, 40) image:image]];
             newAnnotationView.image = [UIImage imageNamed:@"datouzhen"];
        }
        
    }];
    //newAnnotationView.size = CGSizeMake(23, 23);
    return newAnnotationView;
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
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    
    guideView.bottomLable.text = result.address;
    
}
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize image:(UIImage *)img
{
    UIGraphicsBeginImageContext(targetSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [img drawInRect:CGRectMake(0,0,targetSize.width,targetSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
  
}
@end
