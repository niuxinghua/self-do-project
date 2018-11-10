//
//  AlarmMessageTableViewCell.m
//  caxjh
//
//  Created by niuxinghua on 2017/12/3.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import "AlarmMessageTableViewCell.h"
#import "UIColor+HexString.h"
#import "Masonry.h"
#import "AlarmContentView.h"
@interface AlarmMessageTableViewCell()

@property (nonatomic,strong)UIImageView *headImageView;

@property (nonatomic,strong)UIView *toplineview;

@property (nonatomic,strong)UIView *bottomlineview;

@property (nonatomic,strong)AlarmContentView *infocontentView;


@end
@implementation AlarmMessageTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
_headImageView = [[UIImageView alloc]init];

[_headImageView setImage:[UIImage imageNamed:@"sos"]];

[self addSubview:_headImageView];

_toplineview = [[UIView alloc]init];
_toplineview.backgroundColor = [UIColor colorwithHexString:@"#e1e1e1"];
[self addSubview:_toplineview];


_bottomlineview = [[UIView alloc]init];
_bottomlineview.backgroundColor = [UIColor colorwithHexString:@"#e1e1e1"];
[self addSubview:_bottomlineview];

_infocontentView = [[AlarmContentView alloc]init];
    [self addSubview:_infocontentView];




[self setSelectionStyle:UITableViewCellSelectionStyleNone];

}

return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@35);
        make.left.equalTo(self.mas_left).offset(15);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [_toplineview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@1);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(_headImageView.mas_top);
        make.centerX.equalTo(_headImageView.mas_centerX);
    }];
    
    [_bottomlineview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@1);
        make.bottom.equalTo(self.mas_bottom);
        make.top.equalTo(_headImageView.mas_bottom);
        make.centerX.equalTo(_headImageView.mas_centerX);
    }];
    [_infocontentView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(_headImageView.mas_right).offset(10);
        make.height.equalTo(@70);
        make.right.equalTo(self.mas_right).offset(-15);
        make.centerY.equalTo(self.mas_centerY);
        
    }];
}

- (void)setDic:(NSDictionary *)dic
{
    
    _dic = dic;
    
    _infocontentView.dic = dic;
    
    NSString *alarmType = [dic objectForKey:@"type"];
    
    if ([alarmType isEqualToString:@"fenceIn"] || [alarmType isEqualToString:@"fenceOut"] ) {
        [_headImageView setImage:[UIImage imageNamed:@"fencealarm"]];
    }else if ([alarmType isEqualToString:@"drop"])
    {
        [_headImageView setImage:[UIImage imageNamed:@"watchalarm"]];
        
    }else if ([alarmType isEqualToString:@"sos"])
    {
          [_headImageView setImage:[UIImage imageNamed:@"sosalarm"]];
        
    }
    
}

@end
