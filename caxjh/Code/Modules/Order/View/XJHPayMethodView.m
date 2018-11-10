//
//  XJHPayMethodView.m
//  caxjh
//
//  Created by Yingchao Zou on 07/09/2017.
//  Copyright © 2017 Yingchao Zou. All rights reserved.
//

#import "XJHPayMethodView.h"

@interface XJHPayMethodView ()

@property (nonatomic, readwrite, strong) UILabel *titleLabel;
@property (nonatomic, readwrite, strong) UIView *lineView;

@property (nonatomic, readwrite, strong) UIImageView *alipayImageView;
@property (nonatomic, readwrite, strong) UILabel *alipayLabel;
@property (nonatomic, readwrite, strong) UIImageView *alipayCheckImageView;

@property (nonatomic, readwrite, strong) UIImageView *wechatImageView;
@property (nonatomic, readwrite, strong) UILabel *wechatLabel;
@property (nonatomic, readwrite, strong) UIImageView *wechatCheckImageView;

@property (nonatomic, readwrite, strong) UIButton *confirmButton;

@property (nonatomic, readwrite, assign) NSUInteger selectedPayMethod;

@property (nonatomic, readwrite, strong) UIView *alipayTouchView;
@property (nonatomic, readwrite, strong) UIView *wechatTouchView;

@end

@implementation XJHPayMethodView

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
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.lineView];
    
    [self addSubview:self.alipayImageView];
    [self addSubview:self.alipayLabel];
    [self addSubview:self.alipayCheckImageView];
    
    [self addSubview:self.wechatImageView];
    [self addSubview:self.wechatLabel];
    [self addSubview:self.wechatCheckImageView];
    
    [self addSubview:self.alipayTouchView];
    [self addSubview:self.wechatTouchView];
    
    [self addSubview:self.confirmButton];
    
    self.selectedPayMethod = 1;

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(@50);
    }];
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(0);
        make.height.equalTo(@1);
    }];
    
    [self.alipayImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(15);
        make.top.equalTo(self.lineView.mas_bottom).with.offset(20);
        make.width.height.equalTo(@25);
    }];
    [self.alipayLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.alipayImageView.mas_right).with.offset(10);
        make.centerY.equalTo(self.alipayImageView);
    }];
    [self.alipayCheckImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-15);
        make.centerY.equalTo(self.alipayImageView);
        make.width.height.equalTo(@18);
    }];
    
    [self.wechatImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.alipayImageView);
        make.top.equalTo(self.alipayImageView.mas_bottom).with.offset(15);
        make.width.height.equalTo(@25);
    }];
    [self.wechatLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.alipayLabel);
        make.centerY.equalTo(self.wechatImageView);
    }];
    [self.wechatCheckImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.wechatImageView);
        make.right.equalTo(self).with.offset(-15);
        make.width.height.equalTo(@18);
    }];
    
    [self.alipayTouchView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.lineView.mas_bottom);
        make.bottom.equalTo(self.wechatTouchView.mas_top);
        make.height.equalTo(self.wechatTouchView);
    }];
    [self.wechatTouchView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.confirmButton.mas_top);
        make.top.equalTo(self.alipayTouchView.mas_bottom);
    }];
    
    [self.confirmButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(15);
        make.right.equalTo(self).with.offset(-15);
        make.height.equalTo(@40);
        make.top.equalTo(self.wechatImageView.mas_bottom).with.offset(20);
    }];
}

#pragma mark - 

- (void)didTouchConfirmButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(confirmWithMethod:)]) {
        [self.delegate confirmWithMethod:self.selectedPayMethod];
    }
}

#pragma mark - 

- (void)setSelectedPayMethod:(NSUInteger)selectedPayMethod {
    _selectedPayMethod = selectedPayMethod;
    
    if (_selectedPayMethod == 1) {
        self.alipayCheckImageView.image = [UIImage imageNamed:@"选中"];
        self.wechatCheckImageView.image = [UIImage imageNamed:@"未选中"];
    }
    
    else if (_selectedPayMethod == 2) {
        self.alipayCheckImageView.image = [UIImage imageNamed:@"未选中"];
        self.wechatCheckImageView.image = [UIImage imageNamed:@"选中"];
    }
}

- (void)didTouchAlipayTouchView {
    self.selectedPayMethod = 1;
}

- (void)didTouchWechatTouchView {
    self.selectedPayMethod = 2;
}

#pragma mark -

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"选择支付方式";
        _titleLabel.textColor = [UIColor colorWithHex:@"#6b6b6b"];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHex:@"#e1e1e1"];
    }
    return _lineView;
}

- (UIImageView *)alipayImageView {
    if (!_alipayImageView) {
        _alipayImageView = [[UIImageView alloc] init];
        _alipayImageView.image = [UIImage imageNamed:@"支付宝"];
    }
    return _alipayImageView;
}

- (UILabel *)alipayLabel {
    if (!_alipayLabel) {
        _alipayLabel = [[UILabel alloc] init];
        _alipayLabel.text = @"支付宝";
    }
    return _alipayLabel;
}

- (UIImageView *)alipayCheckImageView {
    if (!_alipayCheckImageView) {
        _alipayCheckImageView = [[UIImageView alloc] init];
        _alipayCheckImageView.image = [UIImage imageNamed:@"未选中"];
    }
    return _alipayCheckImageView;
}

- (UIImageView *)wechatImageView {
    if (!_wechatImageView) {
        _wechatImageView = [[UIImageView alloc] init];
        _wechatImageView.image = [UIImage imageNamed:@"微信"];
    }
    return _wechatImageView;
}

- (UILabel *)wechatLabel {
    if (!_wechatLabel) {
        _wechatLabel = [[UILabel alloc] init];
        _wechatLabel.text = @"微信";
    }
    return _wechatLabel;
}

- (UIImageView *)wechatCheckImageView {
    if (!_wechatCheckImageView) {
        _wechatCheckImageView = [[UIImageView alloc] init];
        _wechatCheckImageView.image = [UIImage imageNamed:@"未选中"];
    }
    return _wechatCheckImageView;
}

- (UIView *)alipayTouchView {
    if (!_alipayTouchView) {
        _alipayTouchView = [[UIView alloc] init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouchAlipayTouchView)];
        [_alipayTouchView addGestureRecognizer:tap];
    }
    return _alipayTouchView;
}

- (UIView *)wechatTouchView {
    if (!_wechatTouchView) {
        _wechatTouchView = [[UIView alloc] init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouchWechatTouchView)];
        [_wechatTouchView addGestureRecognizer:tap];
    }
    return _wechatTouchView;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_confirmButton setTitle:@"确定支付" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor colorWithHex:@"#ffffff"] forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor colorWithHex:@"#ffffff"] forState:UIControlStateHighlighted];
        [_confirmButton setBackgroundColor:[UIColor colorWithHex:@"#ff6867"]];
        _confirmButton.layer.cornerRadius = 3;
        _confirmButton.layer.masksToBounds = YES;
        [_confirmButton addTarget:self action:@selector(didTouchConfirmButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

@end
