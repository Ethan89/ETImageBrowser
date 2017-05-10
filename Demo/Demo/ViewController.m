//
//  ViewController.m
//  Demo
//
//  Created by Ethan Guo on 17/4/18.
//  Copyright © 2017年 bjdv. All rights reserved.
//

#import "ViewController.h"
#import "CollectionViewCell.h"
#import "Masonry.h"
#import "ETImageBrowser.h"

static NSString *const collectionCellID = @"DemoCellectionCellID";

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *imageArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make){
        UIEdgeInsets padding = UIEdgeInsetsMake(20.f, 0.f, 0.f, 0.f);
        make.edges.equalTo(self.view).mas_offset(padding);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDelegate and DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellID forIndexPath:indexPath];
    cell.imageNameString = self.imageArray[row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *attributes = [collectionView layoutAttributesForItemAtIndexPath:indexPath];
    CGRect cellFrameInSuperview = [collectionView convertRect:attributes.frame toView:[self.collectionView superview]];
    
    NSString *imageString = self.imageArray[indexPath.row];
    
    ETImageBrowser *imageBrowser = [[ETImageBrowser alloc] init];
    imageBrowser.image = [UIImage imageNamed:imageString];
    [imageBrowser showWithImageRect:cellFrameInSuperview];
}

#pragma mark - private method
- (CGFloat)p__calculateCellWidthWithItemPerRow:(NSInteger)count
                       minimumInteritemSpacing:(CGFloat)itemSpacing
                                  sectionInset:(UIEdgeInsets)inset {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat screenWidth = screenSize.width;
    return (screenWidth - itemSpacing - inset.left - inset.right) / count;
}

#pragma mark - getters
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.sectionInset = UIEdgeInsetsMake(10.f, 10.f, 10.f, 10.f);
        flowLayout.minimumLineSpacing = 10.f;
        flowLayout.minimumInteritemSpacing = 10.f;
        CGFloat itemWidth = [self p__calculateCellWidthWithItemPerRow:2 minimumInteritemSpacing:10.f sectionInset:flowLayout.sectionInset];
        flowLayout.itemSize = CGSizeMake(itemWidth, itemWidth);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:collectionCellID];
    }
    return _collectionView;
}

- (NSArray *)imageArray {
    if (!_imageArray) {
        _imageArray = @[
                        @"namecard.jpg",
                        @"idback.jpg",
                        @"argame01.jpg",
                        @"argame02.jpg"];
    }
    return _imageArray;
}
@end
