//
//  HistoryMapViewController.m
//  caxjh
//
//  Created by niuxinghua on 2017/11/29.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import "HistoryMapViewController.h"
#import "MapTimeSelectView.h"
#import "UIBarButtonItem+UC.h"
#import "UIViewController+StatusBar.h"
#import "Const.h"
#import "YJLocationConverter.h"
#define CLCOORDINATE_EPSILON 0.00005f
#define CLCOORDINATES_EQUAL2( coord1, coord2 ) (fabs(coord1.latitude - coord2.latitude) < CLCOORDINATE_EPSILON && fabs(coord1.longitude - coord2.longitude) < CLCOORDINATE_EPSILON)
@interface HistoryMapViewController (){
    MapTimeSelectView *timeSelectView;
    BMKMapView* mapView;
    CLLocationCoordinate2D startP;
    CLLocationCoordinate2D endP;
    BMKPointAnnotation *startpoint;
    BMKPointAnnotation *endpoint;
    BMKPolyline* polyline;
}
@property (nonatomic,strong)NSMutableArray *dataList;
@end

@implementation HistoryMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    mapView = [[BMKMapView alloc]initWithFrame:self.view.bounds];
    [mapView setZoomLevel:21];
    mapView.delegate = self;
    timeSelectView = [[MapTimeSelectView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100) showInController:self];
    [mapView addSubview:timeSelectView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem uc_backBarButtonItemWithAction:^{
        [timeSelectView deleteSigles];
        timeSelectView = nil;
        [[NSNotificationCenter defaultCenter]removeObserver:self];
        [self.navigationController popViewControllerAnimated:NO];
    }];
    
    [self setStatusBarDefaultColor];
    
    [self.view addSubview:mapView];
    self.title = @"历史轨迹";
    _dataList = [[NSMutableArray alloc]init];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showTrace:) name:TraceSuccess object:nil];
}

#pragma methods

- (void)showTrace:(NSNotification *)notification
{
    [mapView removeAnnotation:startpoint];
    [mapView removeAnnotation:endpoint];
    [mapView removeOverlay:polyline];
    _dataList = notification.object;
    NSUInteger length = [_dataList count];
    CLLocationCoordinate2D coor[1000] = {0};
    for (int i=0;i<length;i++) {
        NSDictionary *dic = [_dataList objectAtIndex:i];
        coor[i].latitude =  [[dic objectForKey:@"latitude"] doubleValue];
        coor[i].longitude =[[dic objectForKey:@"longitude"] doubleValue];
        coor[i] = [YJLocationConverter yj_WGS84ConvertToBD09:coor[i]];
    }
    if (length > 1) {
        endP = coor[0];
        startP = coor[length-1];
        
        
        polyline = [BMKPolyline polylineWithCoordinates:coor count:length];
        [mapView addOverlay:polyline];
        
        if (!startpoint) {
            startpoint = [[BMKPointAnnotation alloc]init];
        }
        
        if (!endpoint) {
            endpoint = [[BMKPointAnnotation alloc]init];
        }
        startpoint.coordinate = startP;
        endpoint.coordinate = endP;
        
        [mapView addAnnotation:startpoint];
        
        [mapView addAnnotation:endpoint];
        
        CLLocationCoordinate2D test = CLLocationCoordinate2DMake(coor[0].latitude, coor[0].longitude);
        [mapView setCenterCoordinate:test];
        
        
        
    }
    
   
    
    
    
}


- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation{
    BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
    newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
    // newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
    newAnnotationView.annotation=annotation;
    if (CLCOORDINATES_EQUAL2(annotation.coordinate,startP)) {
        newAnnotationView.image = [UIImage imageNamed:@"start"];
    }
    if (CLCOORDINATES_EQUAL2(annotation.coordinate,endP)) {
        newAnnotationView.image = [UIImage imageNamed:@"end"];
    }
    //把大头针换成别的图片
    
    //newAnnotationView.size = CGSizeMake(23, 23);
    return newAnnotationView;
}

#pragma mark -map delegate
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay
{
    
    if ([overlay isKindOfClass:[BMKCircle class]]){
        BMKCircleView* circleView = [[BMKCircleView alloc] initWithOverlay:overlay] ;
        circleView.fillColor = [UIColor colorWithRed:249/255.0 green:238/255.0 blue:236/255.0 alpha:0.4];
        //216 170 152
        circleView.strokeColor = [UIColor colorWithHex:@"#ff6767"];
        circleView.lineWidth = 0.2;
        
        return circleView;
    }
    
    if ([overlay isKindOfClass:[BMKGroundOverlay class]]){
        BMKGroundOverlayView *groundView = [[BMKGroundOverlayView alloc] initWithOverlay:overlay];
        return groundView;
    }
    if ([overlay isKindOfClass:[BMKPolyline class]]){
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.strokeColor = [UIColor colorWithRed:244/255.0 green:179/255.0 blue:173/255.0 alpha:0.6];
        polylineView.lineWidth = 2.0;
        
        return polylineView;
    }
    
    return nil;
    
    
    
    
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
@end
