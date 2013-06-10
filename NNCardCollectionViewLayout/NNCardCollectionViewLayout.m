//
//  NNCardCollectionViewLayout.m
//  NNCardCollectionViewLayout
//
//  Created by Naoto Horiguchi on 2013/06/10.
//  Copyright (c) 2013年 Naoto Horiguchi. All rights reserved.
//

#import "NNCardCollectionViewLayout.h"


@interface NNCardCollectionViewLayoutShadowView : UICollectionReusableView

@end

@implementation NNCardCollectionViewLayoutShadowView : UICollectionReusableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.4f];
        static dispatch_once_t onceToken;
        static int instanceNum;
        dispatch_once(&onceToken, ^{
            instanceNum = 0;
        });
        instanceNum++;
        NSLog(@"instance:%d",instanceNum);
    }
    return self;
}

@end

@implementation NNCardCollectionViewLayout

- (id)init
{
    self = [super init];
    if (self) {
        [self registerClass:[NNCardCollectionViewLayoutShadowView class] forDecorationViewOfKind:@"shadow"];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self registerClass:[NNCardCollectionViewLayoutShadowView class] forDecorationViewOfKind:@"shadow"];
    }
    return self;
}

- (CGSize)collectionViewContentSize
{
    int count = [self.collectionView numberOfItemsInSection:0];
    return CGSizeMake(self.collectionView.bounds.size.width, self.collectionView.bounds.size.height * count);
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *indexPaths = [self indexPathsForItemsInRect:rect];
    NSMutableArray *attrElements = @[].mutableCopy;
    for (NSIndexPath *indexPath in indexPaths) {
        [attrElements addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
        [attrElements addObject:[self layoutAttributesForDecorationViewOfKind:@"shadow" atIndexPath:indexPath]];
    }
    return attrElements;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind atIndexPath:(NSIndexPath *)indexPath
{
    if (![decorationViewKind isEqualToString:@"shadow"]) {
        return nil;
    }
    
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:decorationViewKind withIndexPath:indexPath];
    
    CGFloat offsetY = indexPath.item * self.collectionView.bounds.size.height;
    
    CGRect frame;
    frame.origin.x = 0;
    frame.origin.y = offsetY;
    frame.size = self.collectionView.bounds.size;
    attr.frame = frame;
    
    CATransform3D t = CATransform3DIdentity;
    
    //t.m34 = -1.0 / 10000;
    
    if (offsetY > self.collectionView.contentOffset.y) {
        float y = 1.0f - (offsetY - self.collectionView.contentOffset.y) / self.collectionView.frame.size.height;
        NSLog(@"%f",y);
        
        t = CATransform3DTranslate(t, 0, -(offsetY-self.collectionView.contentOffset.y)
                                   , -1);
        attr.alpha = 1.f - y;
    }else {
        attr.alpha = 0.0;
    }
    
    attr.transform3D = t;
    //
    //    NSLog(@"hoge");
    return attr;
    
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGFloat offsetY = indexPath.item * self.collectionView.bounds.size.height;
    CGRect frame;
    frame.origin.x = 0;
    frame.origin.y = offsetY;
    frame.size = self.collectionView.bounds.size;
    attr.frame = frame;
    
    CATransform3D t = CATransform3DIdentity;
    //t.m34 = -1.0 / 10000;
    if (offsetY > self.collectionView.contentOffset.y) {
        if (self.collectionView.contentOffset.y <= 0) {
            float y = 1.0f - (offsetY - self.collectionView.contentOffset.y) / self.collectionView.frame.size.height;
            t = CATransform3DTranslate(t, 0, -(offsetY-self.collectionView.contentOffset.y)
                                       , -1);
            float scale = 0.9f + ((1.0f-0.9f) * y);
            t = CATransform3DScale(t, scale, scale, 1);
        } else {
            float y = 1.0f - (offsetY - self.collectionView.contentOffset.y) / self.collectionView.frame.size.height;
            t = CATransform3DTranslate(t, 0, -(offsetY-self.collectionView.contentOffset.y)
                                       , -1);
            float scale = 0.99f + ((1.0f-0.99f) * y);
            t = CATransform3DScale(t, scale, scale, 1);
        }
    }
    attr.transform3D = t;
    //
    //    NSLog(@"hoge");
    return attr;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

- (NSArray *)indexPathsForItemsInRect:(CGRect)rect
{
    float cellHeight = self.collectionView.bounds.size.height;
    int startIndex = MAX(rect.origin.y / cellHeight, 0);
    NSLog(NSStringFromCGRect(rect));
    NSMutableArray *indexPaths = @[].mutableCopy;
    for (int i = startIndex; i < [self.collectionView numberOfItemsInSection:0] && (i - 1) * cellHeight < self.collectionView.contentOffset.y; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForItem:i inSection:0]];
    }
    
    return indexPaths;
}

@end
