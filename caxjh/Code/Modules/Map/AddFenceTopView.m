//
//  AddFenceTopView.m
//  caxjh
//
//  Created by niuxinghua on 2017/12/2.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import "AddFenceTopView.h"
#import "Masonry.h"
#import "UIColor+HexString.h"

@interface AddFenceTopView()

@property (nonatomic,strong)UIImageView *logoImageView;
@property (nonatomic,strong)UILabel *toplable;
@property (nonatomic,strong)UILabel *bottomLable;
@property (nonatomic,strong)UIView *lineView;

@end


@implementation AddFenceTopView
- (instancetype)init
{
    if (self = [super init]) {
        _logoImageView = [[UIImageView alloc]init];
        
        [_logoImageView setImage:[UIImage imageNamed:@"smallmap"]];
        [self addSubview:_logoImageView];
        
        
        _toplable = [[UILabel alloc]init];
        _toplable.font = [UIFont systemFontOfSize:15];
        _toplable.textColor = [UIColor colorwithHexString:@"#ff6767"];
        _toplable.textAlignment = NSTextAlignmentCenter;
        
        
        [self addSubview:_toplable];
        
        
        _bottomLable = [[UILabel alloc]init];
        _bottomLable.textColor = [UIColor colorwithHexString:@"#aaaaaa"];
        [self addSubview:_bottomLable];
       
        _bottomLable.textAlignment = NSTextAlignmentCenter;
        self.backgroundColor = [UIColor whiteColor];
        
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor colorwithHexString:@"#e1e1e1"];
        [self addSubview:_lineView];
    }
    
    return self;
    
    
}

- (void)setTopAddress:(NSString *)add
{
   
    _toplable.text = add;
    
}

- (void)setBootomAddress:(NSString *)add
{
    
      _bottomLable.text = add;
    
}
- (NSString *)getAd
{
    
    return _toplable.text;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@15);
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(self.mas_top).offset(10);
    }];
    
    [_toplable mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(_logoImageView.mas_right).offset(5);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@30);
        make.centerY.equalTo(_logoImageView.mas_centerY);
    }];
    [_bottomLable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_toplable.mas_bottom);
        make.width.equalTo(self);
        make.height.equalTo(@30);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@0.5);
    }];
}

@end
