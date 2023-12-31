//
//  RootViewController.mm
//  RowAnimation
//
//  Created by Jinwoo Kim on 12/30/23.
//

#import "RootViewController.hpp"
#import "TableViewController.hpp"
#import "CollectionViewController.hpp"

NSString * const reuseIdentifier = [NSString stringWithFormat:@"%p", &reuseIdentifier];

@interface RootViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@end

@implementation RootViewController

- (instancetype)init {
    UICollectionLayoutListConfiguration *listConfiguration = [[UICollectionLayoutListConfiguration alloc] initWithAppearance:UICollectionLayoutListAppearanceInsetGrouped];
    UICollectionViewCompositionalLayout *collectionViewLayout = [UICollectionViewCompositionalLayout layoutWithListConfiguration:listConfiguration];
    [listConfiguration release];
    
    if (self = [super initWithCollectionViewLayout:collectionViewLayout]) {
        [self.collectionView registerClass:UICollectionViewListCell.class forCellWithReuseIdentifier:reuseIdentifier];
    }
    
    return self;
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 2;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    UIListContentConfiguration *contentConfiguration = [cell defaultContentConfiguration];
    
    switch (indexPath.item) {
        case 0:
            contentConfiguration.text = NSStringFromClass(UITableView.class);
            break;
        case 1:
            contentConfiguration.text = NSStringFromClass(UICollectionView.class);
            break;
        default:
            break;
    }
    
    cell.contentConfiguration = contentConfiguration;
    
    return cell;
}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.item) {
        case 0: {
            TableViewController *tableViewController = [[TableViewController alloc] initWithStyle:UITableViewStyleInsetGrouped];
            [self.navigationController pushViewController:tableViewController animated:YES];
            [tableViewController release];
            break;
        }
        case 1: {
            CollectionViewController *collectionViewController = [CollectionViewController new];
            [self.navigationController pushViewController:collectionViewController animated:YES];
            [collectionViewController release];
            break;
        }
        default:
            break;
    }
}

@end
