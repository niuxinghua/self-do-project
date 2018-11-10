//
//  LockListTableViewCell.m
//  IntelligentLock
//
//  Created by niuxinghua on 2018/3/10.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "LockListTableViewCell.h"
#import "Masonry.h"
#import "Const.h"
@interface LockListTableViewCell()
@property (nonatomic,strong)UILabel *lable1;
@property (nonatomic,strong)UILabel *lable2;
@property (nonatomic,strong)UILabel *lable3;
@end
@implementation LockListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _lable1 = [[UILabel alloc]init];
        [self addSubview:_lable1];
        _lable2 = [[UILabel alloc]init];
        [self addSubview:_lable2];
        _lable3 = [[UILabel alloc]init];
        [self addSubview:_lable3];
        _lable1.textColor = UICOLOR_HEX(0x979797);
        _lable2.textColor = UICOLOR_HEX(0x979797);
        _lable3.textColor = UICOLOR_HEX(0x979797);
        
        _lable1.backgroundColor = UICOLOR_HEX(0xeff3ec);
         _lable2.backgroundColor = UICOLOR_HEX(0xeff3ec);
         _lable3.backgroundColor = UICOLOR_HEX(0xeff3ec);
        self.backgroundColor=UICOLOR_HEX(0xeff3ec);
        _lable1.font = [UIFont systemFontOfSize:14];
         _lable2.font = [UIFont systemFontOfSize:14];
         _lable3.font = [UIFont systemFontOfSize:14];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_lable1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@150);
        make.height.equalTo(@20);
        make.left.equalTo(self.mas_left).offset(10);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [_lable2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@100);
        make.height.equalTo(@20);
        make.centerY.equalTo(self.mas_centerY);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [_lable3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@100);
        make.height.equalTo(@20);
        make.right.equalTo(self.mas_right);
        make.centerY.equalTo(self.mas_centerY);
    }];
}
- (void)setDic:(NSDictionary *)dic
{
    _dic = dic;
    
    _lable1.text = [dic objectForKey:@"name"];
    
    _lable2.text = [dic objectForKey:@"tname"];
    
    _lable3.text = [dic objectForKey:@"tcode"];
}
@end
