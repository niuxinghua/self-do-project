//
//  MyOrderTableViewCell.m
//  caxjh
//
//  Created by niuxinghua on 2017/9/3.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import "MyOrderTableViewCell.h"
#import "Masonry.h"
#import "UIColor+EAHexColor.h"
@implementation MyOrderTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _orderNameLable = [[UILabel alloc]init];
        _orderTypeLable = [[UILabel alloc]init];
        _orderDateLable = [[UILabel alloc]init];
        _orderOwnerLable = [[UILabel alloc]init];
        _bgImageView = [[UIImageView alloc]init];
        [self addSubview:_bgImageView];
        [_bgImageView setImage:[UIImage imageNamed:@"orderBG"]];
        
        [_bgImageView addSubview:_orderNameLable];
        [_bgImageView addSubview:_orderTypeLable];
        [_bgImageView addSubview:_orderDateLable];
        [_bgImageView addSubview:_orderOwnerLable];
        
        _orderNameLable.textColor = [UIColor colorWithHex:@"#ffec9d"];
        _orderNameLable.font = [UIFont systemFontOfSize:25];
        _orderNameLable.text = @"安全卡套餐";
        
        _orderTypeLable.textColor = [UIColor colorWithHex:@"#ffffff"];
        _orderTypeLable.font = [UIFont systemFontOfSize:14];
        _orderTypeLable.text = @"使用中";
        
        _orderDateLable.textColor = [UIColor colorWithHex:@"#ffffff"];
        _orderDateLable.font = [UIFont systemFontOfSize:12];
        _orderDateLable.text = @"20180405使用安全卡免费";
        
        _orderOwnerLable.textColor = [UIColor colorWithHex:@"#ffffff"];
        _orderOwnerLable.font = [UIFont systemFontOfSize:12];
        _orderOwnerLable.text = @"持有本卡片";
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
-(void)layoutSubviews
{
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(25);
        make.right.equalTo(self.mas_right).offset(-25);
        make.top.equalTo(self.mas_top).offset(10);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
    }];
    [_orderNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bgImageView.mas_top).offset(20);
        make.left.equalTo(_bgImageView.mas_left).offset(20);
        make.width.equalTo(@200);
        make.height.equalTo(@40);
    }];
    [_orderTypeLable mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(_orderNameLable.mas_bottom).offset(10);
        make.left.equalTo(_orderNameLable.mas_left);
        make.width.equalTo(@200);
        make.height.equalTo(@30);
    }];
    
    [_orderDateLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_orderNameLable.mas_left);
        make.width.equalTo(@200);
        make.bottom.equalTo(_bgImageView.mas_bottom).offset(-20);
        make.height.equalTo(@30);
    }];
    
    [_orderOwnerLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_orderDateLable.mas_top);
        make.left.equalTo(_orderDateLable.mas_left);
        make.height.equalTo(@20);
        make.width.equalTo(@200);
    }];
}

-(void)setDic:(NSDictionary *)dic
{
    if ([dic valueForKey:@"videoDeadTime"]) {
        _orderNameLable.text = @"重温课堂";
        _orderDateLable.text = [NSString stringWithFormat:@"%@使用套餐卡免费",[dic valueForKey:@"videoDeadTime"]];
    }
    if ([dic valueForKey:@"liveDeadTime"]) {
        _orderNameLable.text = @"开放学堂";
        _orderDateLable.text = [NSString stringWithFormat:@"%@使用套餐卡免费",[dic valueForKey:@"liveDeadTime"]];
    }
    if ([dic valueForKey:@"securityCardDeadTime"]) {
        _orderNameLable.text = @"儿童安全系统";
        _orderDateLable.text = [NSString stringWithFormat:@"%@使用套餐卡免费",[dic valueForKey:@"securityCardDeadTime"]];
    }
}
@end
