//
//  CircleLoaderView.m
//  Circle_Load
//
//  Created by 張家豪 on 2015/11/2.
//  Copyright © 2015年 Jacob.Zhang. All rights reserved.
//

#import "CircleLoaderView.h"

// you need Foundation, UIKit, QuartzCore, CoreGraphics ...Frameworks

#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>

@interface CircleLoaderView ()

@property (strong, nonatomic) CAShapeLayer *myLayer;

@property (strong,nonatomic)UIImageView *iconImageView;

@property (strong,nonatomic)UIImageView *animImageView;

@end

static CircleLoaderView *sharedInstance;

@implementation CircleLoaderView

-(id)initWithFrame:(CGRect)frame{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [super initWithFrame:frame];
    });
    
    
    self.backgroundColor = [UIColor clearColor];
  //  [self setMyShapeLayer];
   // [self animationStart];
    
    
    
   
    _iconImageView = [[UIImageView alloc]init];
    _iconImageView.frame = frame;
    [sharedInstance addSubview:_iconImageView];
    
    _animImageView = [[UIImageView alloc]init];
    _animImageView.frame = frame;
    [sharedInstance addSubview:_animImageView];
    [_animImageView setImage:[UIImage imageNamed:@"anim"]];
    
    _animImageView.hidden = YES;
    
    return sharedInstance;
}







#pragma mark -> spin Action

-(void)animationStart{
    
    CABasicAnimation *caAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    caAnimation.toValue = [NSNumber numberWithFloat:M_PI*2];
    caAnimation.duration = 1.0f;
    caAnimation.cumulative = YES;
    caAnimation.repeatCount = HUGE_VALF;
    [_animImageView.layer addAnimation:caAnimation forKey:@"CircleAnimation"];
    _animImageView.hidden = NO;
}
//- (void)setIconImage:(UIImage *)image
//{
//    [_iconImageView setImage:image];
//
//
//}
- (void)setCircleIconImage:(UIImage *)image
{
    [_iconImageView setImage:image];
    
}
#pragma mark -> stop Animation

-(void)animationStop{
    [_animImageView.layer removeAnimationForKey:@"CircleAnimation"];
    _animImageView.hidden = YES;
   // [self removeFromSuperview];
}

- (void)setCurrentState:(CircleLockState)currentState
{
    _currentState = currentState;
    if (_currentState == CircleLockStateLocked) {
        
        [_iconImageView setImage:[UIImage imageNamed:@"disconnected"]];
        
    }else if (currentState == CircleLockStateUnlocked)
    {
        [_iconImageView setImage:[UIImage imageNamed:@"lockopened"]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [_iconImageView setImage:[UIImage imageNamed:@"disconnected"]];
        });
        
    }else if (currentState == CircleLockStateConnected)
    {
        [_iconImageView setImage:[UIImage imageNamed:@"connected"]];
        
    }
    
    
}


@end
