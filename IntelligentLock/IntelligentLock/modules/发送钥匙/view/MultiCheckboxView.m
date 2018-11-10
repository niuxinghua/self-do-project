//
//  MultiCheckboxView.m
//
//  Created by Ed Rackham on 02/01/2013.
//  Copyright (c) 2013 edrackham.com. All rights reserved.
//

#import "MultiCheckboxView.h"

#define kOffImage           @"tickBoxOff.png"
#define kOnImage            @"tickBoxOn.png"
#define kCheckboxHeight     34
#define kCheckboxHSpacing   10
#define kCheckboxVSpacing   0

@implementation MultiCheckboxView{
    NSMutableArray  *_checkboxes;
    UIScrollView    *_checkboxScrollView;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self initalise];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self initalise];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame checkboxItems:(NSArray *)checkboxItems columns:(NSInteger)columns autoResizeHeight:(BOOL)autoResizeHeight{
    self = [super initWithFrame:frame];
    if(self){
        [self initalise];
        _columns            = columns;
        _autoResizeHeight   = autoResizeHeight;
        [self setCheckboxItems:checkboxItems];
    }
    return self;
}

- (void)initalise{
    [self setBackgroundColor:[UIColor clearColor]];
    [self setClipsToBounds:YES];
    _columns = 4;
}

- (void)setCheckboxItems:(NSArray *)checkboxItems{
    _checkboxItems          = checkboxItems;
    _checkboxes             = [NSMutableArray new];
    _selectedCheckboxItems  = [NSMutableArray new];
    
    
    NSInteger   checkboxIndex   = 0;
    NSInteger   row             = 0;
    NSInteger   yPos            = 0;
    UIImage     *offImage       = [UIImage imageNamed:@"unchecked"];
    NSInteger   checkboxWidth = self.frame.size.width;
    
    
    if(_columns > 1){
        checkboxWidth = (self.frame.size.width - (kCheckboxHSpacing * (_columns - 1))) / _columns;
    }
    
    
    if(_checkboxScrollView != nil){
        [_checkboxScrollView removeFromSuperview];
        _checkboxScrollView = nil;
    }
    
    for(UIView *aView in self.subviews){
        [aView removeFromSuperview];
    }
    
    if(!_autoResizeHeight){
        _checkboxScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:_checkboxScrollView];
    }
    
    for(NSString *item in _checkboxItems){
        
        CGRect checkboxFrame;
        
        yPos = (row * kCheckboxHeight) + (row * kCheckboxVSpacing);
        
        if(_columns < 2){
            checkboxFrame = CGRectMake(0, yPos, checkboxWidth, kCheckboxHeight);
            row++;
        }else{
            NSInteger multiplier    = (checkboxIndex % _columns);
            NSInteger xPos          = (multiplier * checkboxWidth) + (multiplier * kCheckboxHSpacing);
            
            if(multiplier == 0 && checkboxIndex > 0){
                row++;
                yPos = (row * kCheckboxHeight) + (row * kCheckboxVSpacing);
            }
            
            checkboxFrame = CGRectMake(xPos, yPos, checkboxWidth, kCheckboxHeight);
        }
        
        UIButton *checkbox = [[UIButton alloc] initWithFrame:checkboxFrame];
        [checkbox setTitle:item forState:UIControlStateNormal];
        [checkbox setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [checkbox setImage:offImage forState:UIControlStateNormal];
        [checkbox setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [[checkbox titleLabel] setFont:[UIFont fontWithName:@"Helvetica" size:11.0]];
        [checkbox addTarget:self action:@selector(toggleCheckbox:) forControlEvents:UIControlEventTouchUpInside];
        [checkbox setTag:checkboxIndex];
        [_checkboxes addObject:checkbox];
        
        if(_checkboxScrollView != nil){
            [_checkboxScrollView addSubview:checkbox];
        }else{
            [self addSubview:checkbox];
        }
        
        checkboxIndex++;
    }
    
    if(_checkboxScrollView != nil){
        [_checkboxScrollView setContentSize:CGSizeMake(self.frame.size.width, yPos + kCheckboxHeight + kCheckboxVSpacing)];
    }
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, yPos + kCheckboxHeight + kCheckboxVSpacing);
    
}

- (void)toggleCheckbox:(id)sender{
    UIButton *checkbox = (UIButton *)sender;
    NSInteger checkboxIndex = checkbox.tag;
    NSString *checkboxItem = [_checkboxItems objectAtIndex:checkboxIndex];
    
    if([_selectedCheckboxItems containsObject:checkboxItem]){
        [_selectedCheckboxItems removeObject:checkboxItem];
        [checkbox setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
    }else{
        [_selectedCheckboxItems addObject:checkboxItem];
        [checkbox setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
    }
    
    [_checkboxes replaceObjectAtIndex:checkboxIndex withObject:checkbox];
    
}

@end
