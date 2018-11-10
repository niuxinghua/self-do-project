//
//  MapTimeSelectView.m
//  caxjh
//
//  Created by niuxinghua on 2017/11/27.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import "MapTimeSelectView.h"
#import "Masonry.h"
#import "UIColor+EAHexColor.h"
#import "TimeSelectButton.h"
#import "HZQDatePickerView.h"
#import "DateFormatterHelper.h"
#import "SocketManager.h"
#import "NSDate+fish_Extension.h"
#import "StartPicker.h"
#import "EndPicker.h"
@interface MapTimeSelectView ()<HZQDatePickerViewDelegate>

@property (nonatomic,strong)TimeSelectButton *timeButton;
@property (nonatomic,strong)TimeSelectButton *leftButton;
@property (nonatomic,strong)TimeSelectButton *rightButton;

@property (nonatomic,strong)UILabel *leftLable;
@property (nonatomic,strong)UILabel *rightLable;

@property (nonatomic,strong)UIView *lineView;

@property (nonatomic,weak)UIViewController *rootController;
@property (nonatomic,strong)HZQDatePickerView *startpickerView;
@property (nonatomic,strong)HZQDatePickerView *endpickerView;
@property (nonatomic,strong)HZQDatePickerView *pickerView;
@property (nonatomic,assign)BOOL shouldshowLeft;
@property (nonatomic,assign)BOOL shouldshowRight;


@property (nonatomic,copy)NSString *dateStr;
@property (nonatomic,copy)NSString *startStr;
@property (nonatomic,copy)NSString *endStr;

@end
@implementation MapTimeSelectView
static id mapTimeSelectView = nil;
+ (id)allocWithZone:(struct _NSZone *)zone {
    if (!mapTimeSelectView) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            mapTimeSelectView = [super allocWithZone:zone];
        });
    }
    return mapTimeSelectView;
}
- (id)init {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mapTimeSelectView = [super init];
        
        }
    );
    return mapTimeSelectView;
}
+ (instancetype)sharedInstance {
    return [[self alloc] init];
}
- (instancetype)initWithFrame:(CGRect)frame showInController:(UIViewController *)controller
{
    if (self = [super init]) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            self.frame = frame;
            NSDate *now = [NSDate date];
            NSString *showStr = [DateFormatterHelper getDateStrFromDate:now dateStyle:kDateStyleLine3];
            _dateStr = [showStr copy];
            showStr = [NSString stringWithFormat:@"%@,%@",showStr,[self weekdayStringFromDate:now]];
            _timeButton = [[TimeSelectButton alloc]init];
            [_timeButton setTitle:showStr forState:UIControlStateNormal];
            _timeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
            [_timeButton setTitleColor:[UIColor colorWithHex:@"#6b6b6b"] forState:UIControlStateNormal];
            [_timeButton setImage:[UIImage imageNamed:@"downarrow.png"]  forState:UIControlStateNormal];
            
            [_timeButton addTarget:self action:@selector(didtouchPickDatebutton) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:_timeButton];
            
            _lineView = [[UIView alloc]init];
            _lineView.backgroundColor = [UIColor colorWithHex:@"#e1e1e1"];
            
            [self addSubview:_lineView];
            
            
            
            _leftButton = [[TimeSelectButton alloc]init];
            [_leftButton setTitleColor:[UIColor colorWithHex:@"#48c85d"] forState:UIControlStateNormal];
            _leftButton.titleLabel.font = [UIFont systemFontOfSize:13];
            [_leftButton setTitle:@"起点" forState:UIControlStateNormal];
            [_leftButton setImage:[UIImage imageNamed:@"downarrow.png"]  forState:UIControlStateNormal];
            _leftButton.titleLabel.textAlignment = NSTextAlignmentCenter;
            [self addSubview:_leftButton];
            [_leftButton addTarget:self action:@selector(didtouchPickStartTimebutton) forControlEvents:UIControlEventTouchUpInside];
            
            
            
            
            _rightButton = [[TimeSelectButton alloc]init];
            [_rightButton setTitleColor:[UIColor colorWithHex:@"#ff6767"] forState:UIControlStateNormal];
            _rightButton.titleLabel.font = [UIFont systemFontOfSize:13];
            [_rightButton setTitle:@"终点" forState:UIControlStateNormal];
            [_rightButton setImage:[UIImage imageNamed:@"downarrow.png"]  forState:UIControlStateNormal];
            _rightButton.titleLabel.textAlignment = NSTextAlignmentCenter;
            
            [_rightButton addTarget:self action:@selector(didtouchPickEndTimebutton) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:_rightButton];
            
            _leftLable = [[UILabel alloc]init];
            _leftLable.font = [UIFont systemFontOfSize:16];
            _leftLable.textColor = [UIColor colorWithHex:@"#333333"];
            _leftLable.textAlignment = NSTextAlignmentCenter;
            
            _rightLable = [[UILabel alloc]init];
            _rightLable.font = [UIFont systemFontOfSize:16];
            _rightLable.textColor = [UIColor colorWithHex:@"#333333"];
            _rightLable.textAlignment = NSTextAlignmentCenter;
            _leftLable.text = @"00:01";
            _startStr  = [_leftLable.text copy];
            
            _rightLable.text = @"23:59";
            _endStr = [_rightLable.text copy];
            
            [self addSubview:_leftLable];
            [self addSubview:_rightLable];
            self.backgroundColor = [UIColor whiteColor];
            
            
        });
        
        _rootController = controller;
        
         [[SocketManager sharedInstance] dogetTraceData:[self getStartTimeStap] endTime:[self getEndTimeStap]];
    }
    
    
    return self;
    
}

