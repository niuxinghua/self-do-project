//
//  MyRadioButton.h
//  WeiboClient
//
//  Created by flame_thupdi on 13-3-4.
//
//

#import <UIKit/UIKit.h>
@class MyRadioButton;
@protocol MyRadioButtonDelegate<NSObject>
-(void)myButton:(MyRadioButton *)button selectedWithIndex:(int)index;
@end


@interface MyRadioButton : UIView{
    UIButton *_button;
    UILabel* _titleLabel;
    int _index;
    BOOL _autoFitSubSize;
}
@property(nonatomic,assign)id<MyRadioButtonDelegate> delegate;
@property(nonatomic,assign)BOOL autoFitSubSize;
-(id)initWithTitle:(NSString *)title andIndex:(int)index withFrame:(CGRect)frame autoSubSize:(BOOL)autoSize;
-(void)setSelected:(BOOL)selected;
@end
