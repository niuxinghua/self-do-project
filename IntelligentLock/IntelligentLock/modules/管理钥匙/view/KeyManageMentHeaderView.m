//
//  KeyManageMentHeaderView.m
//  IntelligentLock
//
//  Created by niuxinghua on 2018/2/22.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "KeyManageMentHeaderView.h"
#import "Masonry.h"
#import "Const.h"
@interface KeyManageMentHeaderView()




@end

@implementation KeyManageMentHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.fbutton];
        [self addSubview:self.sbutton];
        [self addSubview:self.tbutton];
        [self addSubview:self.fobutton];
        self.backgroundColor = [UIColor colorWithRed:229/255.0 green:239/255.0 blue:218/255.0 alpha:1.0];
        
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat avwidth = self.frame.size.width/4.0;
    [_fbutton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.left.bottom.equalTo(self);
        make.width.equalTo(@(avwidth));
        
    }];
    
    [_sbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.bottom.equalTo(self);
        make.width.equalTo(@(avwidth));
        make.left.equalTo(_fbutton.mas_right);
        
    }];
    [_tbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.width.equalTo(@(avwidth));
        make.left.equalTo(_sbutton.mas_right);
        
        
    }];
    [_fobutton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.bottom.equalTo(self);
        make.width.equalTo(@(avwidth));
        make.left.equalTo(_tbutton.mas_right);
        
    }];
    
    
}

#pragma mark - ui  getters

- (UIButton *)fbutton
{
    if (!_fbutton) {
        _fbutton = [[UIButton alloc]init];
        [_fbutton addTarget:self action:@selector(ftouch) forControlEvents:UIControlEventTouchUpInside];
        [_fbutton setTitle:[kMultiTool getMultiLanByKey:@"info"] forState:UIControlStateNormal];
        [_fbutton setTitleColor:UICOLOR_HEX(0x336130) forState:UIControlStateNormal];
        
    }
    return _fbutton;
    
    
}
- (void)ftouch
{
    if (self.fblock) {
        self.fblock();
    }
    
}

- (UIButton *)sbutton
{
    if (!_sbutton) {
        _sbutton = [[UIButton alloc]init];
        [_sbutton addTarget:self action:@selector(stouch) forControlEvents:UIControlEventTouchUpInside];
        [_sbutton setTitle:[kMultiTool getMultiLanByKey:@"account"] forState:UIControlStateNormal];
        [_sbutton setTitleColor:UICOLOR_HEX(0x336130) forState:UIControlStateNormal];
    }
    return _sbutton;
    
    
}

- (void)stouch
{
    if (self.sblock) {
        self.sblock();
    }
    
}
- (UIButton *)tbutton
{
    if (!_tbutton) {
        _tbutton = [[UIButton alloc]init];
        
        [_tbutton addTarget:self action:@selector(ttouch) forControlEvents:UIControlEventTouchUpInside];
        [_tbutton setTitle:[kMultiTool getMultiLanByKey:@"quanxian"] forState:UIControlStateNormal];
        [_tbutton setTitleColor:UICOLOR_HEX(0x336130) forState:UIControlStateNormal];
    }
    return _tbutton;
    
    
}
- (void)ttouch
{
    if (self.tblock) {
        self.tblock();
    }
    
}
- (UIButton *)fobutton
{
    if (!_fobutton) {
        _fobutton = [[UIButton alloc]init];
        [_fobutton addTarget:self action:@selector(fotouch) forControlEvents:UIControlEventTouchUpInside];
        [_fobutton setTitle:[kMultiTool getMultiLanByKey:@"shijian"] forState:UIControlStateNormal];
        [_fobutton setTitleColor:UICOLOR_HEX(0x336130) forState:UIControlStateNormal];
    }
    return _fobutton;
    
    
}
- (void)fotouch
{
    if (self.foblock) {
        self.foblock();
    }
    
}



@end
