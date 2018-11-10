//
//  ScanButtonView.m
//  IntelligentLock
//
//  Created by tshario on 23/03/2018.
//  Copyright © 2018 com.haier. All rights reserved.
//

#import "ScanButtonView.h"
#import "Masonry.h"
#import "MultiLanTool.h"
@interface ScanButtonView()

@property (nonatomic) UIImageView *imageView;
@property (nonatomic) UILabel *label;
#define kMultiTool [MultiLanTool sharedInstance]
@end

@implementation ScanButtonView

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
    [self addSubview:self.imageView];
    [self addSubview:self.label];
    
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 20;
    return self;
}

- (void)layoutSubviews {
    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
    }];
    [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
    }];
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.image = [UIImage imageNamed:@""];
    }
    return _imageView;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.text = [kMultiTool getMultiLanByKey:@"shoudongshuru"];
        _label.backgroundColor = [UIColor clearColor];
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont systemFontOfSize:12.0];
    }
    return _label;
}

@end
