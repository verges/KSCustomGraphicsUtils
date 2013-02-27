//
// Created by Rafał Tulwin on 25.02.2013.
// rtulwin@gmail.com
//


#import <Foundation/Foundation.h>

@protocol KSHorizontalScrollingMenuDelegate <NSObject>

@required
    - (void)elementSelectedAtIndex:(NSInteger)index;
@end

@interface KSHorizontalScrollingMenu : UIView <UIScrollViewDelegate>

@property (nonatomic, unsafe_unretained, readwrite) id<KSHorizontalScrollingMenuDelegate> delegate;

-(id)initWithFrame:(CGRect)frame andElements:(NSArray *)elements;
- (void)setBackgroundImage:(UIImage *)image;
- (void)selectElementAtIndex:(NSInteger)index;

- (void)addElement:(UIView *)element atIndex:(NSInteger)index;
- (void)removeElementAtIndex:(NSInteger)index;
- (void)setupWithElements:(NSArray *)elements;

@end