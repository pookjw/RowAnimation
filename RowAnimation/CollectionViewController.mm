//
//  CollectionViewController.mm
//  RowAnimation
//
//  Created by Jinwoo Kim on 12/30/23.
//

#import "CollectionViewController.hpp"
#import "RowAnimationDataProvider.hpp"
#import "DataSource.hpp"
#import "RowAnimationCollectionViewCompositionalLayout.hpp"

__attribute__((objc_direct_members))
@interface CollectionViewController ()
@property (retain, nonatomic) UICollectionViewCellRegistration *cellRegistration;
@property (retain, nonatomic) RowAnimationDataProvider *rowAnimationDataProvider;
@property (retain, nonatomic) DataSource *dataSource;
@end

@implementation CollectionViewController

- (instancetype)init {
    UICollectionLayoutListConfiguration *listConfiguration = [[UICollectionLayoutListConfiguration alloc] initWithAppearance:UICollectionLayoutListAppearanceInsetGrouped];
    RowAnimationCollectionViewCompositionalLayout *collectionViewLayout = [RowAnimationCollectionViewCompositionalLayout layoutWithListConfiguration:listConfiguration];
    [listConfiguration release];
    
    if (self = [super initWithCollectionViewLayout:collectionViewLayout]) {
        
    }
    
    return self;
}

- (void)dealloc {
    [_cellRegistration release];
    [_rowAnimationDataProvider release];
    [_dataSource release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionViewCellRegistration *cellRegistration = [UICollectionViewCellRegistration registrationWithCellClass:UICollectionViewListCell.class configurationHandler:^(__kindof UICollectionViewCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, NSString * _Nonnull item) {
        UIListContentConfiguration *contentConfiguration = [cell defaultContentConfiguration];
        contentConfiguration.text = item;
        
        cell.contentConfiguration = contentConfiguration;
    }];
    
    RowAnimationDataProvider *rowAnimationDataProvider = [RowAnimationDataProvider new];
    DataSource *dataSource = [[DataSource alloc] initWithView:self.collectionView rowAnimationDataProvider:rowAnimationDataProvider];
    
    static_cast<RowAnimationCollectionViewCompositionalLayout *>(self.collectionView.collectionViewLayout).rowAnimationDataProvider = rowAnimationDataProvider;
    
    UINavigationItem *navigationItem = self.navigationItem;
    
    auto trailingItemGroups = static_cast<NSMutableArray<UIBarButtonItemGroup *> *>([navigationItem.trailingItemGroups mutableCopy]);
    
    UIBarButtonItemGroup *animationGroup = [[UIBarButtonItemGroup alloc] initWithBarButtonItems:@[rowAnimationDataProvider.barButtonItem] representativeItem:nil];
    UIBarButtonItemGroup *dataSourceGroup = [dataSource makeBarButtonItemGroup];
    
    [trailingItemGroups addObject:animationGroup];
    [trailingItemGroups addObject:dataSourceGroup];
    [animationGroup release];
    
    navigationItem.trailingItemGroups = trailingItemGroups;
    [trailingItemGroups release];
    
    self.cellRegistration = cellRegistration;
    self.rowAnimationDataProvider = rowAnimationDataProvider;
    self.dataSource = dataSource;
    
    [rowAnimationDataProvider release];
    [dataSource release];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _dataSource.numberOfSections;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_dataSource numberOfItemsInSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueConfiguredReusableCellWithRegistration:_cellRegistration forIndexPath:indexPath item:[NSString stringWithFormat:@"%ld", indexPath.item]];
}

@end
