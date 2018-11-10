//
//  LocationGuideView.m
//  caxjh
//
//  Created by niuxinghua on 2017/11/25.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import "LocationGuideView.h"
#import "Masonry.h"
#import "UIColor+EAHexColor.h"
@implementation LocationGuideView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHex:@"#ffffff"];
        _topLable = [[UILabel alloc]init];
        [self addSubview:_topLable];
        _topLable.font = [UIFont systemFontOfSize:13];
        _topLable.textColor = [UIColor colorWithHex:@"#6b6b6b"];
        
        _bottomLable = [[UILabel alloc]init];
        [self addSubview:_bottomLable];
        _bottomLable.font = [UIFont systemFontOfSize:15];
        _bottomLable.textColor = [UIColor colorWithHex:@"#333333"];
        
        _logoImageView = [[UIImageView alloc]init];
        [self addSubview:_logoImageView];
        [_logoImageView setImage:[UIImage imageNamed:@"locateicon.png"]];
        
        
        _guideButton = [[UIButton alloc]init];
        [_guideButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_guideButton setTitle:@"导航" forState:UIControlStateNormal];
        _guideButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _guideButton.layer.cornerRadius = 3;
        _guideButton.layer.masksToBounds = YES;
        _guideButton.backgroundColor = [UIColor colorWithHex:@"#ff6767"];
        [self addSubview:_guideButton];
        _guideButton.hidden = YES;
        
        
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.width.equalTo(@20);
        make.height.equalTo(@25);
        make.centerY.equalTo(self.mas_centerY);
        
    }];
    
    [_topLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_logoImageView.mas_right).offset(10);
        make.top.equalTo(self.mas_top).offset(3);
        make.width.equalTo(@220);
        make.height.equalTo(@20);
    }];
    [_bottomLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_logoImageView.mas_right).offset(5);
        make.top.equalTo(_topLable.mas_bottom).offset(3);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@20);
    }];
    
    [_guideButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-20);
        make.width.equalTo(@45);
        make.height.equalTo(@25);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
}

@end
