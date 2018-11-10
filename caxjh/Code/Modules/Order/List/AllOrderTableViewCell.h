//
//  AllOrderTableViewCell.h
//  caxjh
//
//  Created by niuxinghua on 2017/9/3.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZCheckBox.h"
typedef void(^selectIndexBlock)(NSNumber *index,float price);
typedef void(^didTapApplyButton)();
typedef void(^didDeselectApplyButton)(NSString *parentName);
@interface AllOrderTableViewCell : UITableViewCell<ZZCheckBoxDelegate, ZZCheckBoxDataSource, ZZCheckBoxStoryboardDataSource>
@property (nonatomic,strong)UILabel *titleLable;
@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)UILabel *descriptionLable;



@property (nonatomic,strong)ZZCheckBox *checkBox;
@property (nonatomic,copy)selectIndexBlock block;
@property (nonatomic,copy)selectIndexBlock deselectblock;

@property (nonatomic,copy)didTapApplyButton tapApply;

@property (nonatomic,copy)didDeselectApplyButton deselectApply;

@property(nonatomic,strong)NSDictionary *dic;

@property (nonatomic,strong)NSNumber *selectedNum;

@property (nonatomic,assign)BOOL flag;

@property (nonatomic,assign)CGFloat lableHeight;

@property (nonatomic,strong)UIButton *applyButton;

-(CGFloat)getLabelHeight:(NSString*)str;

@property (nonatomic,strong)NSMutableArray *buttonList;
-(void)reloadCellWith:(NSString*)parentName;
-(void)setSelectedParentList:(NSMutableArray *)selctList;
@end
