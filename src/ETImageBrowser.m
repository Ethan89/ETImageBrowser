//
//  ETImageBrowser.m
//  ETImageBrowser
//
//  Created by Ethan Guo on 17/4/17.
//  Copyright © 2017年 com.bjdv. All rights reserved.
//

#import "ETImageBrowser.h"
#import "Masonry.h"

@interface ETImageBrowser () <UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView;
@property (assign, nonatomic) CGRect parentImageRect;

@end

@implementation ETImageBrowser

@synthesize image = _image;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    self.backgroundColor = [UIColor blackColor];
    
    UITapGestureRecognizer *oneTapGesture = [[UITapGestureRecognizer alloc] init];
    oneTapGesture.numberOfTapsRequired = 1;
    oneTapGesture.numberOfTouchesRequired = 1;
    [oneTapGesture addTarget:self action:@selector(e__oneTapGestureResponse)];
    
    [self addGestureRecognizer:oneTapGesture];
    
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] init];
    doubleTapGesture.numberOfTapsRequired = 2;
    doubleTapGesture.numberOfTouchesRequired = 1;
    [doubleTapGesture addTarget:self action:@selector(e__doubleTapGestureResponse)];
    
    [self addGestureRecognizer:doubleTapGesture];
    
    [oneTapGesture requireGestureRecognizerToFail:doubleTapGesture];

    [self setupUI_addScrollView];
    [self setupUI_addImageView];
}

- (void)setupUI_addScrollView {
    
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)setupUI_addImageView {
    
    [self.scrollView addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView);
    }];
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = MAX((scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5, 0);
    CGFloat offsetY = MAX((scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5, 0);
    self.scrollView.contentInset = UIEdgeInsetsMake(offsetY, offsetX, 0, 0);
}

#pragma mark - public method
- (void)showWithImageRect:(CGRect)rect {
    self.parentImageRect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    
    UIWindow *keywindow = [UIApplication sharedApplication].keyWindow;
    
    [keywindow addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(keywindow);
    }];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    [self p__showAnimation];
}

#pragma mark - private method
- (void)p__showAnimation {
    
    UIImageView *tempImageView = [[UIImageView alloc] init];
    tempImageView.contentMode = UIViewContentModeScaleAspectFit;
    tempImageView.image = self.image;
    [self addSubview:tempImageView];
    
    [tempImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).mas_offset(self.parentImageRect.origin.y);
        make.left.equalTo(self).mas_offset(self.parentImageRect.origin.x);
        make.size.mas_equalTo(self.parentImageRect.size);
    }];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    [tempImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView);
    }];
    __weak typeof(self) weakSelf = self;
    __weak typeof(UIImageView *) weakTempImage = tempImageView;
    [UIView animateWithDuration:.3f
                     animations:^{
                         [self setNeedsLayout];
                         [self layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         __strong typeof(self) strongSelf = weakSelf;
                         __strong typeof(UIImageView *) strongTempImage = weakTempImage;
                         strongSelf.imageView.hidden = NO;
                         [strongTempImage removeFromSuperview];
                     }];
}

- (void)p__dismissAnimation {
    
    CGRect newRect = [self.scrollView convertRect:self.imageView.frame toView:self];
    
    UIImageView *tempImageView = [[UIImageView alloc] init];
    tempImageView.contentMode = UIViewContentModeScaleAspectFit;
    tempImageView.image = self.image;
    [self addSubview:tempImageView];
    
    
    [tempImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).mas_offset(newRect.origin.y);
        make.left.equalTo(self).mas_offset(newRect.origin.x);
        make.width.mas_equalTo(newRect.size.width);
        make.height.mas_equalTo(newRect.size.height);
    }];

    self.imageView.hidden = YES;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];

    [tempImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).mas_offset(self.parentImageRect.origin.y);
        make.left.equalTo(self).mas_offset(self.parentImageRect.origin.x);
        make.size.mas_equalTo(self.parentImageRect.size);
    }];

    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:.3f
                     animations:^{
                         self.backgroundColor = [UIColor clearColor];
                         [self setNeedsLayout];
                         [self layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         __strong typeof(self) strongSelf = weakSelf;
                         [strongSelf removeFromSuperview];
                     }];
}

- (void)p__updateImage {
    NSLog(@"*****");
    
    self.imageView.image = self.image;
}

- (void)reset {
    [self.scrollView setZoomScale:1.f animated:YES];
}

#pragma mark - event response
- (void)e__oneTapGestureResponse {
    [self p__dismissAnimation];
}

- (void)e__doubleTapGestureResponse {
    if (self.scrollView.zoomScale == 1.f) {
        [self.scrollView setZoomScale:2.f animated:YES];
    } else {
        [self.scrollView setZoomScale:1.f animated:YES];
    }
}

#pragma mark - getters
- (UIImage *)image {
    return _image;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    
    [self p__updateImage];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
        _scrollView.delegate = self;
        _scrollView.maximumZoomScale = 5.f;
        _scrollView.minimumZoomScale = 1.f;
    }
    return _scrollView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.hidden = YES;
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.image = [UIImage imageNamed:@"namecard.jpg"];
    }
    return _imageView;
}

@end
