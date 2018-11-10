//
//  MyPurchedOrderTableViewCell.m
//  caxjh
//
//  Created by niuxinghua on 2017/9/7.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import "MyPurchedOrderTableViewCell.h"
#import "Masonry.h"
#import "UIColor+EAHexColor.h"
@implementation MyPurchedOrderTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _avatarImageView = [[UIImageView alloc]init];
        _nameLable = [[UILabel alloc]init];
        _valueLable = [[UILabel alloc]init];
        _timeLable = [[UILabel alloc]init];
        
        
        _avatarImageView.layer.cornerRadius = 5;
        _avatarImageView.layer.masksToBounds = YES;
        
        
        _nameLable.textColor = [UIColor colorWithHex:@"#333333"];
        _nameLable.font = [UIFont systemFontOfSize:15];
        
        _timeLable.textColor = [UIColor grayColor];
        _timeLable.font = [UIFont systemFontOfSize:15];
        
        
        _valueLable.textColor = [UIColor colorWithHex:@"#ff6767"];
        _valueLable.font = [UIFont systemFontOfSize:15];
        _valueLable.textAlignment = NSTextAlignmentRight;
        
        
        [self addSubview:_avatarImageView];
        [self addSubview:_nameLable];
        [self addSubview:_timeLable];
        [self addSubview:_valueLable];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [_nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(10);
        make.left.equalTo(self.avatarImageView.mas_right).offset(10);
        make.width.equalTo(@200);
        make.height.equalTo(@40);
    }];
    [_timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLable.mas_bottom).offset(10);
        make.left.equalTo(self.avatarImageView.mas_right).offset(10);
        make.width.equalTo(@200);
        make.height.equalTo(@40);
    }];
    [_valueLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.equalTo(@40);
        make.width.equalTo(@60);
        make.centerY.equalTo(self.mas_centerY);
    }];
}
-(void)setDic:(NSDictionary *)dic
{
    _dic = dic;
    if (![[dic objectForKey:@"platform"] isKindOfClass:[NSNull class]]) {
        if([[dic objectForKey:@"platform"] isEqualToString:@"alibaba"])
        {
            [_avatarImageView setImage:[UIImage imageNamed:@"支付宝"]];
        }else if([[dic objectForKey:@"platform"] isEqualToString:@"wechat"])
        {
            [_avatarImageView setImage:[UIImage imageNamed:@"微信"]];
        }
    }
    
    
    
    if (![[dic objectForKey:@"orderNumber"] isKindOfClass:[NSNull class]]) {
        _nameLable.text = [dic objectForKey:@"orderNumber"];
    }
    if (![[dic objectForKey:@"payTime"]isKindOfClass:[NSNull class]]) {
        _timeLable.text = [dic objectForKey:@"payTime"];
    }
    if (![[dic objectForKey:@"amountMoney"] isKindOfClass:[NSNull class]]) {
        _valueLable.text = [NSString stringWithFormat:@"%1.f元",[[dic objectForKey:@"amountMoney"] doubleValue]];
    }
}
@end
