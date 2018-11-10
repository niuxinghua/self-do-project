//
//  SendKeyBottomAlarmView.m
//  IntelligentLock
//
//  Created by niuxinghua on 2018/3/9.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "SendKeyBottomAlarmView.h"
#import "SendKeyBottomTimeSelectView.h"
#import "Masonry.h"
#import "MultiCheckboxView.h"
#import "Const.h"
@interface SendKeyBottomAlarmView()

@property (nonatomic,strong)MultiCheckboxView *checkBoxView;
@end
@implementation SendKeyBottomAlarmView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _timeView = [[SendKeyBottomTimeSelectView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 60) style:DateStyleShowHourMinute];
        _checkBoxView = [[MultiCheckboxView alloc]initWithFrame:CGRectMake(10, 70, kScreenWidth, 200)];
        
        
        [self addSubview:_timeView];
        [self addSubview:_checkBoxView];
        
        NSArray *testArray = [[NSArray alloc] initWithObjects:
                              [kMultiTool getMultiLanByKey:@"zhouyi"],
                              [kMultiTool getMultiLanByKey:@"zhouer"],
                              [kMultiTool getMultiLanByKey:@"zhousan"],
                              [kMultiTool getMultiLanByKey:@"zhousi"],
                              [kMultiTool getMultiLanByKey:@"zhouwu"],
                              [kMultiTool getMultiLanByKey:@"zhouliu"],
                              [kMultiTool getMultiLanByKey:@"zhoutian"],
                              [kMultiTool getMultiLanByKey:@"meitian"],
                              nil];
        
        [_checkBoxView setAutoResizeHeight:NO];
        
        [_checkBoxView setCheckboxItems:testArray];
        
        
    }
    
    return self;
}

- (NSString *)getDayJson
{
    NSString *strtoreturn = @"";
    NSArray *array =   _checkBoxView.selectedCheckboxItems;
    if ([array containsObject:[kMultiTool getMultiLanByKey:@"meitian"]]) {
        strtoreturn = @"-1";
        return strtoreturn;
    }
    if ([array containsObject:[kMultiTool getMultiLanByKey:@"zhouyi"]]) {
        strtoreturn = [NSString stringWithFormat:@"1"];
    }
    if ([array containsObject:[kMultiTool getMultiLanByKey:@"zhouer"]]) {
        if ([strtoreturn isEqualToString:@""]) {
            strtoreturn = [NSString stringWithFormat:@"2"];
        }else
        {
          strtoreturn = [NSString stringWithFormat:@"%@,2",strtoreturn];
        }
    }
    if ([array containsObject:[kMultiTool getMultiLanByKey:@"zhousan"]]) {
        if ([strtoreturn isEqualToString:@""]) {
            strtoreturn = [NSString stringWithFormat:@"3"];
        }else
        {
            strtoreturn = [NSString stringWithFormat:@"%@,3",strtoreturn];
        }
    }
    if ([array containsObject:[kMultiTool getMultiLanByKey:@"zhousi"]]) {
        if ([strtoreturn isEqualToString:@""]) {
            strtoreturn = [NSString stringWithFormat:@"4"];
        }else
        {
            strtoreturn = [NSString stringWithFormat:@"%@,4",strtoreturn];
        }
    }
    if ([array containsObject:[kMultiTool getMultiLanByKey:@"zhouwu"]]) {
        if ([strtoreturn isEqualToString:@""]) {
            strtoreturn = [NSString stringWithFormat:@"5"];
        }else
        {
            strtoreturn = [NSString stringWithFormat:@"%@,5",strtoreturn];
        }
    }
    if ([array containsObject:[kMultiTool getMultiLanByKey:@"zhouliu"]]) {
        if ([strtoreturn isEqualToString:@""]) {
            strtoreturn = [NSString stringWithFormat:@"6"];
        }else
        {
            strtoreturn = [NSString stringWithFormat:@"%@,6",strtoreturn];
        }
    }
    if ([array containsObject:[kMultiTool getMultiLanByKey:@"zhoutian"]]) {
        if ([strtoreturn isEqualToString:@""]) {
            strtoreturn = [NSString stringWithFormat:@"7"];
        }else
        {
            strtoreturn = [NSString stringWithFormat:@"%@,7",strtoreturn];
        }
    }
    NSLog(@"str ====== %@",strtoreturn);
    return strtoreturn;
}

@end
