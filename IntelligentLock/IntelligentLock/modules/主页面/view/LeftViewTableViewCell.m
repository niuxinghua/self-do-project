//
//  LeftViewTableViewCell.m
//  IntelligentLock
//
//  Created by niuxinghua on 2018/3/4.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "LeftViewTableViewCell.h"
#import "Masonry.h"
#import "Const.h"
@interface LeftViewTableViewCell()

@property (nonatomic,strong)UILabel *nameLable;


@end

@implementation LeftViewTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _nameLable = [[UILabel alloc]initWithFrame:self.bounds];
        [self addSubview:_nameLable];
        _nameLable.textColor = UICOLOR_HEX(0x336130);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    
    return self;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self);
        make.left.equalTo(self.mas_left).offset(10);
    }];
    
    
}
- (void)setDic:(NSDictionary *)dic
{
    
    _dic = dic;
    
    _nameLable.text = [dic objectForKey:@"name"];
    
}

@end
