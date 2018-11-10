//
//  MapPlaceHolder.m
//  caxjh
//
//  Created by niuxinghua on 2017/11/24.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import "MapPlaceHolder.h"
#import "Masonry.h"
#import "UIColor+EAHexColor.h"

@interface MapPlaceHolder()
@property (nonatomic,strong)UIImageView *logoImageView;
@property (nonatomic,strong)UILabel *textLable;
@property (nonatomic,strong)UIButton *bindButton;

@end
@implementation MapPlaceHolder

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _logoImageView = [[UIImageView alloc]init];
        
        [self addSubview:_logoImageView];
//        _logoImageView.layer.masksToBounds = YES;
//        _logoImageView.layer.cornerRadius = 150;
        
        _logoImageView.image = [UIImage imageNamed:@"nodevice"];
        
        
        _textLable = [[UILabel alloc]init];
        _textLable.font = [UIFont systemFontOfSize:25];
        _textLable.textColor = [UIColor colorWithHex:@"#aaaaaa"];
        _textLable.text = @"您的账号尚未绑定任何设备";
        _textLable.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:_textLable];
        
        
        _bindButton = [[UIButton alloc]init];
        _bindButton.backgroundColor = [UIColor colorWithHex:@"#ff6767"];
        [_bindButton setTitle:@"添加设备" forState:UIControlStateNormal];
        [_bindButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _bindButton.layer.masksToBounds = YES;
        _bindButton.layer.cornerRadius = 7;
        [_bindButton addTarget:self action:@selector(didtouchBind) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_bindButton];
        
        
        self.backgroundColor = [UIColor clearColor];
        
        
        
    }
    
    return self;
}


-(void)didtouchBind
{
    
    if (self.bindBlock) {
        self.bindBlock();
    }
    
    
}

- (void)layoutSubviews

{
    [super layoutSubviews];
    [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.with.equalTo(@200);
        make.top.equalTo(self.mas_top).offset(80);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [_textLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@400);
        make.top.equalTo(_logoImageView.mas_bottom).offset(30);
        make.height.equalTo(@30);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [_bindButton mas_makeConstraints:^(MASConstraintMaker *make) {
      
        make.width.equalTo(@300);
        make.height.equalTo(@40);
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(_textLable.mas_bottom).offset(40);
        
    }];
    
    
    
}
@end
