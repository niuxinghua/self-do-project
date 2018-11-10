//
//  SendKeyBottomTimeSelectView.m
//  IntelligentLock
//
//  Created by niuxinghua on 2018/3/8.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "SendKeyBottomTimeSelectView.h"
#import "Masonry.h"
#import "Const.h"
@implementation SendKeyBottomTimeSelectView
- (instancetype)initWithFrame:(CGRect)frame style:(WSDateStyle)style
{
    if (self = [super initWithFrame:frame]) {
        _startLable = [[UILabel alloc]init];
        _startLable.textColor  = UICOLOR_HEX(0x336130);
        [self addSubview:_startLable];
        _startLable.text = [kMultiTool getMultiLanByKey:@"kaishishijian"];
        
        _endLable = [[UILabel alloc]init];
        _endLable.textColor  = UICOLOR_HEX(0x336130);
        [self addSubview:_endLable];
        _endLable.text = [kMultiTool getMultiLanByKey:@"jieshushijian"];
        
        _startButton = [[UIButton alloc]init];
        [_startButton setTitle:[kMultiTool getMultiLanByKey:@"kaishishijian"] forState:UIControlStateNormal];
        [_startButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
         _startButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        _startButton.titleLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:_startButton];
        
        [_startButton addTarget:self action:@selector(beginTouch) forControlEvents:UIControlEventTouchUpInside];
        
        _endButton = [[UIButton alloc]init];
        _endButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_endButton setTitle:[kMultiTool getMultiLanByKey:@"jieshushijian"] forState:UIControlStateNormal];
         _endButton.titleLabel.font = [UIFont systemFontOfSize:10];
        [_endButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self addSubview:_endButton];
        [_endButton addTarget:self action:@selector(endTouch) forControlEvents:UIControlEventTouchUpInside];
        _lineView1 = [[UIView alloc]init];
        _lineView2 = [[UIView alloc]init];
        [self addSubview:_lineView1];
        [self addSubview:_lineView2];
        _styleType = style;
        
    }
    return self;
    
}

- (void)beginTouch
{
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:_styleType CompleteBlock:^(NSDate *selectDate) {
        NSString *dateString = [selectDate stringWithFormat:@"yyyy-MM-dd HH:mm"];
        if (_styleType == DateStyleShowHourMinute) {
           dateString = [selectDate stringWithFormat:@"HH:mm"];
        }
        NSLog(@"选择的日期：%@",dateString);
        [_startButton setTitle:dateString forState:UIControlStateNormal];
        _startTime = dateString;
    }];
    
    [datepicker show];
    
    
    
}
- (void)endTouch
{
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:_styleType CompleteBlock:^(NSDate *selectDate) {
        
        NSString *dateString = [selectDate stringWithFormat:@"yyyy-MM-dd HH:mm"];
        if (_styleType == DateStyleShowHourMinute) {
            dateString = [selectDate stringWithFormat:@"HH:mm"];
        }
        NSLog(@"选择的日期：%@",dateString);
        [_endButton setTitle:dateString forState:UIControlStateNormal];
        _endTime = dateString;
    }];
    
    [datepicker show];
    
    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_startLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self.mas_left).offset(10);
        make.width.equalTo(@100);
        make.height.equalTo(@30);
    }];
    [_startButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_startLable.mas_right);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(_startLable.mas_top);
        make.height.equalTo(@30);
    }];
    
    [_endLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(_startLable.mas_bottom);
        make.width.equalTo(@100);
        make.height.equalTo(@30);
    }];
    [_endButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_endLable.mas_right);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(_endLable.mas_top);
        make.height.equalTo(@30);
    }];
    [_lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_startButton.mas_bottom);
        make.right.equalTo(self.mas_right);
        make.width.equalTo(self);
        make.height.equalTo(@0.5);
    }];
    _lineView1.backgroundColor = UICOLOR_HEX(0xdee0dd);
    [_lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_endButton.mas_bottom);
        make.right.equalTo(self.mas_right);
        make.width.equalTo(self);
        make.height.equalTo(@0.5);
    }];
    _lineView2.backgroundColor = UICOLOR_HEX(0xdee0dd);
    
}

@end
