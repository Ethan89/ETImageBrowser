//
//  ETImageBrowser.h
//  ETImageBrowser
//
//  Created by Ethan Guo on 17/4/17.
//  Copyright © 2017年 com.bjdv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ETImageBrowser : UIView

/** image to show */
@property (strong, nonatomic) UIImage *image;

/**
 *  show image browser
 *
 *  @param rect the rect of parent image
 */
- (void)showWithImageRect:(CGRect)rect;

@end
