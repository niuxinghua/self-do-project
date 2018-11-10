//
//  MyRadioButtonGroup.h
//  WeiboClient
//
//  Created by flame_thupdi on 13-3-7.
//
//

#import <UIKit/UIKit.h>
#import "MyRadioButton.h"
#import "MyRadioButtonConstant.h"

@class MyRadioButtonGroup;
@protocol MyRadioButtonGroupDelegate<NSObject>
-(void)myRadioButtonGroup:(MyRadioButtonGroup *)radioButtonGruop clickIndex:(int)index;
@end

@interface MyRadioButtonGroup : UIView<MyRadioButtonDelegate>
{
    enum Orientation _direction;
    int _currSubRadioX;
    int _currSubRadioY;
    BOOL _autoFitButtonSize;
    CGSize _fitButtonSize;
    int radioButtonSum;
}
-(void)addRadioButton:(MyRadioButton *)radioButton;
-(void)setDefaultSeletedWithIndex:(int)index;
@property(nonatomic,assign) id<MyRadioButtonGroupDelegate> delegate;
@property(nonatomic,assign) int selectedIndex;
@property(nonatomic,assign) enum Orientation direction;
@property(nonatomic,assign) BOOL autoFitButtonSize;
@end

