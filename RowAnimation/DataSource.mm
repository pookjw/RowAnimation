//
//  DataSource.mm
//  RowAnimation
//
//  Created by Jinwoo Kim on 12/30/23.
//

#import "DataSource.hpp"
#import <objc/message.h>

void *kvo_context = &kvo_context;

__attribute__((objc_direct_members))
@interface UICollectionView (RA_Category)
- (void)ra_performBatchUpdates:(void (^)(void))updates;
@end

@implementation UICollectionView (RA_Category)

- (void)ra_performBatchUpdates:(void (^)())updates {
    UIViewPropertyAnimator *animator = [[UIViewPropertyAnimator alloc] initWithDuration:1.f curve:UIViewAnimationCurveEaseInOut animations:nil];
    
    reinterpret_cast<void (*)(id, SEL, id, id)>(objc_msgSend)(self,
                                                              sel_registerName("performBatchUpdates:withAnimator:"),
                                                              updates,
                                                              animator);
    
    [animator release];
}

@end

__attribute__((objc_direct_members))
@interface DataSource ()
@property (assign, nonatomic) std::variant<UITableView *, UICollectionView *> view;
@property (retain, nonatomic) RowAnimationDataProvider *rowAnimationDataProvider;
@property (readonly, nonatomic) UITableView * _Nullable tableView;
@property (readonly, nonatomic) UICollectionView * _Nullable collectionView;
@property (assign, nonatomic) NSInteger numberOfItems;
@end

@implementation DataSource

- (instancetype)initWithView:(std::variant<UITableView *, UICollectionView *>)view rowAnimationDataProvider:(RowAnimationDataProvider *)rowAnimationDataProvider {
    if (self = [super init]) {
        _rowAnimation = UITableViewRowAnimationAutomatic;
        _rowAnimationDataProvider = [rowAnimationDataProvider retain];
        _view = view;
        [self.tableView retain];
        [self.collectionView retain];
        
        [rowAnimationDataProvider addObserver:self forKeyPath:@"rowAnimation" options:NSKeyValueObservingOptionNew context:kvo_context];
    }
    
    return self;
}

- (void)dealloc {
    [self.tableView release];
    [self.collectionView release];
    [super dealloc];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == kvo_context) {
        _rowAnimation = static_cast<UITableViewRowAnimation>(static_cast<NSNumber *>(change[NSKeyValueChangeNewKey]).integerValue);
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (NSInteger)numberOfSections {
    return 1;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    return _numberOfItems;
}

- (UIBarButtonItemGroup *)makeBarButtonItemGroup {
    UIBarButtonItem *decrementItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"minus"]
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(decrementItemDidTrigger:)];
    UIBarButtonItem *incrementItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"plus"]
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(incrementItemDidTrigger:)];
    
    UIBarButtonItemGroup *itemGroup = [[UIBarButtonItemGroup alloc] initWithBarButtonItems:@[decrementItem, incrementItem]
                                                                        representativeItem:nil];
    
    [decrementItem release];
    [incrementItem release];
    
    return [itemGroup autorelease];
}

- (UITableView *)tableView {
    if (UITableView **p = std::get_if<UITableView *>(&_view)) {
        return *p;
    } else {
        return nil;
    }
}

- (UICollectionView *)collectionView {
    if (UICollectionView **p = std::get_if<UICollectionView *>(&_view)) {
        return *p;
    } else {
        return nil;
    }
}

- (void)decrementItemDidTrigger:(UIBarButtonItem *)sender {
    if (_numberOfItems == 0) return;
    
    if (UITableView *tableView = self.tableView) {
        [tableView performBatchUpdates:^{
            _numberOfItems -= 1;
            [tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:_numberOfItems inSection:0]] withRowAnimation:_rowAnimation];
        }
                            completion:nil];
    } else if (UICollectionView *collectionView = self.collectionView) {
        [collectionView ra_performBatchUpdates:^{
            _numberOfItems -= 1;
            [collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:_numberOfItems inSection:0]]];
        }];
    }
}

- (void)incrementItemDidTrigger:(UIBarButtonItem *)sender {
    if (UITableView *tableView = self.tableView) {
        [tableView performBatchUpdates:^{
            _numberOfItems += 1;
            [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:_numberOfItems - 1 inSection:0]] withRowAnimation:_rowAnimation];
        }
                            completion:nil];
    } else if (UICollectionView *collectionView = self.collectionView) {
        [collectionView ra_performBatchUpdates:^{
            _numberOfItems += 1;
            [collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:_numberOfItems - 1 inSection:0]]];
        }];
    }
}

@end
