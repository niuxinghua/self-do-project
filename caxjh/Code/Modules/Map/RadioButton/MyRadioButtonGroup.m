//
//  MyRadioButtonGroup.m
//  WeiboClient
//
//  Created by flame_thupdi on 13-3-7.
//
//

#import "MyRadioButtonGroup.h"

@implementation MyRadioButtonGroup
@synthesize delegate;
@synthesize direction = _direction;
@synthesize autoFitButtonSize = _autoFitButtonSize;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = YES;
        _direction = Horizontal;
        _autoFitButtonSize = NO;
    }
    return self;
}

-(void)dealloc{
   // [super dealloc];
}

-(void)addRadioButton:(MyRadioButton *)radioButton{
    radioButton.delegate = self;
    [self addSubview:radioButton];
    CGRect rect = radioButton.frame;
    if (_autoFitButtonSize) {
        radioButtonSum ++;
        _fitButtonSize = CGSizeMake(self.frame.size.width/radioButtonSum, self.frame.size.height/radioButtonSum);
        float orignX = 0;
        float orignY = 0;
        for (UIView* view in self.subviews) {
            if ([view isKindOfClass:[MyRadioButton class]]) {
                MyRadioButton* radioButton = (MyRadioButton *)view;
                CGRect frame = radioButton.frame;
                frame.origin.x = orignX;
                frame.origin.y = orignY;
                frame.size = _fitButtonSize;
                radioButton.frame  = frame;
                if (_direction == Horizontal) {
                    orignX += _fitButtonSize.width;
                }
                else{
                    orignY += _fitButtonSize.height;
                }
                if (orignX > self.frame.size.width) {
                    orignX = 0;
                    orignY += _fitButtonSize.height;
                }
                if (orignY > self.frame.size.height){
                    orignY = 0;
                    orignX += _fitButtonSize.width;
                }
            }
        }
        return;
    }
    else{
        rect.origin.x = _currSubRadioX;
        rect.origin.y = _currSubRadioY;
        radioButton.frame = rect;
        if (_direction == Horizontal) {
            _currSubRadioX += radioButton.frame.size.width;
            if (_currSubRadioX+radioButton.frame.size.width > self.frame.size.width) {
                _currSubRadioX = 0;
                _currSubRadioY += radioButton.frame.size.height+Vspan;
            }
        }
        else
        {
            _currSubRadioY += radioButton.frame.size.height;
            if (_currSubRadioY+radioButton.frame.size.height > self.frame.size.height) {
                _currSubRadioX += radioButton.frame.size.width;
                _currSubRadioY = 0;
            }
        }
    }
}

-(void)myButton:(MyRadioButton *)button selectedWithIndex:(int)index{
    self.selectedIndex = index;
    [self setDefaultSeletedWithIndex:index];
    if (!self.delegate) {
        return;
    }
    else if([self.delegate respondsToSelector:@selector(myRadioButtonGroup:clickIndex:)]){
        [self.delegate myRadioButtonGroup:self clickIndex:index];
    }
}

-(void)setDefaultSeletedWithIndex:(int)index{
    for (UIView* view in self.subviews) {
        if ([view isKindOfClass:[MyRadioButton class]]) {
            MyRadioButton*  radioButton = (MyRadioButton *)view;
            if (view.tag == index) {
                [radioButton setSelected:YES];
            }
            else{
                [radioButton setSelected:NO];
            }
        }
    }
}
@end
