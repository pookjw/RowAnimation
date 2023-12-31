//
//  TableViewController.mm
//  RowAnimation
//
//  Created by Jinwoo Kim on 12/30/23.
//

#import "TableViewController.hpp"
#import "RowAnimationDataProvider.hpp"
#import "DataSource.hpp"

NSString * const reuseIdentifier = [NSString stringWithFormat:@"%p", &reuseIdentifier];

__attribute__((objc_direct_members))
@interface TableViewController ()
@property (retain, nonatomic) RowAnimationDataProvider *rowAnimationDataProvider;
@property (retain, nonatomic) DataSource *dataSource;
@end

@implementation TableViewController

- (void)dealloc {
    [_rowAnimationDataProvider release];
    [_dataSource release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:reuseIdentifier];
    
    RowAnimationDataProvider *rowAnimationDataProvider = [RowAnimationDataProvider new];
    DataSource *dataSource = [[DataSource alloc] initWithView:self.tableView rowAnimationDataProvider:rowAnimationDataProvider];
    
    UINavigationItem *navigationItem = self.navigationItem;
    
    auto trailingItemGroups = static_cast<NSMutableArray<UIBarButtonItemGroup *> *>([navigationItem.trailingItemGroups mutableCopy]);
    
    UIBarButtonItemGroup *animationGroup = [[UIBarButtonItemGroup alloc] initWithBarButtonItems:@[rowAnimationDataProvider.barButtonItem] representativeItem:nil];
    UIBarButtonItemGroup *dataSourceGroup = [dataSource makeBarButtonItemGroup];
    
    [trailingItemGroups addObject:animationGroup];
    [trailingItemGroups addObject:dataSourceGroup];
    [animationGroup release];
    
    navigationItem.trailingItemGroups = trailingItemGroups;
    [trailingItemGroups release];
    
    self.rowAnimationDataProvider = rowAnimationDataProvider;
    self.dataSource = dataSource;
    
    [rowAnimationDataProvider release];
    [dataSource release];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataSource.numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataSource numberOfItemsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    UIListContentConfiguration *contentConfiguration = [cell defaultContentConfiguration];
    contentConfiguration.text = [NSString stringWithFormat:@"%ld", indexPath.item];
    
    cell.contentConfiguration = contentConfiguration;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
