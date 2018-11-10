//
//  KeyManagementTableViewCell.m
//  IntelligentLock
//
//  Created by niuxinghua on 2018/2/22.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "KeyManagementTableViewCell.h"
#import "Masonry.h"
#import "Const.h"
@interface KeyManagementTableViewCell()


@property (nonatomic,strong)UILabel *nameLable;

@property (nonatomic,strong)UILabel *accountLable;

@property (nonatomic,strong)UILabel *rightLable;

@property (nonatomic,strong)UILabel *timeLable;

@property (nonatomic,strong)UIView *lineView;

@end


@implementation KeyManagementTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self addSubview:self.nameLable];
        [self addSubview:self.accountLable];
        [self addSubview:self.rightLable];
        [self addSubview:self.timeLable];
        _lineView = [[UIView alloc]init];
        [self addSubview:_lineView];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        self.backgroundColor = UICOLOR_HEX(0xeff3ec);
        
    }
    
    return self;
    
    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat avg = kScreenWidth / 4.0;
  
    
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.centerY.equalTo(self);
        make.height.equalTo(@30);
        make.width.equalTo(@(avg));
    }];
    [self.accountLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLable.mas_right);
        make.centerY.equalTo(self);
        make.height.equalTo(@30);
        make.width.equalTo(@(avg));
        
        
    }];
    [self.rightLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.accountLable.mas_right);
        make.centerY.equalTo(self);
        make.height.equalTo(@30);
        make.width.equalTo(@(avg));
        
    }];
    [self.timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rightLable.mas_right);
        make.centerY.equalTo(self);
        make.height.equalTo(@30);
        make.width.equalTo(@(avg));
        
    }];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.right.equalTo(self.mas_right);
        make.width.equalTo(self);
        make.height.equalTo(@0.5);
    }];
    _lineView.backgroundColor = UICOLOR_HEX(0xdee0dd);
    
}


#pragma mark - UI getters

- (UILabel *)nameLable


{
    if (!_nameLable) {
        _nameLable = [[UILabel alloc]init];
        _nameLable.textColor = UICOLOR_HEX(0x336130);
       // _nameLable.text = @"测试1";
        _nameLable.font = [UIFont systemFontOfSize:10];
        _nameLable.textAlignment = NSTextAlignmentCenter;
    }
    
    return _nameLable;
    
    
}

- (UILabel *)accountLable


{
    if (!_accountLable) {
        _accountLable = [[UILabel alloc]init];
        _accountLable.textColor = [UIColor grayColor];
      //  _accountLable.text = @"测试2";
        _accountLable.textAlignment = NSTextAlignmentCenter;
        _accountLable.font = [UIFont systemFontOfSize:8];
    }
    
    return _accountLable;
    
    
}

- (UILabel *)rightLable


{
    if (!_rightLable) {
        _rightLable = [[UILabel alloc]init];
        _rightLable.textColor = [UIColor grayColor];
      //  _rightLable.text = @"测试3";
        _rightLable.textAlignment = NSTextAlignmentCenter;
        _rightLable.font = [UIFont systemFontOfSize:10];
    }
    
    return _rightLable;
    
    
}

- (UILabel *)timeLable


{
    if (!_timeLable) {
        _timeLable = [[UILabel alloc]init];
        _timeLable.textColor = [UIColor grayColor];
     //   _timeLable.text = @"测试4";
        _timeLable.textAlignment = NSTextAlignmentCenter;
        _timeLable.font = [UIFont systemFontOfSize:10];
        _timeLable.numberOfLines = 0;
    }
    
    return _timeLable;
    
    
}

- (void)setDic:(NSDictionary *)dic
{
    _dic = dic;
    if ([dic objectForKey:@"exp_type"]) {
        [_rightLable setText:[kMultiTool getMultiLanByKey:@"linshi"]];
        NSString *str;
        if ([[dic objectForKey:@"exp_type"] integerValue] == 0) {
            str = [NSString stringWithFormat:@"%@\n%@",[dic objectForKey:@"start_time"],[dic objectForKey:@"end_time"]];
        }else if ([[dic objectForKey:@"exp_type"] integerValue] == 1)
        {
           str = [NSString stringWithFormat:@"%@\n%@-%@",[self getDayStr:[dic objectForKey:@"week"]],[dic objectForKey:@"start_time"],[dic objectForKey:@"end_time"]];
            
        }else if ([[dic objectForKey:@"exp_type"] integerValue] == 2)
        
        {
            
            str = [dic objectForKey:@"usetime"];
        }
        _timeLable.text = str;
        
    }else
    {
       [_rightLable setText:[kMultiTool getMultiLanByKey:@"yongjiu"]];
        [_timeLable setText:[kMultiTool getMultiLanByKey:@"yongjiu"]];
    }
    
    
    _nameLable.text = [dic objectForKey:@"remark"];
    _accountLable.text = [dic objectForKey:@"phone_tel"];

}
- (NSString *)getDayStr:(NSString *)week
{
    NSString *weekStr = @"";
    if ([week containsString:@"-1"]) {
        return [kMultiTool getMultiLanByKey:@"meitian"];
    }
    if ([week containsString:@"1"])
    {
        weekStr = [kMultiTool getMultiLanByKey:@"zhouyi"];
    }
    if ([week containsString:@"2"])
    {
        if (weekStr.length) {
          weekStr = [NSString stringWithFormat:@"%@,%@",weekStr,[kMultiTool getMultiLanByKey:@"zhouer"]];
        }else
        {
            weekStr = [kMultiTool getMultiLanByKey:@"zhouer"];
        }
      
    }
    if ([week containsString:@"3"])
    {
        if (weekStr.length) {
            weekStr = [NSString stringWithFormat:@"%@,%@",weekStr,[kMultiTool getMultiLanByKey:@"zhousan"]];
        }else
        {
            weekStr = [kMultiTool getMultiLanByKey:@"zhousan"];
        }
    }
    if ([week containsString:@"4"])
    {
        if (weekStr.length) {
            weekStr = [NSString stringWithFormat:@"%@,%@",weekStr,[kMultiTool getMultiLanByKey:@"zhousi"]];
        }else
        {
            weekStr = [kMultiTool getMultiLanByKey:@"zhousi"];
        }
    }
    if ([week containsString:@"5"])
    {
        if (weekStr.length) {
            weekStr = [NSString stringWithFormat:@"%@,%@",weekStr,[kMultiTool getMultiLanByKey:@"zhouwu"]];
        }else
        {
            weekStr = [kMultiTool getMultiLanByKey:@"zhouwu"];
        }
    }
    if ([week containsString:@"6"])
    {
        if (weekStr.length) {
            weekStr = [NSString stringWithFormat:@"%@,%@",weekStr,[kMultiTool getMultiLanByKey:@"zhouliu"]];
        }else
        {
            weekStr = [kMultiTool getMultiLanByKey:@"zhouliu"];
        }
    }
    if ([week containsString:@"7"])
    {
        if (weekStr.length) {
            weekStr = [NSString stringWithFormat:@"%@,%@",weekStr,[kMultiTool getMultiLanByKey:@"zhoutian"]];
        }else
        {
            weekStr = [kMultiTool getMultiLanByKey:@"zhoutian"];
        }
    }

    return weekStr;
}

@end
