//
//  KSCustomSegmentedControl.h
//  KSCustomGraphicsUtils
//
//  Created by Rafał Tulwin on 08.12.2012.
//
//

#import <UIKit/UIKit.h>

@protocol KSCustomSegmentedControlDelegate <NSObject>

@required
    - (void)ksCustomSegmentedControlChangedSelectedIndexTo:(NSInteger)index;

@end

@interface KSCustomSegmentedControl : UIView

@property (nonatomic, weak, readwrite) id <KSCustomSegmentedControlDelegate> delegate;

- (id)initWithButtons:(NSArray *)aButtons separator:(UIImage *)separator leftSelectedSeparator:(UIImage *)leftSelectedSeparator rightSelectedSeparator:(UIImage *)rightSelectedSeparator separatorWidth:(CGFloat)aSeparatorWidth;

@end
