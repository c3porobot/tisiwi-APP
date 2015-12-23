//
//  CXCycleScrollView.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/7.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "CXCycleScrollView.h"

#import "CXImageLoader.h"

#import "AJConstant.h"

#import "AppDelegate.h"

@interface CXCycleImageItem : NSObject

@property (nonatomic, strong) NSURL *imageURL;

@end


@interface CXCycleScrollView () <UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) NSMutableArray *imageItems;

@property (nonatomic, strong) NSMutableArray *imageViews;

@property (nonatomic, retain)  UIImageView    *placeImgView;


@end



@implementation pageNumberView
{
    UILabel    *_pageNumberLabel;
}
- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        [imgV setImage:[UIImage imageNamed:@"scrolBack"]];
        [self addSubview:imgV];
        
        _pageNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        [_pageNumberLabel setTextColor:[UIColor whiteColor]];
        [_pageNumberLabel setTextAlignment:NSTextAlignmentCenter];
        [_pageNumberLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [self addSubview:_pageNumberLabel];
    }
    return self;
}

- (void)updatePageLabelNumber:(NSString *)string
{
    [_pageNumberLabel setText:string];
}

@end


@implementation CXCycleImageItem

@end

@implementation CXCycleScrollView
{
    
    UILabel         *_pageLabel;
    pageNumberView  *_pageNumView;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}
//设置轮播图默认图片
- (void)setPlaceHolderImage:(NSString *)img
{
    _placeImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    [_placeImgView setImage:[UIImage imageNamed:img]];
    [self addSubview:_placeImgView];
}

- (void)setup
{
    self.switchTimeInterval = 10.f; //设置定时器, 轮播图隔多久跳到下一张
    self.autoScrolling = YES;
    self.imageItems = [NSMutableArray array];
    self.imageViews = [NSMutableArray array];
    
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.delegate = self;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.directionalLockEnabled = YES;
    _scrollView.alwaysBounceHorizontal = YES;
    
    // single tap gesture recognizer
    UITapGestureRecognizer *tapGestureRecognize = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureRecognizer:)];
    tapGestureRecognize.delegate = self;
    [_scrollView addGestureRecognizer:tapGestureRecognize];
    
    [self addSubview:_scrollView];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0.0f, height - 20.0f, width, 20.0f)];
    _pageControl.pageIndicatorTintColor = RGB(132, 65, 70);
    _pageControl.currentPageIndicatorTintColor = MAIN_COLOR;
    // [_pageControl addTarget:self action:@selector(pageControlTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    //  [self addSubview:_pageControl];
    
    _pageNumView = [[pageNumberView alloc] initWithFrame:CGRectMake(width/2-25, height - 25, 49, 18)];
    [self addSubview:_pageNumView];
    
}
//分页控制器设置,如果为YES则显示分页控制器,如果为NO则不显示分页控制器
- (void)setShowDot:(BOOL)showDot
{
    _showDot = showDot;
    if(_showDot)
    {
        [self addSubview:_pageControl];
        [_pageNumView removeFromSuperview];
    }
    else
    {
        [self addSubview:_pageNumView];
        [_pageControl removeFromSuperview];
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setImageURLArray:(NSArray *)imageURLArray
{
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    
    _imageURLArray = imageURLArray;
    
    if([_imageURLArray count] == 0)
    {
        _placeImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        [_placeImgView setImage:[UIImage imageNamed:@"banner_default"]];
        [self addSubview:_placeImgView];
    }
    else
    {
        if(_placeImgView)
        {
            [_placeImgView removeFromSuperview];
            _placeImgView = nil;
        }
    }
    
    [self.imageItems removeAllObjects];
    
    for (UIView *view in _scrollView.subviews) {
        [view removeFromSuperview];
    }
    //计算这个数组在这个block块里,具体意思我也不太懂~.~
    [_imageURLArray enumerateObjectsUsingBlock:^(id url, NSUInteger i, BOOL *finished){
        NSURL *imageURL = nil;
        if ([url isKindOfClass:[NSString class]]) {
            imageURL = [NSURL URLWithString:url];
        }
        else {
            imageURL = url;
        }
        
        CXCycleImageItem *imageItem = [CXCycleImageItem new];
        imageItem.imageURL = imageURL;
        [self.imageItems addObject:imageItem];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        if([_imageURLArray count]>1){
            imageView.frame = CGRectMake((i+1) * width, 0.0f, width, height);
        }else{
            imageView.frame = CGRectMake((i) * width, 0.0f, width, height);
        }
        imageView.backgroundColor = [UIColor clearColor];
        //        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        [[CXImageLoader sharedImageLoader] loadImageForURL:imageURL image:^(UIImage *image, NSError *error) {
            
            imageView.image = image;
        }];
        
        [_scrollView addSubview:imageView];
        [self.imageViews addObject:imageView];
    }];
    
    // 为了做无限轮播，把最后一张放在第一张的位置，把第一张放最后一张的位置
    if([_imageURLArray count]>1){
        UIImageView *firstImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, width, height)];
        firstImageView.backgroundColor = [UIColor clearColor];
        CXCycleImageItem *firstImageItem = [CXCycleImageItem new];
        firstImageItem.imageURL = _imageURLArray[[_imageURLArray count] - 1];
        [self.imageItems addObject:firstImageItem];
        
        [[CXImageLoader sharedImageLoader] loadImageForURL:firstImageItem.imageURL image:^(UIImage *image, NSError *error) {
            firstImageView.image = image;
        }];
        
        
        [_scrollView addSubview:firstImageView];
        
        [self.imageViews addObject:firstImageView];
        
        UIImageView *lastImageView = [[UIImageView alloc] initWithFrame:CGRectMake(width * ([_imageURLArray count] + 1), 0.0f, width, height)];
        lastImageView.backgroundColor = [UIColor clearColor];
        CXCycleImageItem *lastImageItem = [CXCycleImageItem new];
        lastImageItem.imageURL = _imageURLArray[0];
        [self.imageItems addObject:lastImageItem];
        
        [[CXImageLoader sharedImageLoader] loadImageForURL:lastImageItem.imageURL image:^(UIImage *image, NSError *error) {
            
            lastImageView.image = image;
            
        }];
        [_scrollView addSubview:lastImageView];
        [self.imageViews addObject:lastImageView];
    }
    
    _scrollView.contentSize = CGSizeMake(width * ([self.imageItems count]), height);
    _pageControl.enabled = YES;
    _pageControl.numberOfPages = [self.imageItems count] > 1 ? [self.imageItems count] - 2 : [self.imageItems count];
    _pageControl.currentPage = 0;
    
    if (_pageControl.numberOfPages == 1) {
        _scrollView.bounces = NO;
        _pageControl.hidden = YES;
    }
    else {
        _scrollView.bounces = YES;
        _pageControl.hidden = NO;
    }
    
    if ([self.imageItems count] > 1)
    {
        [_scrollView setContentOffset:CGPointMake(width, 0) animated:NO];
        
        if (self.autoScrolling)
        {
            [self performSelector:@selector(switchFocusImageItems) withObject:nil afterDelay:self.switchTimeInterval];
        }
    }else{
        self.autoScrolling = NO;
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
    if(_pageControl.numberOfPages <= 1)
    {
        //        _pageLabel.hidden = YES;
        _pageNumView.hidden = YES;
        _pageControl.hidden = YES;
    }
    else
    {
        [self setPageLabelNumber];
    }
    //  [self setNeedsDisplay];
}

