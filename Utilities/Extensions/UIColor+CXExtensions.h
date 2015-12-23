//
//  UIColor+CXExtensions.h
//
//  Created by XiongCaixing on 15/1/15.
//  Copyright (c) 2015年 熊财兴. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (CXExtensions)

/**
 *  Creates and returns a new color object whose brightness component is decreased by the given value, using the initial color values of the receiver.
 *
 *  @param value A floating point value describing the amount by which to decrease the brightness of the receiver.
 *
 *  @return A new color object whose brightness is decreased by the given values. The other color values remain the same as the receiver.
 */
- (UIColor *)cx_colorByDarkeningColorWithValue:(CGFloat)value;

@end
