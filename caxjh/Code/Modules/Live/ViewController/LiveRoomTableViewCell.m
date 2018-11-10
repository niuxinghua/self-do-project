//
//  LiveRoomTableViewCell.m
//  caxjh
//
//  Created by niuxinghua on 2017/9/2.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import "LiveRoomTableViewCell.h"
#import "Masonry.h"
#import "UIColor+EAHexColor.h"
@implementation LiveRoomTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _roomNameLable = [[UILabel alloc]init];
        _logoImageView = [[UIImageView alloc]init];
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor colorWithHex:@"#e1e1e1"];
        [self addSubview:_roomNameLable];
        [self addSubview:_logoImageView];
        [self addSubview:_lineView];
        _logoImageView.image = [UIImage imageNamed:@"deviceLogo.png"];
        _roomNameLable.textColor = [UIColor colorWithHex:@"#6b6b6b"];
        _roomNameLable.font = [UIFont systemFontOfSize:15];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
-(void)layoutSubviews
{
    [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.width.height.equalTo(@25);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [_roomNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@200);
        make.height.equalTo(@40);
        make.left.equalTo(_logoImageView.mas_right).offset(15);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.mas_width);
        make.height.equalTo(@0.5);
        make.left.equalTo(self.mas_left);
        make.bottom.equalTo(self.mas_bottom);
    }];
}
-(void)setName:(NSString*)name
{
    if (name) {
        _roomNameLable.text = name;
    }
}
-(void)setSelected:(BOOL)selected
{
    if (selected) {
        _roomNameLable.textColor = [UIColor colorWithHex:@"#ff6767"];
    }else{
         _roomNameLable.textColor = [UIColor colorWithHex:@"#6b6b6b"];  
    }
}
@end
