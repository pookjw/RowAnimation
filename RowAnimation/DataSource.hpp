//
//  DataSource.hpp
//  RowAnimation
//
//  Created by Jinwoo Kim on 12/30/23.
//

#import <UIKit/UIKit.h>
#import <variant>
#import "RowAnimationDataProvider.hpp"

NS_ASSUME_NONNULL_BEGIN

__attribute__((objc_direct_members))
@interface DataSource : NSObject
@property (assign, readonly, nonatomic) NSInteger numberOfSections;
@property (assign, nonatomic) UITableViewRowAnimation rowAnimation;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithView:(std::variant<UITableView *, UICollectionView *>)view rowAnimationDataProvider:(RowAnimationDataProvider *)rowAnimationDataProvider;
- (UIBarButtonItemGroup *)makeBarButtonItemGroup;
- (NSInteger)numberOfItemsInSection:(NSInteger)section;
@end

NS_ASSUME_NONNULL_END
