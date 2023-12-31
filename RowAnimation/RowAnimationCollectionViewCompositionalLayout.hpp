//
//  RowAnimationCollectionViewCompositionalLayout.hpp
//  RowAnimation
//
//  Created by Jinwoo Kim on 12/31/23.
//

#import <UIKit/UIKit.h>
#import "RowAnimationDataProvider.hpp"

NS_ASSUME_NONNULL_BEGIN

__attribute__((objc_direct_members))
@interface RowAnimationCollectionViewCompositionalLayout : UICollectionViewCompositionalLayout
@property (retain, nonatomic) RowAnimationDataProvider * _Nullable rowAnimationDataProvider;
@end

NS_ASSUME_NONNULL_END
