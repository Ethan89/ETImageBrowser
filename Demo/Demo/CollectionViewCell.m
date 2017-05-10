//
//  CollectionViewCell.m
//  ETImageBrowser
//
//  Created by Ethan Guo on 17/4/17.
//  Copyright © 2017年 com.bjdv. All rights reserved.
//

#import "CollectionViewCell.h"
#import "Masonry.h"

@interface CollectionViewCell ()

@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation CollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutViews];
    }
    return self;
}

- (void)layoutViews {
    
    [self.contentView addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.left.bottom.right.equalTo(self.contentView);
    }];
}

#pragma mark - private method
- (void)p__updateCellInfo {
    UIImage *image = [UIImage imageNamed:self.imageNameString];
    self.imageView.image = image;
}

#pragma mark - getter and setters
- (void)setImageNameString:(NSString *)imageNameString {
    _imageNameString = imageNameString;
    
    [self p__updateCellInfo];
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.backgroundColor = [UIColor whiteColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}
@end
