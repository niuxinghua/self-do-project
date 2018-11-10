//
//  MineHeaderView.m
//  IntelligentLock
//
//  Created by niuxinghua on 2018/2/24.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "MineHeaderView.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "Const.h"
@interface MineHeaderView()

@property (nonatomic,strong)UIImageView *iconView1;

@property (nonatomic,strong)UILabel  *nameLable;

@property (nonatomic,strong)UILabel  *accountLable;

@property (nonatomic,strong)UIButton *barCodeButton;

@end



@implementation MineHeaderView


- (instancetype)initWithFrame:(CGRect)frame
{
    
    if (self = [super initWithFrame:frame]) {
        
        _iconView1 = [[UIImageView alloc]init];
       // _iconView1.backgroundColor = [UIColor redColor];
        
        
        
        _nameLable = [[UILabel alloc]init];
        _nameLable.textColor =[UIColor colorWithRed:67/255.0 green:80/255.0 blue:38/255.0 alpha:1.0];
        _nameLable.font = [UIFont systemFontOfSize:12];
        _accountLable = [[UILabel alloc]init];
        _accountLable.textColor = [UIColor colorWithRed:191/255.0 green:175/255.0 blue:211/255.0 alpha:1.0];
        _accountLable.font = [UIFont systemFontOfSize:10];
        self.backgroundColor = [UIColor colorWithRed:248/255.0 green:250/255.0 blue:244/255.0 alpha:1.0];
        [self addSubview:_iconView1];
        [self addSubview:_nameLable];
        [self addSubview:_accountLable];
        UITapGestureRecognizer *rec = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
        _iconView1.userInteractionEnabled = YES;
        [_iconView1 addGestureRecognizer:rec];
        
        _barCodeButton = [[UIButton alloc]init];
        [_barCodeButton setImage:[UIImage imageNamed:@"barcode"] forState:UIControlStateNormal];
        _barCodeButton.imageView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_barCodeButton];
        [_barCodeButton addTarget:self action:@selector(barcodeTap) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)barcodeTap
{
    if (self.barcodeBlock) {
        self.barcodeBlock();
    }
    
}

- (void)setLoginModel:(LoginModel *)loginModel
{
    
    _loginModel = loginModel;
    
    _nameLable.text = loginModel.retval.real_name;
    
    _accountLable.text = loginModel.retval.n;
    
    [_iconView1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://27.223.29.134:6052/%@",_loginModel.retval.h]] placeholderImage:[UIImage imageNamed:@"menu"]];
    
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_iconView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(20);
        make.height.equalTo(@80);
        make.width.equalTo(@80);
       
    }];
    _iconView1.layer.cornerRadius = _iconView1.frame.size.width/2.0;
    _iconView1.layer.masksToBounds = YES;
    
    [_nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView1.mas_right).offset(20);
        make.width.equalTo(@100);
        make.top.equalTo(self.iconView1.mas_top).offset(10);
        make.height.equalTo(@20);
    }];
    [_accountLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView1.mas_right).offset(20);
        make.width.equalTo(@300);
        make.top.equalTo(self.nameLable.mas_bottom).offset(10);
        make.height.equalTo(@20);
    }];
    [_barCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(_nameLable.mas_right).offset(5);
        make.height.equalTo(_nameLable.mas_height);
        make.width.equalTo(_nameLable.mas_height);;
        make.centerY.equalTo(_nameLable.mas_centerY);
    }];
    
}
- (void)tap{
    
    if (self.avatarBlock) {
        self.avatarBlock();
    }
    
}

@end
