//
// Created by Rafał Tulwin on 25.02.2013.
// rtulwin@gmail.com
//


#import <CoreGraphics/CoreGraphics.h>
#import "KSHorizontalScrollingMenu.h"


@implementation KSHorizontalScrollingMenu {
    UIScrollView * menuScroll;
    UIImageView * backgroundImageView;

    NSMutableArray * menuElements;
}

-(id)initWithFrame:(CGRect)frame andElements:(NSArray *)elements {
    self = [super initWithFrame: frame];
    if (self) {
        menuScroll = [[UIScrollView alloc] initWithFrame:CGRectZero];
        [self addSubview:menuScroll];

        menuElements = [NSMutableArray arrayWithArray:elements];

        for (UIView * element in menuElements) {
            [menuScroll addSubview:element];
        }

        backgroundImageView = [[UIImageView alloc] init];
        [self addSubview:backgroundImageView];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    backgroundImageView.frame = self.bounds;

    menuScroll.frame = self.bounds;

    if (menuElements.count > 0) {

        CGFloat currentElementsWidth = 0;
        CGFloat currentLeft = menuScroll.bounds.size.width/2 -
                ((UIView *)[menuElements objectAtIndex:0]).bounds.size.width/2;

        for (UIView * element in menuElements) {
            element.frame = CGRectMake(currentLeft,
                    menuScroll.bounds.size.height/2 - element.bounds.size.height/2,
                    element.bounds.size.width, element.bounds.size.height);
            currentElementsWidth += element.bounds.size.width;

            currentLeft = CGRectGetMaxX(element.frame);
        }

        menuScroll.contentSize = CGSizeMake(currentElementsWidth +
                (menuScroll.bounds.size.width/2 - ((UIView *) [menuElements objectAtIndex:0]).bounds.size.width/2) +
                (menuScroll.bounds.size.width/2 - ((UIView *) [menuElements lastObject]).bounds.size.width/2),
                menuScroll.bounds.size.height);
    }
}

-(void)setBackgroundImage:(UIImage *)image {
    [backgroundImageView setImage:image];
}

@end