//
//  RecordTableViewCell.m
//  IntelligentLock
//
//  Created by niuxinghua on 2018/2/23.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "RecordTableViewCell.h"
#import "Masonry.h"
#import "Const.h"
@interface RecordTableViewCell()

@property (nonatomic,strong)UILabel *nameLable;

@property (nonatomic,strong)UILabel *typeLable;

@property (nonatomic,strong)UILabel *timeLable;

@property (nonatomic,strong)UIView *lineView;

@end

@implementation RecordTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _nameLable = [[UILabel alloc]init];
        _typeLable = [[UILabel alloc]init];
        _typeLable.textAlignment = NSTextAlignmentCenter;
        _nameLable.textAlignment = NSTextAlignmentCenter;
        _timeLable = [[UILabel alloc]init];
        _nameLable.textColor = [UIColor colorWithRed:67/255.0 green:80/255.0 blue:38/255.0 alpha:1.0];
        _typeLable.textColor = [UIColor colorWithRed:67/255.0 green:80/255.0 blue:38/255.0 alpha:1.0];
        _timeLable.textColor = [UIColor grayColor];
        [self addSubview:_nameLable];
        [self addSubview:_typeLable];
        [self addSubview:_timeLable];
        _nameLable.font = [UIFont systemFontOfSize:14];
        _typeLable.font = [UIFont systemFontOfSize:14];
        _timeLable.font = [UIFont systemFontOfSize:14];
        
          self.backgroundColor = UICOLOR_HEX(0xeff3ec);
        _lineView = [[UIView alloc]init];
        [self addSubview:_lineView];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [_nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.centerY.equalTo(self);
        make.height.equalTo(@40);
        make.width.equalTo(@100);
    }];
    [_typeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLable.mas_right);
        make.centerY.equalTo(self);
        make.height.equalTo(@40);
        make.width.equalTo(@100);
    }];
    [_timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.centerY.equalTo(self);
        make.height.equalTo(@40);
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
    _dic = [dic copy];
    
    if ([_dic objectForKey:@"remark"] && ![[_dic objectForKey:@"remark"] isEqual:[NSNull null]]) {
    _nameLable.text = [_dic objectForKey:@"remark"];
    }
    if ([_dic objectForKey:@"type"] && ![[_dic objectForKey:@"type"] isEqual:[NSNull null]]) {
    _typeLable.text = [_dic objectForKey:@"type"];
    }
    if ([_dic objectForKey:@"add_time"]&& ![[_dic objectForKey:@"add_time"] isEqual:[NSNull null]]) {
         _timeLable.text = [_dic objectForKey:@"add_time"];
    }
   
    
}

@end