- (void) setCurrentPage:(int)currentPage{
    _currentPage = currentPage;
    [self moveToTargetPage:currentPage];
}


#pragma mark - Actions

- (void)pageControlTapped:(UIPageControl *)sender
{
    [self moveToTargetPage:sender.currentPage];
}

- (void)singleTapGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    NSInteger targetPage = (NSInteger)(self.scrollView.contentOffset.x / self.scrollView.frame.size.width);
    if (targetPage > -1 && targetPage < _imageItems.count) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(cycleScrollView:didSelectIndex:)]) {
            
            if(targetPage == 0)
            {
                [_delegate cycleScrollView:self didSelectIndex:targetPage+1];
            }
            else
                [_delegate cycleScrollView:self didSelectIndex:targetPage];
        }
    }
}

#pragma mark - ScrollView Move

- (void)moveToTargetPage:(NSInteger)targetPage
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(switchFocusImageItems) object:nil];
    CGFloat targetX = targetPage * self.scrollView.frame.size.width;
    [self moveToTargetPosition:targetX];
    if (self.autoScrolling)
    {
        [self performSelector:@selector(switchFocusImageItems) withObject:nil afterDelay:self.switchTimeInterval]; //延迟执行一个方法
    }
    _pageControl.currentPage = targetPage - 1;
    [self setPageLabelNumber];
}

- (void)switchFocusImageItems
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(switchFocusImageItems) object:nil];
    
    CGFloat targetX = self.scrollView.contentOffset.x + self.scrollView.frame.size.width;
    [self moveToTargetPosition:targetX];
    
    //是否自动滚动
    if (self.autoScrolling) {
        [self performSelector:@selector(switchFocusImageItems) withObject:nil afterDelay:self.switchTimeInterval];
    }
}

