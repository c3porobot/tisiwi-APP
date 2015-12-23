//
//  CXCycleScrollView.h
//  tianshiwan
//
//  Created by zhouhai on 15/9/7.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CXCycleScrollViewDelegate;

@interface CXCycleScrollView : UIView

@property (nonatomic, weak) id <CXCycleScrollViewDelegate> delegate;

@property (nonatomic, strong) NSArray *imageURLArray; 

@property (nonatomic, assign) BOOL autoScrolling;
@property (nonatomic, assign) NSTimeInterval switchTimeInterval; // default for 10.0s
@property (nonatomic, assign) int currentPage;// start from 1

@property (nonatomic, assign) BOOL showDot;//default is NO. number


- (void)setPlaceHolderImage:(NSString *)img;

@end

@protocol CXCycleScrollViewDelegate <NSObject>

- (void)cycleScrollView:(CXCycleScrollView *)cycleScrollView didSelectIndex:(NSInteger)index;

@end



@interface pageNumberView : UIView

- (void)updatePageLabelNumber:(NSString *)string;

@end

