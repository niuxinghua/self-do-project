//
//  UCQRCodeScanView.m
//  WuRenJi
//
//  Created by Yingchao Zou on 23/11/2016.
//  Copyright © 2016 Casey. All rights reserved.
//

#import "UCQRCodeScanView.h"

@interface UCQRCodeScanView ()

@property (nonatomic, assign) CGPoint position;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIImageView *cornerImageView;

@end

@implementation UCQRCodeScanView

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
    
    self.backgroundColor = [UIColor clearColor];
    
    self.cornerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scan_box"]];
    [self addSubview:self.cornerImageView];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(setNeedsDisplay) userInfo:nil repeats:YES];
    
    self.position = CGPointMake(0, 0);
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.cornerImageView.frame = self.bounds;
}

- (void)drawRect:(CGRect)rect {
    CGPoint newPosition = self.position;
    newPosition.y += 1;
    
    if (newPosition.y > rect.size.height) {
        newPosition.y = 0;
    }
    
    self.position = newPosition;
    
    UIImage *image = [UIImage imageNamed:@"scan_line"];
    [image drawAtPoint:self.position];
}

#pragma mark - 

- (void)startAnimation {
    [self.timer setFireDate:[NSDate date]];
}

- (void)stopAnimation {
    [self.timer setFireDate:[NSDate distantFuture]];
}

@end
