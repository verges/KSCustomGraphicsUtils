//
//  KSCustomSegmentedControl.m
//  KSCustomGraphicsUtils
//
//  Created by Rafał Tulwin on 08.12.2012.
//
//

#import "KSCustomSegmentedControl.h"

@implementation KSCustomSegmentedControl {

@private
    NSMutableArray * buttons;
    NSMutableArray * separators;
}

- (void)initWithButtons:(NSArray *)aButtons separators:(NSArray *)aSeparators {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        buttons = aButtons;
        separators = aSeparators;

        for (UIButton * button in buttons) {
            if ([button isKindOfClass:[UIButton class]]) {
                [self addSubview:button];
            } else{
                @throw [NSException exceptionWithName:@"incompatible type exception"
                                               reason:@"subvie is ought to be a UIButton" userInfo:nil];
            }
        }
        
        for (UIView * separator in separators) {
            if ([separator isKindOfClass:[UIView class]]) {
                [self addSubview:separator];
            } else{
                @throw [NSException exceptionWithName:@"incompatible type exception"
                                               reason:@"subvie is ought to be a UIView" userInfo:nil];
            }
        }
    }
    return self;
}

- (void)layoutSubviews {
    
}

@end