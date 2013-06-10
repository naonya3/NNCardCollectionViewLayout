//
//  NNViewController.m
//  NNCardViewCollectionViewLayout
//
//  Created by Naoto Horiguchi on 2013/06/10.
//  Copyright (c) 2013年 Naoto Horiguchi. All rights reserved.
//

#import "NNViewController.h"

@interface NNCell : UICollectionViewCell
{
}

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation NNCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat hue = ( arc4random() % 256 / 256.0 );
        CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
        CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
        UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
        self.contentView.backgroundColor = color;
        
        float labelWidth = 320.f;
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.frame = CGRectMake(0, 150.f, labelWidth, 22.f);
        self.titleLabel.font = [UIFont boldSystemFontOfSize:22.f];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.shadowColor = [UIColor colorWithWhite:0.f alpha:0.8f];
        self.titleLabel.shadowOffset = CGSizeMake(0, 1);
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

@end

@implementation NNViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_collectionView registerClass:[NNCell class] forCellWithReuseIdentifier:@"cell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 30;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NNCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.titleLabel.text = [@(indexPath.row) stringValue];
    return cell;
}



@end
