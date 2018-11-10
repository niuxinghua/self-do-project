//
//  XJHLoginInputView.m
//  caxjh
//
//  Created by Yingchao Zou on 31/08/2017.
//  Copyright © 2017 Yingchao Zou. All rights reserved.
//

#import "XJHLoginInputView.h"

@interface XJHLoginInputView ()

@property (nonatomic, readwrite, strong) UIImageView *imageViewRole;
@property (nonatomic, readwrite, strong) UIImageView *imageViewNumber;

@property (nonatomic, readwrite, strong) UIView *line1;
@property (nonatomic, readwrite, strong) UIView *line2;

@end

@implementation XJHLoginInputView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 3;
    self.layer.borderColor = [UIColor colorWithHex:@"#e1e1e1"].CGColor;
    self.layer.masksToBounds = YES;
    
    [self addSubview:self.imageViewRole];
    [self addSubview:self.imageViewNumber];
    [self addSubview:self.imageViewCode];
    [self addSubview:self.textFieldRole];
    [self addSubview:self.textFieldNumber];
    [self addSubview:self.textFieldCode];
    [self addSubview:self.line1];
    [self addSubview:self.line2];
    [self addSubview:self.arrowButton];
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // h 50 + 1 + 50 + 1 + 50 = 152
    
    [self.textFieldRole mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(60);
        make.right.equalTo(self).with.offset(-60);
        make.top.equalTo(self);
        // make.height.equalTo(@50);
        make.height.equalTo(@0);
    }];
    
    [self.line1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.textFieldRole.mas_bottom);
        // make.height.equalTo(@1);
        make.height.equalTo(@0);
    }];
    
    [self.textFieldNumber mas_remakeConstraints:^(MASConstraintMaker *make) {
        // make.left.right.equalTo(self.textFieldRole);
        make.left.equalTo(self.textFieldRole);
        make.right.equalTo(self).with.offset(-10);
        make.top.equalTo(self.line1.mas_bottom);
        make.height.equalTo(@50);
    }];
    
    [self.line2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.textFieldNumber.mas_bottom);;
        make.height.equalTo(@1);
    }];
    
    [self.textFieldCode mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line2.mas_bottom);
        make.left.right.equalTo(self.textFieldRole);
        make.height.equalTo(@50);
    }];
    
    [self.imageViewRole mas_remakeConstraints:^(MASConstraintMaker *make) {
        // make.width.height.equalTo(@20);
        make.width.height.equalTo(@0);
        make.centerY.equalTo(self.textFieldRole);
        make.left.equalTo(self).with.offset(20);
    }];
    
    [self.imageViewNumber mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@20);
        make.centerY.equalTo(self.textFieldNumber);
        make.left.equalTo(self).with.offset(20);
    }];
    
    [self.imageViewCode mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@20);
        make.centerY.equalTo(self.textFieldCode);
        make.left.equalTo(self).with.offset(20);
    }];
    
    [self.arrowButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        // make.width.height.equalTo(@15);
        make.width.height.equalTo(@0);
        make.right.equalTo(self).with.offset(-15);
        make.centerY.equalTo(self.textFieldRole);
    }];
}

- (UIImageView *)imageViewRole {
    if (!_imageViewRole) {
        _imageViewRole = [[UIImageView alloc] init];
        _imageViewRole.image = [UIImage imageNamed:@"人"];
    }
    return _imageViewRole;
}

- (UIImageView *)imageViewNumber {
    if (!_imageViewNumber) {
        _imageViewNumber = [[UIImageView alloc] init];
        _imageViewNumber.image = [UIImage imageNamed:@"手机"];
    }
    return _imageViewNumber;
}

- (UIImageView *)imageViewCode {
    if (!_imageViewCode) {
        _imageViewCode = [[UIImageView alloc] init];
    }
    return _imageViewCode;
}

- (UITextField *)textFieldRole {
    if (!_textFieldRole) {
        _textFieldRole = [[UITextField alloc] init];
        _textFieldCode.userInteractionEnabled = NO;
    }
    return _textFieldRole;
}

- (UITextField *)textFieldNumber {
    if (!_textFieldNumber) {
        _textFieldNumber = [[UITextField alloc] init];
        _textFieldNumber.placeholder = @"请输入手机号码";
    }
    return _textFieldNumber;
}

- (UITextField *)textFieldCode {
    if (!_textFieldCode) {
        _textFieldCode = [[UITextField alloc] init];
    }
    return _textFieldCode;
}

- (UIView *)line1 {
    if (!_line1) {
        _line1 = [[UIView alloc] init];
        _line1.backgroundColor = [UIColor colorWithHex:@"#e1e1e1"];
    }
    return _line1;
}

- (UIView *)line2 {
    if (!_line2) {
        _line2 = [[UIView alloc] init];
        _line2.backgroundColor = [UIColor colorWithHex:@"#e1e1e1"];
    }
    return _line2;
}

- (UIButton *)arrowButton {
    if (!_arrowButton) {
        _arrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_arrowButton setImage:[UIImage imageNamed:@"下箭头"] forState:UIControlStateNormal];
    }
    return _arrowButton;
}

@end
