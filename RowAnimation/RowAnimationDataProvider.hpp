//
//  RowAnimationDataProvider.hpp
//  RowAnimation
//
//  Created by Jinwoo Kim on 12/30/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

__attribute__((objc_direct_members))
@interface RowAnimationDataProvider : NSObject
@property (assign, nonatomic) UITableViewRowAnimation rowAnimation;
@property (retain, readonly, nonatomic) UIBarButtonItem *barButtonItem;
- (UIDeferredMenuElement *)makeDeferredMenuElementWithCompletionHandler:(void (^ _Nullable)(UITableViewRowAnimation rowAnimation))selectionHandler;
@end

NS_ASSUME_NONNULL_END
