//
//  MultiCheckboxView.h
//
//  Created by Ed Rackham on 02/01/2013.
//  Copyright (c) 2013 edrackham.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MultiCheckboxView : UIView

@property (strong, nonatomic, setter = setCheckboxItems:) NSArray *checkboxItems;
@property (strong, nonatomic) NSMutableArray *selectedCheckboxItems;
@property (assign, nonatomic) BOOL autoResizeHeight;
@property (assign, nonatomic) NSInteger columns;

- (id)initWithFrame:(CGRect)frame checkboxItems:(NSArray *)checkboxItems columns:(NSInteger)columns autoResizeHeight:(BOOL)autoResizeHeight;
@end
