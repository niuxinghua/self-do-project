//
//  SendKeyBottomTimeSelectView.h
//  IntelligentLock
//
//  Created by niuxinghua on 2018/3/8.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WSDatePickerView.h"
@interface SendKeyBottomTimeSelectView : UIView


@property (nonatomic,strong)UILabel *startLable;
@property (nonatomic,strong)UILabel *endLable;

@property (nonatomic,strong)UIButton *startButton;
@property (nonatomic,strong)UIButton *endButton;

@property (nonatomic,strong)NSString *startTime;

@property (nonatomic,strong)NSString *endTime;

@property (nonatomic,strong)UIView *lineView1;

@property (nonatomic,strong)UIView *lineView2;

@property (nonatomic,assign)WSDateStyle styleType;

- (instancetype)initWithFrame:(CGRect)frame style:(WSDateStyle)style;

@end
