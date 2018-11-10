//
//  SendKeyBottomView.m
//  IntelligentLock
//
//  Created by niuxinghua on 2018/3/8.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "SendKeyBottomView.h"
#import "Masonry.h"
#import "Const.h"
#import "SendKeyBottomTimeSelectView.h"
#import "SendKeyBottomAlarmView.h"
#import "SendKeyBottomCountView.h"
@interface SendKeyBottomView()

@end
@implementation SendKeyBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        
        _timeButton = [[UIButton alloc]init];
        [_timeButton setTitle:[kMultiTool getMultiLanByKey:@"shijianduan"] forState:UIControlStateNormal];
        [_timeButton setTitleColor:UICOLOR_HEX(0x336130) forState:UIControlStateNormal];
        [self addSubview:_timeButton];
        [_timeButton addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
        _timeButton.tag = 1000;
        
        _alarmButton = [[UIButton alloc]init];
        [_alarmButton setTitle:[kMultiTool getMultiLanByKey:@"naoling"] forState:UIControlStateNormal];
         [_alarmButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self addSubview:_alarmButton];
        [_alarmButton addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
        _alarmButton.tag = 2000;
        
        
        _countButton = [[UIButton alloc]init];
         [_countButton setTitle:[kMultiTool getMultiLanByKey:@"cishu"] forState:UIControlStateNormal];
        [_countButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self addSubview:_countButton];
        
        _countButton.tag = 3000;
        [_countButton addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
       _timeView = [[SendKeyBottomTimeSelectView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 60) style:DateStyleShowYearMonthDayHourMinute];;
        [self addSubview:_timeView];
        
        _alarmView = [[SendKeyBottomAlarmView alloc]init];
        [self addSubview:_alarmView];
        
        _countView = [[SendKeyBottomCountView alloc]init];
        [self addSubview:_countView];
        _currentType = tempBottomTypeTime;
        
    }
    return self;
    
    
    
}
- (void)didTapButton:(UIButton *)sender
{
    if (sender.tag == 1000) {
        _timeView.hidden = NO;
        _alarmView.hidden = YES;
        _countView.hidden = YES;
        [_timeButton setTitleColor:UICOLOR_HEX(0x336130) forState:UIControlStateNormal];
        [_alarmButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_countButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _currentType = tempBottomTypeTime;
    }else if (sender.tag == 2000)
    {
        _alarmView.hidden = NO;
        _timeView.hidden = YES;
        _countView.hidden = YES;
         [_alarmButton setTitleColor:UICOLOR_HEX(0x336130) forState:UIControlStateNormal];
        [_timeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_countButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _currentType = tempBottomTypeAlert;
        
    }else{
        _countView.hidden = NO;
        _timeView.hidden = YES;
        _alarmView.hidden = YES;
        _currentType = tempBottomTypeCount;
        [_timeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_alarmButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_countButton setTitleColor:UICOLOR_HEX(0x336130) forState:UIControlStateNormal];
        
    }
    
    
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat avWidth = kScreenWidth / 3.0;
    
    [_timeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.width.equalTo(@(avWidth));
        make.height.equalTo(@40);
        make.top.equalTo(self.mas_top);
        
    }];
    [_alarmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeButton.mas_right);
        make.width.equalTo(@(avWidth));
        make.height.equalTo(@40);
        make.top.equalTo(self.mas_top);
        
    }];
    [_countButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.alarmButton.mas_right);
        make.width.equalTo(@(avWidth));
        make.height.equalTo(@40);
        make.top.equalTo(self.mas_top);
        
    }];
    
    [_timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_countButton.mas_bottom);
        make.right.left.equalTo(self);
        make.height.equalTo(@60);
    }];
    [_alarmView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_countButton.mas_bottom);
        make.right.left.equalTo(self);
        make.height.equalTo(@200);
    }];
    [_countView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_countButton.mas_bottom);
        make.right.left.equalTo(self);
        make.height.equalTo(@60);
    }];
    _alarmView.hidden = YES;
    _countView.hidden = YES;
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.right.equalTo(self.mas_right);
        make.width.equalTo(self);
        make.height.equalTo(@0.5);
    }];
    _lineView.backgroundColor = UICOLOR_HEX(0xdee0dd);
}

@end
