//
//  CustomEnterView.m
//  IntelligentLock
//
//  Created by niuxinghua on 2018/3/6.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "CustomEnterView.h"

#import "Masonry.h"


@interface CustomEnterView()

@property (nonatomic,strong)UIButton *scanButton;


//@property (nonatomic,strong)UITextField *editTextField;

@end

@implementation CustomEnterView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.layer.cornerRadius = 3;
        self.layer.masksToBounds = YES;
        self.layer.borderColor = [UIColor colorWithRed:79/255.0 green:89/255.0 blue:76/255.0 alpha:1.0].CGColor;
        self.layer.borderWidth = 2;
        _editTextField = [[UITextField alloc]init];
        
        [self addSubview:_editTextField];
        
        _scanButton = [[UIButton alloc]init];
        
        [_scanButton setImage:[UIImage imageNamed:@"scan"] forState:UIControlStateNormal];
        
        [_scanButton addTarget:self action:@selector(didTapScan) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_scanButton];
        
    }
    return self;
    
    
}


- (void)didTapScan
{
    
    if (self.scanBlock) {
        
        self.scanBlock();
        
    }
    
    
    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_editTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@150);
        make.height.equalTo(@30);
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [_scanButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.height.equalTo(@30);
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-10);
        
    }];
    
    
}
- (void)setPlaceHolder:(NSString *)holder
{
    
    _editTextField.placeholder = holder;
}

@end