- (void)layoutSubviews
{
    
    [super layoutSubviews];
    
    [_timeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        // make.centerY.equalTo(self.mas_centerY);
        make.top.equalTo(self.mas_top);
        make.height.equalTo (@40);
        make.width.equalTo(@250);
    }];
    
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.mas_top).offset(40);
        make.height.equalTo(@0.5);
    }];
    
    CGFloat leftCenter = self.frame.size.width/4.0 - 30;
    CGFloat rightCenter = self.frame.size.width/4.0 * 3 - 30;
    [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@60);
        make.height.equalTo(@30);
        make.top.equalTo(self.mas_top).offset(40);
        make.left.equalTo(self.mas_left).offset(leftCenter);
    }];
    [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@60);
        make.height.equalTo(@30);
        make.top.equalTo(self.mas_top).offset(40);
        make.left.equalTo(self.mas_left).offset(rightCenter);
    }];
    
    [_leftLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_leftButton.mas_bottom);
        make.width.equalTo(@100);
        make.height.equalTo(@30);
        make.centerX.equalTo(_leftButton.mas_centerX);
    }];
    
    [_rightLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_rightButton.mas_bottom);
        make.width.equalTo(@100);
        make.height.equalTo(@30);
        make.centerX.equalTo(_rightButton.mas_centerX);
    }];
    
}

#pragma mark - methods

- (void)didtouchPickDatebutton
{
    _shouldshowLeft = NO;
    _shouldshowRight = NO;
    _pickerView = [HZQDatePickerView instanceDatePickerView];
    
    _pickerView.frame = CGRectMake(0, 0, _rootController.view.frame.size.width, _rootController.view.frame.size.width + 20);
    
    [_pickerView setBackgroundColor:[UIColor clearColor]];
    
    _pickerView.delegate = self;
    
    [_rootController.view addSubview:_pickerView];
    
    
}
- (void)didtouchPickStartTimebutton
{
    _shouldshowLeft = YES;
    _shouldshowRight = NO;
    _startpickerView = [StartPicker allocWithZone:nil];
    
    _startpickerView.frame = CGRectMake(0, 0, _rootController.view.frame.size.width, _rootController.view.frame.size.width + 20);
    
    [_startpickerView setBackgroundColor:[UIColor clearColor]];
    
    _startpickerView.delegate = self;
    _startpickerView.modeType = UIDatePickerModeTime;
   
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm"];
   //_startpickerView.datePickerView.date = [NSDate dateStrFromCstampTimeStr:[self getStartTime] withDateFormatter:dateFormatter];
    _startpickerView.alpha = 1;
    [_rootController.view addSubview:_startpickerView];
    
    
    
}
- (void)didtouchPickEndTimebutton
{
    _shouldshowLeft = NO;
    _shouldshowRight = YES;
    _endpickerView = [EndPicker allocWithZone:nil];
    
    _endpickerView.alpha = 1;
    _endpickerView.frame = CGRectMake(0, 0, _rootController.view.frame.size.width, _rootController.view.frame.size.width + 20);
    
    [_endpickerView setBackgroundColor:[UIColor clearColor]];
    
    _endpickerView.delegate = self;
    _endpickerView.modeType = UIDatePickerModeTime;
    [_rootController.view addSubview:_endpickerView];
    
    
    
}

- (void)getSelectDate:(NSString *)date type:(DateType)type {
    if (!_shouldshowRight && !_shouldshowLeft) {
        NSArray *array = [date componentsSeparatedByString:@" "];
        date = array[0];
        _dateStr = [date copy];
        NSString *showStr = [NSString stringWithFormat:@"%@ %@",date,[self weekdayStringFromDate:[self.pickerView currentDate]]];
        [_timeButton setTitle:showStr forState:UIControlStateNormal];
        [[SocketManager sharedInstance] dogetTraceData:[self getStartTimeStap] endTime:[self getEndTimeStap]];
        
    }else if(_shouldshowLeft){
        NSArray *array = [date componentsSeparatedByString:@" "];
        NSString *showStr = [NSString stringWithFormat:@"%@",array.lastObject];
        _leftLable.text = showStr;
        _startStr = [showStr copy];
        [[SocketManager sharedInstance] dogetTraceData:[self getStartTimeStap] endTime:[self getEndTimeStap]];
        
    }else{
        NSArray *array = [date componentsSeparatedByString:@" "];
        NSString *showStr = [NSString stringWithFormat:@"%@",array.lastObject];
        _rightLable.text = showStr;
        _endStr = [showStr copy];
        
        [[SocketManager sharedInstance] dogetTraceData:[self getStartTimeStap] endTime:[self getEndTimeStap]];
    }
    
    
}
- (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}


- (NSString *)getStartTimeStap
{
    NSString *str = [NSString stringWithFormat:@"%@ %@",_dateStr,_startStr];
    NSDate *date = [DateFormatterHelper getDateFromDateStr:str dateStyle:kDateStyleLine5];
    date = [self getNowDateFromatAnDate:date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld",(long int)[NSDate cTimestampFromDate:date]*1000];
    return timeSp;
}

- (NSString *)getEndTimeStap
{
    NSString *str = [NSString stringWithFormat:@"%@ %@",_dateStr,_endStr];
    NSDate *date = [DateFormatterHelper getDateFromDateStr:str dateStyle:kDateStyleLine5];
     date = [self getNowDateFromatAnDate:date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long int)[NSDate cTimestampFromDate:date]*1000];
    return timeSp;
}

- (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate
{
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    return destinationDateNow;
}
- (void)dealloc
{
    _startpickerView = nil;
    _endpickerView = nil;
    
}
- (void)deleteSigles
{
    _startpickerView = nil;
    _endpickerView = nil;
    
}
@end
