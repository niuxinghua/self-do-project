//
//  GYZChooseCityController.m
//  GYZChooseCityDemo
//  选择城市列表
//  Created by wito on 15/12/29.
//  Copyright © 2015年 gouyz. All rights reserved.
//

#import "GYZChooseCityController.h"
#import "GYZCityGroupCell.h"
#import "GYZCityHeaderView.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "PPNetworkHelper.h"
#import "Const.h"
#import "UIBarButtonItem+UC.h"
@interface GYZChooseCityController ()<GYZCityGroupCellDelegate,UISearchBarDelegate,CLLocationManagerDelegate>
/**
 *  记录所有城市信息，用于搜索
 */
@property (nonatomic, strong) NSMutableArray *recordCityData;
/**
 *  定位城市
 */
@property (nonatomic, strong) NSMutableArray *localCityData;
/**
 *  热门城市
 */
@property (nonatomic, strong) NSMutableArray *hotCityData;
/**
 *  最近访问城市
 */
@property (nonatomic, strong) NSMutableArray *commonCityData;
@property (nonatomic, strong) NSMutableArray *arraySection;
/**
 *  是否是search状态
 */
@property(nonatomic, assign) BOOL isSearch;
/**
 *  搜索框
 */
@property (nonatomic, strong) UISearchBar *searchBar;

/**
 *  搜索城市列表
 */
@property (nonatomic, strong) NSMutableArray *searchCities;
@property(nonatomic,retain)CLLocationManager *locationManager;
@end

NSString *const cityHeaderView = @"CityHeaderView";
NSString *const cityGroupCell = @"CityGroupCell";
NSString *const cityCell = @"CityCell";

@implementation GYZChooseCityController

-(void)viewDidLoad{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"城市选择"];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem uc_backBarButtonItemWithAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
   // [self locationStart];
    [self.tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    [self.tableView setSectionIndexColor:[UIColor blueColor]];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cityCell];
    [self.tableView registerClass:[GYZCityGroupCell class] forCellReuseIdentifier:cityGroupCell];
    [self.tableView registerClass:[GYZCityHeaderView class] forHeaderFooterViewReuseIdentifier:cityHeaderView];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.sectionIndexColor = [UIColor blackColor];
    //self.tableView.sectionIndexBackgroundColor =[UIColor blackColor];
    [self getData];
}
-(NSMutableArray *) cityDatas{
    if (_cityDatas == nil) {
        
        _cityDatas = [[NSMutableArray alloc]init];
        
        
        }
    return _cityDatas;
}





#pragma mark - Getter


#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cityDatas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *group = [self.cityDatas objectAtIndex:section];
    NSArray *list = [group objectForKey:@"list"];
    if (list.count) {
        return list.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cityCell];
    NSDictionary *group = [self.cityDatas objectAtIndex:[indexPath section]];
    NSArray *list = [group objectForKey:@"list"];
    NSDictionary *city = [list objectAtIndex:[indexPath row]];
    [cell.textLabel setText:[city objectForKey:@"name"]];
    
    return cell;
}

#pragma mark UITableViewDelegate
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //firstLetter
    NSDictionary *group = [self.cityDatas objectAtIndex:section];
    GYZCityHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:cityHeaderView];
    NSString *title = [group objectForKey:@"firstLetter"];
    headerView.titleLabel.text = title;
    return headerView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 23.5f;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *group = [self.cityDatas objectAtIndex:[indexPath section]];
    NSArray *list = [group objectForKey:@"list"];
    NSDictionary *city = [list objectAtIndex:[indexPath row]];
    [self didSelctedCity:city];

}

- (NSArray *) sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    for (NSDictionary *dic in self.cityDatas) {
        [array addObject:[dic objectForKey:@"firstLetter"]];
    }
    
    return array.copy;
}

- (NSInteger) tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (index == 0) {
        return -1;
    }
    return index - 1;
}


#pragma mark GYZCityGroupCellDelegate
- (void) cityGroupCellDidSelectCity:(NSDictionary *)dic
{
    [self didSelctedCity:dic];
}

#pragma mark - Event Response
- (void) cancelButtonDown:(UIBarButtonItem *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(cityPickerControllerDidCancel:)]) {
        [_delegate cityPickerControllerDidCancel:self];
    }
}
#pragma mark - Private Methods
- (void) didSelctedCity:(NSDictionary *)city
{
    if (_delegate && [_delegate respondsToSelector:@selector(cityPickerController:didSelectCity:)]) {
        [_delegate cityPickerController:self didSelectCity:city];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark --data

- (void)getData
{

    [PPNetworkHelper POST:kAPIQuerySortedCity parameters:nil success:^(id responseObject) {
        if ([responseObject objectForKey:@"data"]) {
            self.cityDatas = [responseObject objectForKey:@"data"];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
    
}

@end
