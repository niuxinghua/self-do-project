//
//  XJHCallView.m
//  caxjh
//
//  Created by Yingchao Zou on 03/09/2017.
//  Copyright © 2017 Yingchao Zou. All rights reserved.
//

#import "XJHCallView.h"

@interface XJHCallView ()

@property (nonatomic, readwrite, strong) UIImageView *theImageView;
@property (nonatomic, readwrite, strong) UILabel *theLabel;

@end

@implementation XJHCallView

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
    
    self.backgroundColor = [UIColor colorWithHex:@"#fff8f8"];
    
    self.layer.cornerRadius = 17.5;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = [UIColor colorWithHex:@"#ffcbcb"].CGColor;
    self.layer.borderWidth = 1.0;
    
    [self addSubview:self.theImageView];
    [self addSubview:self.theLabel];
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
//    [self.theImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.equalTo(@15);
//        make.centerY.equalTo(self);
//        make.left.equalTo(@5);
//    }];
//    
//    [self.theLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.theImageView.mas_right).with.offset(5);
//        make.centerY.equalTo(self);
//    }];
    
    [self.theImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@15);
        make.centerY.equalTo(self);
        make.right.equalTo(self.theLabel.mas_left).with.offset(-5);
    }];
    
    [self.theLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.centerX.equalTo(self).with.offset(10);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTouchCallView:)]) {
        [self.delegate didTouchCallView:self];
    }
}

- (UIImageView *)theImageView {
    if (!_theImageView) {
        _theImageView = [[UIImageView alloc] init];
        _theImageView.image = [UIImage imageNamed:@"客服中心-电话"];
    }
    return _theImageView;
}

- (UILabel *)theLabel {
    if (!_theLabel) {
        _theLabel = [[UILabel alloc] init];
        _theLabel.text = @"010-6938-3422";
        _theLabel.textColor = [UIColor colorWithHex:@"#ff6767"];
    }
    return _theLabel;
}

@end
