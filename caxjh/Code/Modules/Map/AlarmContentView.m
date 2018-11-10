
//
//  AlarmContentView.m
//  caxjh
//
//  Created by niuxinghua on 2017/12/3.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import "AlarmContentView.h"
#import "Masonry.h"
#import "SocketManager.h"
@interface AlarmContentView()
@property (nonatomic,strong)UIImageView *backImageView;

@property (nonatomic,strong)UILabel *nameLable;

@property (nonatomic,strong)UILabel *timeLable;

@property (nonatomic,strong)UIImageView *headImageView;
@property (nonatomic,strong)UIImageView *timeImageView;
@property (nonatomic,strong)UILabel *masterNameLable;

@end
@implementation AlarmContentView

- (instancetype)init
{
    if (self = [super init]) {
        
        _backImageView = [[UIImageView alloc]init];
        UIImage *image = [UIImage imageNamed:@"backcontent"];
        _backImageView.image =  [ image resizableImageWithCapInsets:UIEdgeInsetsMake(20,20,20,20)];
        [self addSubview:_backImageView];
        
        _nameLable = [[UILabel alloc]init];
        _nameLable.textColor = [UIColor blackColor];
        [self addSubview:_nameLable];
        
        // _nameLable.text = @"xxxx";
        
        
        _timeLable = [[UILabel alloc]init];
        _timeLable.font = [UIFont systemFontOfSize:14];
        _timeLable.textColor = [UIColor grayColor];
        _timeLable.textAlignment = NSTextAlignmentLeft;
        
        [self addSubview:_timeLable];
        
        _timeImageView = [[UIImageView alloc]init];
        [_timeImageView setImage:[UIImage imageNamed:@"alarttime"]];
        [self addSubview:_timeImageView];
        
        
        _headImageView = [[UIImageView alloc]init];
        [_headImageView setImage:[UIImage imageNamed:@"alartname"]];
        [self addSubview:_headImageView];
        
        NSDictionary *dic = [SocketManager sharedInstance].locationDic;;
        _masterNameLable = [[UILabel alloc]init];
        _masterNameLable.font = [UIFont systemFontOfSize:14];
        _masterNameLable.text = [dic objectForKey:@"name"];
        [self addSubview:_masterNameLable];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.right.left.bottom.equalTo(self);
        
    }];
    
    [_nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(self.mas_top);
        make.width.equalTo(@200);
        make.height.equalTo(@30);
    }];
    
    [_timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@150);
        make.height.equalTo(@30);
        make.right.equalTo(self.mas_right).offset(-10);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
        
    }];
    
    [_timeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@20);
        make.right.equalTo(_timeLable.mas_left);
        make.centerY.equalTo(_timeLable.mas_centerY);
        
    }];
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@20);
        make.left.equalTo(_nameLable.mas_left);
        make.centerY.equalTo(_timeLable.mas_centerY);
        
    }];
    [_masterNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
        make.width.equalTo(@60);
        make.left.equalTo(_headImageView.mas_right);
        make.centerY.equalTo(_timeLable.mas_centerY);
        
    }];
    
    
}

- (void)setDic:(NSDictionary *)dic
{
    _dic = [dic copy];
    
    _nameLable.text = [dic objectForKey:@"name"];
    
    NSString *time = [NSString stringWithFormat:@"%@",[self cStringFromTimestamp:[[dic objectForKey:@"createTime"]longLongValue]/1000.0]];
    
    _timeLable.text = time;
    // [dic objectForKey:@"name"];
}
-(NSString *)cStringFromTimestamp:(long)timestamp{
    //时间戳转时间的方法
    NSDate *timeData = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    NSString *strTime = [dateFormatter stringFromDate:timeData];
    return strTime;
}
@end
