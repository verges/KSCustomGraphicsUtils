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
    NSMutableArray * leftActiveSeparators;
    NSMutableArray * rightActiveSeparators;
    __weak id <KSCustomSegmentedControlDelegate> delegate;
    CGFloat separatorWidth;
    UIButton * selectedButton;
}

@synthesize delegate;

- (id)initWithButtons:(NSArray *)aButtons separator:(UIImage *)separator
leftSelectedSeparator:(UIImage *)leftSelectedSeparator
        rightSelectedSeparator:(UIImage *)rightSelectedSeparator
        separatorWidth:(CGFloat)aSeparatorWidth {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        buttons = [NSMutableArray arrayWithArray:aButtons];
        separators = [[NSMutableArray alloc] init];
        leftActiveSeparators = [[NSMutableArray alloc] init];
        rightActiveSeparators = [[NSMutableArray alloc] init];
        UIImageView * separatorView;
        UIImageView * leftActiveSeparatorView;
        UIImageView * rightActiveSeparatorView;
        separatorWidth = aSeparatorWidth;

        for (UIButton * button in buttons) {
            if ([button isKindOfClass:[UIButton class]]) {
                [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:button];
                if (button != [buttons lastObject]) {
                    separatorView = [[UIImageView alloc] initWithImage:
                            [separator resizableImageWithCapInsets:
                                    UIEdgeInsetsMake(0, 0, 0, 0)]];
                    [separators addObject:separatorView];
                    [self addSubview:separatorView];

                    leftActiveSeparatorView = [[UIImageView alloc] initWithImage:
                            [leftSelectedSeparator resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)]];
                    leftActiveSeparatorView.hidden = YES;
                    [leftActiveSeparators addObject:leftActiveSeparatorView];
                    [self addSubview:leftActiveSeparatorView];

                    rightActiveSeparatorView = [[UIImageView alloc] initWithImage:
                            [rightSelectedSeparator resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)]];
                    rightActiveSeparatorView.hidden = YES;
                    [rightActiveSeparators addObject:rightActiveSeparatorView];
                    [self addSubview:rightActiveSeparatorView];
                }
            } else {
                @throw [NSException exceptionWithName:@"incompatible type exception"
                                               reason:@"subview is ought to be a UIButton" userInfo:nil];
            }
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    UIImageView * tempSeparator;
    CGFloat currentLeft = 0;
    NSInteger i = 0;

    for (UIButton * button in buttons) {
        if ([button isKindOfClass:[UIButton class]]) {
            button.frame = CGRectMake(currentLeft,
                    0, (self.bounds.size.width - separatorWidth * (buttons.count - 1))/buttons.count, self.bounds.size.height);

            currentLeft += button.bounds.size.width;

            if (i < buttons.count - 1) {
                tempSeparator = [separators objectAtIndex:i];
                tempSeparator.frame = CGRectMake(currentLeft, 0, separatorWidth, self.bounds.size.height);

                tempSeparator = [leftActiveSeparators objectAtIndex:i];
                tempSeparator.frame = CGRectMake(currentLeft, 0, separatorWidth, self.bounds.size.height);

                tempSeparator = [rightActiveSeparators objectAtIndex:i];
                tempSeparator.frame = CGRectMake(currentLeft, 0, separatorWidth, self.bounds.size.height);

                currentLeft += separatorWidth;
            }
            i++;
        } else{
            @throw [NSException exceptionWithName:@"incompatible type exception"
                                           reason:@"subview is ought to be a UIButton" userInfo:nil];
        }
    }
}

- (void)buttonClicked:(UIButton *)sender {

    NSInteger newIndex = [buttons indexOfObject:sender];
    NSInteger oldIndex = -1;
    if (selectedButton) {
        oldIndex = [buttons indexOfObject:selectedButton];
        [selectedButton setSelected:NO];
    }

    [sender setSelected:YES];

    if (oldIndex >= 0) {
        if (oldIndex != 0) {
            ((UIView *) [leftActiveSeparators objectAtIndex:oldIndex - 1]).hidden = YES;
            ((UIView *) [separators objectAtIndex:oldIndex - 1]).hidden = NO;
        }
        if (oldIndex < buttons.count - 1) {
            ((UIView *) [rightActiveSeparators objectAtIndex:oldIndex]).hidden = YES;
            ((UIView *)[separators objectAtIndex:oldIndex]).hidden = NO;
        }
    }

    if (newIndex != 0) {
        ((UIView *) [separators objectAtIndex:newIndex - 1]).hidden = YES;
        ((UIView *) [leftActiveSeparators objectAtIndex:newIndex -1]).hidden = NO;
    }
    if (newIndex < buttons.count - 1) {
        ((UIView *)[separators objectAtIndex:newIndex]).hidden = YES;
        ((UIView *) [rightActiveSeparators objectAtIndex:newIndex]).hidden = NO;
    }

    selectedButton = sender;
    [delegate ksCustomSegmentedControlChangedSelectedIndexTo:newIndex];
}

@end