//
// Created by Rafał Tulwin on 25.02.2013.
// rtulwin@gmail.com
//


#import <Foundation/Foundation.h>

@class KSHorizontalScrollingMenu;

@protocol KSHorizontalScrollingMenuDelegate <NSObject>

@required
- (void)elementSelectedAtIndex:(NSInteger)index withMenu:(KSHorizontalScrollingMenu *)menu;
@end

@interface KSHorizontalScrollingMenu : UIView <UIScrollViewDelegate>

@property (nonatomic, weak, readwrite) id<KSHorizontalScrollingMenuDelegate> delegate;

-(id)initWithFrame:(CGRect)frame andElements:(NSArray *)elements;
- (void)setBackgroundImage:(UIImage *)image;
- (void)selectElementAtIndex:(NSInteger)index;

- (void)addElement:(UIView *)element atIndex:(NSInteger)index;
- (void)removeElementAtIndex:(NSInteger)index;
- (void)setupWithElements:(NSArray *)elements;

- (void)setupWithStrings:(NSArray *)strings font:(UIFont *)font textColor:(UIColor *)color horizontalMargin:(CGFloat)horizontalMargin verticalMargin:(CGFloat)verticalMargin;

@end