//
//  SendKeyBottomView.h
//  IntelligentLock
//
//  Created by niuxinghua on 2018/3/8.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendKeyBottomAlarmView.h"
#import "SendKeyBottomCountView.h"
#import "SendKeyBottomTimeSelectView.h"
typedef NS_OPTIONS(NSUInteger, tempBottomType) {
    tempBottomTypeTime = 1 ,
    tempBottomTypeAlert = 2 ,
    tempBottomTypeCount = 3,
    };

@interface SendKeyBottomView : UIView

@property (nonatomic,strong)UIButton *timeButton;
@property (nonatomic,strong)UIButton *alarmButton;
@property (nonatomic,strong)UIButton *countButton;

@property (nonatomic,assign)tempBottomType currentType;

@property (nonatomic,strong)SendKeyBottomTimeSelectView *timeView;
@property (nonatomic,strong)SendKeyBottomAlarmView *alarmView;
@property (nonatomic,strong)SendKeyBottomCountView *countView;

@property (nonatomic,strong)UIView *lineView;


@end
