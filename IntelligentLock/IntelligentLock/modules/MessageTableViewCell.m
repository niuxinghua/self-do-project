//
//  MessageTableViewCell.m
//  IntelligentLock
//
//  Created by niuxinghua on 2018/5/5.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "MessageTableViewCell.h"
#import "Const.h"
@interface MessageTableViewCell()

@property (nonatomic,strong)UILabel *nameLable;

@property (nonatomic,strong)UILabel *typeLable;

@property (nonatomic,strong)UILabel *timeLable;

@property (nonatomic,strong)UIImageView *iconView;

@property (nonatomic,strong)UIView *lineView;

@end
@implementation MessageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _nameLable = [[UILabel alloc]init];
        _typeLable = [[UILabel alloc]init];
        _typeLable.textAlignment = NSTextAlignmentLeft;
        _nameLable.textAlignment = NSTextAlignmentLeft;
        _timeLable = [[UILabel alloc]init];
        _nameLable.textColor = [UIColor colorWithRed:67/255.0 green:80/255.0 blue:38/255.0 alpha:1.0];
        _typeLable.textColor = [UIColor colorWithRed:67/255.0 green:80/255.0 blue:38/255.0 alpha:1.0];
        _timeLable.textColor = [UIColor grayColor];
        _iconView = [[UIImageView alloc]init];
        [self addSubview:_iconView];
        [self addSubview:_nameLable];
        [self addSubview:_typeLable];
        [self addSubview:_timeLable];
        _nameLable.font = [UIFont systemFontOfSize:16];
        _typeLable.font = [UIFont systemFontOfSize:14];
        _timeLable.font = [UIFont systemFontOfSize:12];
        
        self.backgroundColor = UICOLOR_HEX(0xeff3ec);
        _lineView = [[UIView alloc]init];
        [self addSubview:_lineView];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(5);
        make.centerY.equalTo(self.mas_centerY);
        make.width.height.equalTo(@40);
    }];
    [_nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconView.mas_right).offset(5);
        make.top.equalTo(self.mas_top).offset(5);
        make.height.equalTo(@30);
        make.width.equalTo(@200);
    }];
    [_typeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLable.mas_left);
        make.top.equalTo(_nameLable.mas_bottom);
        make.height.equalTo(@30);
        make.width.equalTo(@250);
    }];
    [_timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.centerY.equalTo(_nameLable.mas_centerY);
        make.height.equalTo(@30);
        make.width.equalTo(@150);
    }];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.right.equalTo(self.mas_right);
        make.width.equalTo(self);
        make.height.equalTo(@0.5);
    }];
    _lineView.backgroundColor = UICOLOR_HEX(0xdee0dd);
    
    
}
- (void)setDic:(NSDictionary *)dic
{
    NSMutableArray *lockList = [LockStoreManager sharedManager].lockList;
    _dic = dic;
    _timeLable.text = [dic objectForKey:@"happen_time"];
    _typeLable.text = [dic objectForKey:@"description"];
    NSString *alarmLevel = [dic objectForKey:@"alarm_level"];
    if ([alarmLevel isEqualToString:@"0"]) {
     [_iconView setImage:[UIImage imageNamed:@"info"]];
    }else if ([alarmLevel isEqualToString:@"1"])
    {
      [_iconView setImage:[UIImage imageNamed:@"warnning"]];
    }else{
       [_iconView setImage:[UIImage imageNamed:@"danger"]];
    }
    for (NSDictionary *lock in lockList) {
        if([[dic objectForKey:@"lock_id"] isEqualToString:[lock objectForKey:@"lock_id"]])
        {
            _nameLable.text = [lock objectForKey:@"name"];
        }
    }
    if (!_nameLable.text.length) {
        _nameLable.text = [kMultiTool getMultiLanByKey:@"weizhisuo"];
    }
}

@end
