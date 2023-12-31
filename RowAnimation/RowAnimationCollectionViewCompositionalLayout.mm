//
//  RowAnimationCollectionViewCompositionalLayout.mm
//  RowAnimation
//
//  Created by Jinwoo Kim on 12/31/23.
//

#import "RowAnimationCollectionViewCompositionalLayout.hpp"

@implementation RowAnimationCollectionViewCompositionalLayout

- (void)dealloc {
    [_rowAnimationDataProvider release];
    [super dealloc];
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    UICollectionViewLayoutAttributes *result = [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
    
    switch (_rowAnimationDataProvider.rowAnimation) {
        case UITableViewRowAnimationFade:
            result.transform = CGAffineTransformIdentity;
            result.alpha = 0.f;
            break;
        case UITableViewRowAnimationRight:
            result.transform = CGAffineTransformMakeTranslation(result.size.width, 0.f);
            result.alpha = 0.f;
            break;
        case UITableViewRowAnimationLeft:
            result.transform = CGAffineTransformMakeTranslation(-result.size.width, 0.f);
            result.alpha = 0.f;
            break;
        case UITableViewRowAnimationTop:
            result.transform = CGAffineTransformMakeTranslation(0.f, -result.size.height);
            result.alpha = 1.f;
            break;
        case UITableViewRowAnimationBottom:
            result.transform = CGAffineTransformMakeTranslation(0.f, result.size.height);
            result.alpha = 0.f;
            break;
        case UITableViewRowAnimationNone:
            result.transform = CGAffineTransformIdentity;
            result.alpha = 1.f;
            break;
        case UITableViewRowAnimationMiddle:
            result.transform = CGAffineTransformMakeTranslation(0.f, -result.size.height);
            result.alpha = 0.f;
            break;
        case UITableViewRowAnimationAutomatic:
            result.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(0.1f, 0.1f), M_PI);
            result.alpha = 0.f;
            break;
        default:
            break;
    }
    
    return result;
}

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    UICollectionViewLayoutAttributes *result = [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
    
    switch (_rowAnimationDataProvider.rowAnimation) {
        case UITableViewRowAnimationFade:
            result.transform = CGAffineTransformIdentity;
            result.alpha = 0.f;
            break;
        case UITableViewRowAnimationRight:
            result.transform = CGAffineTransformMakeTranslation(result.size.width, 0.f);
            result.alpha = 0.f;
            break;
        case UITableViewRowAnimationLeft:
            result.transform = CGAffineTransformMakeTranslation(-result.size.width, 0.f);
            result.alpha = 0.f;
            break;
        case UITableViewRowAnimationTop:
            result.transform = CGAffineTransformMakeTranslation(0.f, -result.size.height);
            result.alpha = 1.f;
            break;
        case UITableViewRowAnimationBottom:
            result.transform = CGAffineTransformMakeTranslation(0.f, result.size.height);
            result.alpha = 0.f;
            break;
        case UITableViewRowAnimationNone:
            result.transform = CGAffineTransformIdentity;
            result.alpha = 1.f;
            break;
        case UITableViewRowAnimationMiddle:
            result.transform = CGAffineTransformMakeTranslation(0.f, -result.size.height);
            result.alpha = 0.f;
            break;
        case UITableViewRowAnimationAutomatic:
            result.transform = CGAffineTransformScale(CGAffineTransformMakeTranslation(0.f, CGRectGetMaxY(self.collectionView.bounds) - result.frame.origin.y), 0.1f, 0.1f);
            result.alpha = 1.f;
            break;
        default:
            break;
    }
    
    return result;
}

- (id) _propertyAnimatorForCollectionViewUpdates:(id)arg1 withCustomAnimator:(id)arg2 {
    UIViewPropertyAnimator *animator = [[UIViewPropertyAnimator alloc] initWithDuration:2.f curve:UIViewAnimationCurveEaseInOut animations:nil];
    
    return [animator autorelease];
}

@end
