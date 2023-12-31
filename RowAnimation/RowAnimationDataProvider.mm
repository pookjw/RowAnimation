//
//  RowAnimationDataProvider.mm
//  RowAnimation
//
//  Created by Jinwoo Kim on 12/30/23.
//

#import "RowAnimationDataProvider.hpp"
#import <array>
#import <vector>
#import <ranges>

__attribute__((objc_direct_members))
@interface RowAnimationDataProvider ()
@property (retain, nonatomic) UIBarButtonItem *barButtonItem;
@end

@implementation RowAnimationDataProvider

- (instancetype)init {
    if (self = [super init]) {
        _rowAnimation = UITableViewRowAnimationAutomatic;
        
        UIDeferredMenuElement *deferredMenuElement = [self makeDeferredMenuElementWithCompletionHandler:nil];
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:[self titleFromRowAnimation:_rowAnimation] menu:[UIMenu menuWithChildren:@[deferredMenuElement]]];
        barButtonItem.image = [self imageFromRowAnimation:_rowAnimation];
        
        [_barButtonItem release];
        _barButtonItem = [barButtonItem retain];
        [barButtonItem release];
    }
    
    return self;
}

- (void)dealloc {
    [_barButtonItem release];
    [super dealloc];
}

- (void)setRowAnimation:(UITableViewRowAnimation)rowAnimation {
    [self willChangeValueForKey:@"rowAnimation"];
    
    _rowAnimation = rowAnimation;
    _barButtonItem.title = [self titleFromRowAnimation:rowAnimation];
    _barButtonItem.image = [self imageFromRowAnimation:rowAnimation];
    
    [self didChangeValueForKey:@"rowAnimation"];
}

- (UIDeferredMenuElement *)makeDeferredMenuElementWithCompletionHandler:(void (^ _Nullable)(UITableViewRowAnimation rowAnimation))selectionHandler {
    return [UIDeferredMenuElement elementWithUncachedProvider:^(void (^ _Nonnull completion)(NSArray<UIMenuElement *> * _Nonnull)) {
        __weak decltype(self) weakSelf = self;
        
        auto actions = std::array<UITableViewRowAnimation, 8> {
            UITableViewRowAnimationFade,
            UITableViewRowAnimationRight,
            UITableViewRowAnimationLeft,
            UITableViewRowAnimationTop,
            UITableViewRowAnimationBottom,
            UITableViewRowAnimationNone,
            UITableViewRowAnimationMiddle,
            UITableViewRowAnimationAutomatic
        } | std::views::transform([self, selectionHandler, weakSelf](UITableViewRowAnimation rowAnimation) -> UIAction * {
            UIAction *action = [UIAction actionWithTitle:[self titleFromRowAnimation:rowAnimation]
                                       image:[self imageFromRowAnimation:rowAnimation]
                                  identifier:nil
                                     handler:^(__kindof UIAction * _Nonnull action) {
                weakSelf.rowAnimation = rowAnimation;
                
                if (selectionHandler) {
                    selectionHandler(rowAnimation);
                }
            }];
            
            action.state = (_rowAnimation == rowAnimation) ? UIMenuElementStateOn : UIMenuElementStateOff;
            
            return action;
        });
        
        auto actionsArray = std::vector<UIAction *>(actions.begin(), actions.end());
        
        completion([NSArray arrayWithObjects:actionsArray.data() count:actionsArray.size()]);
    }];
}

- (NSString *)titleFromRowAnimation:(UITableViewRowAnimation)rowAnimation __attribute__((objc_direct)) {
    switch (rowAnimation) {
        case UITableViewRowAnimationFade:
            return @"Fade";
        case UITableViewRowAnimationRight:
            return @"Right";
        case UITableViewRowAnimationLeft:
            return @"Left";
        case UITableViewRowAnimationTop:
            return @"Top";
        case UITableViewRowAnimationBottom:
            return @"Bottom";
        case UITableViewRowAnimationNone:
            return @"None";
        case UITableViewRowAnimationMiddle:
            return @"Middle";
        case UITableViewRowAnimationAutomatic:
            return @"Automatic";
        default:
            return @"Automatic";
    }
}

- (UIImage *)imageFromRowAnimation:(UITableViewRowAnimation)rowAnimation __attribute__((objc_direct)) {
    switch (rowAnimation) {
        case UITableViewRowAnimationFade:
            return [UIImage systemImageNamed:@"circle.dotted.and.circle"];
        case UITableViewRowAnimationRight:
            return [UIImage systemImageNamed:@"arrow.left"];
        case UITableViewRowAnimationLeft:
            return [UIImage systemImageNamed:@"arrow.right"];
        case UITableViewRowAnimationTop:
            return [UIImage systemImageNamed:@"arrow.down"];
        case UITableViewRowAnimationBottom:
            return [UIImage systemImageNamed:@"arrow.up"];
        case UITableViewRowAnimationNone:
            return [UIImage systemImageNamed:@"xmark"];
        case UITableViewRowAnimationMiddle:
            return [UIImage systemImageNamed:@"arrow.up.and.line.horizontal.and.arrow.down"];
        case UITableViewRowAnimationAutomatic:
            return [UIImage systemImageNamed:@"automatic.headlight.high.beam"];
        default:
            return [UIImage systemImageNamed:@"automatic.headlight.high.beam"];
    }
}

@end
