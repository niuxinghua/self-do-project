//
//  XJHUserIndexTableViewCell.m
//  caxjh
//
//  Created by Yingchao Zou on 02/09/2017.
//  Copyright © 2017 Yingchao Zou. All rights reserved.
//

#import "XJHUserIndexTableViewCell.h"

@implementation XJHUserIndexTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    [self.contentView addSubview:self.theImageView];
    [self.contentView addSubview:self.theLabel];
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.theImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@20);
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).with.offset(15);
    }];
    
    [self.theLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.theImageView.mas_right).with.offset(10);
    }];
}

- (UIImageView *)theImageView {
    if (!_theImageView) {
        _theImageView = [[UIImageView alloc] init];
    }
    return _theImageView;
}

- (UILabel *)theLabel {
    if (!_theLabel) {
        _theLabel = [[UILabel alloc] init];
        _theLabel.textColor = [UIColor colorWithHex:@"#333333"];
    }
    return _theLabel;
}

@end
