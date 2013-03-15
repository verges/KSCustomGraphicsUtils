//
// Created by Rafał Tulwin on 25.02.2013.
// rtulwin@gmail.com
//

#import "KSHorizontalScrollingMenu.h"

@implementation KSHorizontalScrollingMenu {
    UIScrollView * menuScroll;
    UIImageView * backgroundImageView;

    NSMutableArray * menuElements;
    __weak id <KSHorizontalScrollingMenuDelegate> delegate;
}

@synthesize delegate;

-(id)initWithFrame:(CGRect)frame andElements:(NSArray *)elements {
    self = [super initWithFrame: frame];
    if (self) {

        backgroundImageView = [[UIImageView alloc] init];
        [self addSubview:backgroundImageView];

        menuScroll = [[UIScrollView alloc] initWithFrame:CGRectZero];
        menuScroll.showsHorizontalScrollIndicator = NO;
        [menuScroll setCanCancelContentTouches:YES];
        menuScroll.delegate = self;
        [self addSubview:menuScroll];

        [self setupWithElements:elements];
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

- (void)objectTapped:(UITapGestureRecognizer *)sender {

    [menuScroll setContentOffset:CGPointMake(sender.view.frame.origin.x - menuScroll.bounds.size.width/2 +
            sender.view.bounds.size.width/2, 0) animated:YES];

    [self selectElementAtIndex:[menuElements indexOfObject:sender.view]];
}

- (void)scrollToIndex:(NSInteger)index {
    UIView * view = [menuElements objectAtIndex:index];

    [self scrollToElement:view];
}

- (void)scrollToElement:(UIView *)element {
    [menuScroll setContentOffset:CGPointMake(element.frame.origin.x - menuScroll.bounds.size.width/2 +
            element.bounds.size.width/2, 0) animated:YES];
}

- (void)setBackgroundImage:(UIImage *)image {
    [backgroundImageView setImage:image];
}

- (void)selectElementAtIndex:(NSInteger)index {
    [self scrollToIndex:index];
    if ([delegate respondsToSelector:@selector(elementSelectedAtIndex:)]) {
        [delegate elementSelectedAtIndex:index];
    }
}

- (void)addElement:(UIView *)element atIndex:(NSInteger)index {
    if (!menuElements) {
        menuElements = [[NSMutableArray alloc] init];
    }

    [menuElements insertObject:element atIndex:index];
    [self setNeedsLayout];
}

- (void)removeElementAtIndex:(NSInteger)index {
    [menuElements removeObjectAtIndex:index];
    [self setNeedsLayout];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self animateToClosestElement];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self animateToClosestElement];
    }
}

- (void)animateToClosestElement {
    if (menuElements.count > 0) {

        CGFloat firstElementHalfWidth = ((UIView *)[menuElements objectAtIndex:0]).bounds.size.width/2;

        UIView * chosenElement;

        if (menuScroll.contentOffset.x <= 0.0) {
            chosenElement = [menuElements objectAtIndex:0];
        } else if (menuScroll.contentOffset.x  + self.bounds.size.width/2 - firstElementHalfWidth > ((UIView *)[menuElements lastObject]).frame.origin.x) {
            chosenElement = [menuElements lastObject];
        } else {
            for (UIView * element in menuElements) {
               if (menuScroll.contentOffset.x  + self.bounds.size.width/2 > element.frame.origin.x &&
                       menuScroll.contentOffset.x  + self.bounds.size.width/2 <= element.frame.origin.x + element.bounds.size.width) {
                    chosenElement = element;
               }
            }
        }

        [self scrollToElement:chosenElement];
        if ([delegate respondsToSelector:@selector(elementSelectedAtIndex:)]) {
                [delegate elementSelectedAtIndex:[menuElements indexOfObject:chosenElement]];
        }

        NSLog(@"%f", menuScroll.contentOffset.x);
    }
}

- (void)setupWithElements:(NSArray *)elements {
    if (elements) {
        menuElements = [NSMutableArray arrayWithArray:elements];

        for (UIView * element in menuElements) {
            if ([element isKindOfClass:[UIView class]]) {
                UITapGestureRecognizer * tapGestureRecognizer = [[UITapGestureRecognizer alloc]
                        initWithTarget:self
                                action:@selector(objectTapped:)];
                [element addGestureRecognizer:tapGestureRecognizer];
                element.userInteractionEnabled = YES;
                [menuScroll addSubview:element];
            } else {
                NSLog(@"KSHorizontalScrollingMenu: element is not UIView");
            }
        }
    }
    [self setNeedsLayout];
}

- (void)setupWithStrings:(NSArray *)strings Font:(UIFont *)font TextColor:(UIColor *)color {
    NSMutableArray *elementArray = [[NSMutableArray alloc] initWithCapacity:strings.count];

    for (NSString *elementString in strings) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.text = elementString;
        label.textColor = color;
        label.font = font;
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        [elementArray addObject:label];
    }

    for (UIView *view in elementArray) {
        [view sizeToFit];
        view.frame = CGRectMake(0, 0, view.bounds.size.width + 30, view.bounds.size.height);
    }

    [self setupWithElements:elementArray];
}


@end
