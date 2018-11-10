//
//  AddUserHeaderView.m
//  IntelligentLock
//
//  Created by niuxinghua on 2018/2/22.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "AddUserHeaderView.h"
#import "Masonry.h"
#import "Const.h"
@implementation AddUserHeaderView


- (instancetype)init
{
    if (self = [super init]) {
        
        _flable = [[UILabel alloc]init];
        _slable = [[UILabel alloc]init];
        _tlable = [[UILabel alloc]init];
        _folable = [[UILabel alloc]init];
        _flable.textAlignment = NSTextAlignmentCenter;
         _slable.textAlignment = NSTextAlignmentCenter;
         _tlable.textAlignment = NSTextAlignmentCenter;
         _folable.textAlignment = NSTextAlignmentCenter;
        _flable.font = [UIFont systemFontOfSize:12];
        _slable.font = [UIFont systemFontOfSize:12];
        _tlable.font = [UIFont systemFontOfSize:12];
        _folable.font = [UIFont systemFontOfSize:12];
        [_flable setText:[kMultiTool getMultiLanByKey:@"zhiwen"]];
        [_slable setText:[kMultiTool getMultiLanByKey:@"mima"]];
        [_tlable setText:[kMultiTool getMultiLanByKey:@"ic"]];
        [_folable setText:[kMultiTool getMultiLanByKey:@"yaokong"]];
        _flable.textColor = [UIColor colorWithRed:99/255.0 green:122/255.0 blue:83/255.0 alpha:1.0];
        _slable.textColor = [UIColor colorWithRed:99/255.0 green:122/255.0 blue:83/255.0 alpha:1.0];
        _tlable.textColor = [UIColor colorWithRed:99/255.0 green:122/255.0 blue:83/255.0 alpha:1.0];
        _folable.textColor = [UIColor colorWithRed:99/255.0 green:122/255.0 blue:83/255.0 alpha:1.0];
        
        
        [self addSubview:_flable];
        [self addSubview:_slable];
        [self addSubview:_tlable];
        [self addSubview:_folable];
        
        [self.fbutton setImage:[UIImage imageNamed:@"zhiwen"] forState:UIControlStateNormal];
        [self.fbutton setTitle:@"" forState:UIControlStateNormal];
        self.fbutton.tag = 1000;
        [self.fbutton addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.sbutton setImage:[UIImage imageNamed:@"mima"] forState:UIControlStateNormal];
        [self.sbutton setTitle:@"" forState:UIControlStateNormal];
        self.sbutton.tag = 2000;
        [self.sbutton addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.tbutton setImage:[UIImage imageNamed:@"ic"] forState:UIControlStateNormal];
        [self.tbutton setTitle:@"" forState:UIControlStateNormal];
        self.tbutton.tag = 3000;
        [self.tbutton addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.fobutton setImage:[UIImage imageNamed:@"yaokong"] forState:UIControlStateNormal];
        [self.fobutton setTitle:@"" forState:UIControlStateNormal];
        self.fobutton.tag = 4000;
        [self.fobutton addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
        
        _selectArray = [[NSMutableArray alloc]init];
        
    }
    
    
    return self;
    
}

- (void)selectButton:(UIButton *)btn
{
    
    if (self.enableList.count) {
        if ([[self.enableList objectAtIndex:0] integerValue]) {
            [self.fbutton setImage:[UIImage imageNamed:@"zhiwen"] forState:UIControlStateNormal];
            [_selectArray addObject:self.fbutton];
        }else{
            [self.fbutton setImage:[UIImage imageNamed:@"zhiwen_hui"] forState:UIControlStateNormal];
        }
        if ([[self.enableList objectAtIndex:1] integerValue]) {
            [self.sbutton setImage:[UIImage imageNamed:@"mima"] forState:UIControlStateNormal];
            [_selectArray addObject:self.sbutton];
        }else{
            [self.sbutton setImage:[UIImage imageNamed:@"mima_hui"] forState:UIControlStateNormal];
        }
        if ([[self.enableList objectAtIndex:2] integerValue]) {
            [self.tbutton setImage:[UIImage imageNamed:@"ic"] forState:UIControlStateNormal];
            [_selectArray addObject:self.tbutton];
        }else{
            [self.tbutton setImage:[UIImage imageNamed:@"ic_hui"] forState:UIControlStateNormal];
        }
        if ([[self.enableList objectAtIndex:3] integerValue]) {
            [self.fobutton setImage:[UIImage imageNamed:@"yaokong"] forState:UIControlStateNormal];
            [_selectArray addObject:self.fbutton];
        }else{
            [self.fobutton setImage:[UIImage imageNamed:@"yaokong_hui"] forState:UIControlStateNormal];
        }
    }
        if (btn.tag == 1000) {
            [btn setImage:[UIImage imageNamed:@"zhiwen_se"] forState:UIControlStateNormal];
            _currentIndex = 2;
        }else if (btn.tag == 2000)
        {
            [btn setImage:[UIImage imageNamed:@"mima_se"] forState:UIControlStateNormal];
            _currentIndex = 1;
            
        }else if (btn.tag == 3000)
        {
            [btn setImage:[UIImage imageNamed:@"ic_se"] forState:UIControlStateNormal];
            _currentIndex = 3;
        }else
        {
            [btn setImage:[UIImage imageNamed:@"yaokong_se"] forState:UIControlStateNormal];
            _currentIndex = 4;
        }
    
    
    
    
}
- (void)setEnableList:(NSMutableArray *)enableList
{
    [_selectArray removeAllObjects];
    _enableList=enableList;
    if (enableList.count) {
        if ([[enableList objectAtIndex:0] integerValue]) {
            [self.fbutton setImage:[UIImage imageNamed:@"zhiwen"] forState:UIControlStateNormal];
            [_selectArray addObject:self.fbutton];
            self.fbutton.enabled=YES;
        }else{
            [self.fbutton setImage:[UIImage imageNamed:@"zhiwen_hui"] forState:UIControlStateNormal];
            self.fbutton.enabled=NO;
        }
        if ([[enableList objectAtIndex:1] integerValue]) {
            [self.sbutton setImage:[UIImage imageNamed:@"mima"] forState:UIControlStateNormal];
            [_selectArray addObject:self.sbutton];
            self.sbutton.enabled=YES;
        }else{
            [self.sbutton setImage:[UIImage imageNamed:@"mima_hui"] forState:UIControlStateNormal];
            self.sbutton.enabled=NO;
        }
        if ([[enableList objectAtIndex:2] integerValue]) {
            [self.tbutton setImage:[UIImage imageNamed:@"ic"] forState:UIControlStateNormal];
            [_selectArray addObject:self.tbutton];
            self.tbutton.enabled=YES;
        }else{
            [self.tbutton setImage:[UIImage imageNamed:@"ic_hui"] forState:UIControlStateNormal];
            self.tbutton.enabled=NO;

        }
        if ([[enableList objectAtIndex:3] integerValue]) {
            [self.fobutton setImage:[UIImage imageNamed:@"yaokong"] forState:UIControlStateNormal];
            [_selectArray addObject:self.fbutton];
            self.fobutton.enabled=YES;
        }else{
            [self.fobutton setImage:[UIImage imageNamed:@"yaokong_hui"] forState:UIControlStateNormal];
            self.fobutton.enabled=NO;

        }
    }
    
    
}
- (void)layoutSubviews
{
   // [super layoutSubviews];
    CGFloat avwidth = self.frame.size.width/4.0;
    [self.fbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.equalTo(self);
        make.height.equalTo(@90);
        make.width.equalTo(@(avwidth));
        
    }];
    [_flable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.fbutton.mas_width);
        make.top.equalTo(self.fbutton.mas_bottom);
        make.height.equalTo(@10);
        make.centerX.equalTo(self.fbutton.mas_centerX);
    }];
    
    [self.sbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self);
        make.height.equalTo(@90);
        make.width.equalTo(@(avwidth));
        make.left.equalTo(self.fbutton.mas_right);
        
    }];
    [_slable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.sbutton.mas_width);
        make.top.equalTo(self.sbutton.mas_bottom);
        make.height.equalTo(@10);
        make.centerX.equalTo(self.sbutton.mas_centerX);
    }];
    [self.tbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.height.equalTo(@90);
        make.width.equalTo(@(avwidth));
        make.left.equalTo(self.sbutton.mas_right);
        
        
    }];
    [_tlable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.tbutton.mas_width);
        make.top.equalTo(self.tbutton.mas_bottom);
        make.height.equalTo(@10);
        make.centerX.equalTo(self.tbutton.mas_centerX);
    }];
    [self.fobutton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self);
        make.height.equalTo(@90);
        make.width.equalTo(@(avwidth));
        make.left.equalTo(self.tbutton.mas_right);
        
    }];
    [_folable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.fobutton.mas_width);
        make.top.equalTo(self.fobutton.mas_bottom);
        make.height.equalTo(@10);
        make.centerX.equalTo(self.fobutton.mas_centerX);
    }];
    
    
}

@end