- (void)moveToTargetPosition:(CGFloat)targetX
{
    //    if (targetX >= (self.scrollView.contentSize.width)) {
    //        targetX = 0.0;
    //    }
    
    if ([self.imageItems count] == 0) {
        return;
    }
    
    //    CXCycleImageItem *imageItem = (CXCycleImageItem *)self.imageItems[page];
    //    UIImageView *imageView = (UIImageView *)self.imageViews[page];
    //
    //    [[CXImageLoader sharedImageLoader] loadImageForURL:imageItem.imageURL image:^(UIImage *image, NSError *error) {
    //        imageView.image = image;
    //    }];
    
    CGFloat width = self.scrollView.frame.size.width;
    //当前页数
    NSInteger page = (NSInteger)(self.scrollView.contentOffset.x / width)+1;
    //    [self.scrollView setContentOffset:CGPointMake(targetX, 0) animated:NO];// warning:如果要定时无缝无限轮播，则需要抓住在定时轮播到最后一个的时候，偷偷换掉contentOffset
    if(page == 0){
        [_scrollView setContentOffset:CGPointMake(width * ([_imageURLArray count]), 0) animated:YES];
        _pageControl.currentPage = _pageControl.numberOfPages - 1;
    }else if(page == [_imageURLArray count]+1){
        [_scrollView setContentOffset:CGPointMake(width, 0) animated:YES];
        _pageControl.currentPage = 0;
    }else{
        [self.scrollView setContentOffset:CGPointMake(targetX, 0) animated:YES];
        _pageControl.currentPage = page-1;
    }
    [self setPageLabelNumber];
}

- (void)setAutoScrolling:(BOOL)enable
{
    _autoScrolling = enable;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(switchFocusImageItems) object:nil];
    if (_autoScrolling) {
        [self performSelector:@selector(switchFocusImageItems) withObject:nil afterDelay:self.switchTimeInterval];
    }
}
#pragma mark - UIScrollViewDelegate

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    self.pageControl.currentPage = (NSInteger)(scrollView.contentOffset.x / scrollView.frame.size.width);
//}
/*
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    float targetX = scrollView.contentOffset.x;
    //    CGFloat width = CGRectGetWidth(scrollView.bounds);
    //    if ([self.imageItems count] >= 3)
    //    {
    //        if (targetX >= width * ([self.imageItems count])) {
    //            targetX = width;
    //            [_scrollView setContentOffset:CGPointMake(targetX, 0) animated:NO];
    //        }
    //        else if(targetX <= 0)
    //        {
    //            targetX = width *([self.imageItems count]- 2);
    //            [_scrollView setContentOffset:CGPointMake(targetX, 0) animated:NO];
    //        }
    //    }
    //    NSInteger page = (_scrollView.contentOffset.x+width / 2.0) / width;
    //    NSInteger page = _scrollView.contentOffset.x/width;
    //    NSLog(@"%f %f %d",targetX,_scrollView.contentOffset.x,page);
    //    if ([self.imageItems count] > 1)
    //    {
    //        page--;
    
    //        if (page >= _pageControl.numberOfPages)
    //        {
    //            page = 0;
    //        }else if(page < 0)
    //        {
    //            page = _pageControl.numberOfPages - 1;
    //        }
    //    }
    //    if(page == 0){
    //        [scrollView setContentOffset:CGPointMake(width * ([_imageURLArray count]), 0)];
    //    }else if(page == [_imageURLArray count] + 1){
    //        [scrollView setContentOffset:CGPointMake(width, 0)];
    //    }
    
    //    _pageControl.currentPage = page;
}
*/
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGFloat width = CGRectGetWidth(scrollView.bounds);
    if (!decelerate)
    {
        CGFloat targetX = _scrollView.contentOffset.x + _scrollView.frame.size.width;
        targetX = (int)(targetX/width) * width;
        [self moveToTargetPosition:targetX];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    float targetX = scrollView.contentOffset.x;
    CGFloat width = CGRectGetWidth(scrollView.bounds);
    NSInteger page = targetX/width;
    if(page == 0){
        [scrollView setContentOffset:CGPointMake(width * ([_imageURLArray count]), 0)];
        _pageControl.currentPage = _pageControl.numberOfPages - 1;
    }else if(page == [_imageURLArray count] + 1){
        [scrollView setContentOffset:CGPointMake(width, 0)];
        _pageControl.currentPage = 0;
    }else{
        _pageControl.currentPage = page - 1;
    }
    [self setPageLabelNumber];
}

- (void)setPageLabelNumber{
    [_pageNumView updatePageLabelNumber:[NSString stringWithFormat:@"%zi/%tu", _pageControl.currentPage+1, _pageControl.numberOfPages]];
}

@end

