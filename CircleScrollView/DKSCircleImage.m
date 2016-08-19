//
//  DKSCircleImage.m
//  CircleScrollView
//
//  Created by aDu on 16/8/12.
//  Copyright © 2016年 DuKaiShun. All rights reserved.
//

#import "DKSCircleImage.h"

#define K_Width [UIScreen mainScreen].bounds.size.width

static NSInteger imageCount; //图片个数
@interface DKSCircleImage ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, assign) NSInteger currentPage; //当前的点数

@property (nonatomic, strong) NSTimer *timer; //定时器

@property (nonatomic, copy) ImageIndexBlock imageIndex;  //选取的哪张图片

@end

@implementation DKSCircleImage

- (id)initWithFrame:(CGRect)frame imageArray:(NSArray *)imageArray
{
    self = [super initWithFrame:frame];
    if (self) {
        imageCount = imageArray.count;
        [self addSubview:self.scrollView];
        [self addImageWithArray:imageArray];
        [self addSubview:self.pageControl];
        [self addTimer];
    }
    return self;
}

#pragma mark - 添加图片

- (void)addImageWithArray:(NSArray *)imageArray
{
    for (int i = 0; i < imageArray.count + 2; i++) {
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(K_Width * i, 0, K_Width, self.frame.size.height)];
        NSString *imageName = @"";
        if (i == 0) {
            imageName = imageArray[imageArray.count - 1];
        }
         else if (i == imageArray.count + 1) {
            imageName = imageArray[0];
        }
         else {
            imageName = imageArray[i - 1];
        }
        image.image = [UIImage imageNamed:imageName];
        image.tag = 100 + i;
        image.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [image addGestureRecognizer:tap];
        [self.scrollView addSubview:image];
    }
}

#pragma mark - 图片点击事件

- (void)tap:(UITapGestureRecognizer *)tap
{
    if (self.imageIndex) {
        self.imageIndex(tap.view.tag - 100);
    }
}

- (void)getSelectWhichImage:(ImageIndexBlock)imageIndex
{
    self.imageIndex = imageIndex;
}

#pragma mark - 定时器

- (void)addTimer
{
    self.timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)timerAction
{
    if (self.currentPage > imageCount) {
        self.currentPage = 1;
    }
    self.currentPage++;
    [UIView animateWithDuration:0.25 animations:^{
        self.scrollView.contentOffset = CGPointMake(K_Width * self.currentPage, 0);
    } completion:^(BOOL finished) {
        [self scrollViewDidEndDecelerating:self.scrollView];
    }];
}

#pragma mark - 暂停定时器

- (void)pasueTimer
{
    [_timer invalidate];
    _timer = nil;
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat offSetX = scrollView.contentOffset.x;
    self.currentPage = offSetX / K_Width;
    if (offSetX > K_Width * imageCount) {  //向左滑动
        self.pageControl.currentPage = 0;
        scrollView.contentOffset = CGPointMake(K_Width, 0);
    } else if (offSetX < K_Width) {  //向右滑动
        self.pageControl.currentPage = 2;
        self.currentPage = imageCount;
        scrollView.contentOffset = CGPointMake(K_Width * imageCount, 0);
    } else {
        self.pageControl.currentPage = offSetX / K_Width - 1;
    }
}

#pragma mark - init

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(0, 0, K_Width, self.frame.size.height);
        _scrollView.contentSize = CGSizeMake(K_Width * (imageCount + 2), 0);
        _scrollView.bounces = NO; //左右不晃动
        _scrollView.pagingEnabled = YES;  //整屏滚动
        _scrollView.delegate = self;
        _scrollView.backgroundColor = [UIColor colorWithWhite:0.714 alpha:1.000];
        _scrollView.showsHorizontalScrollIndicator = NO;
        //滚动视图刚开始时滚动一个屏幕的宽度，让其处在第一张视图那里
        _scrollView.contentOffset = CGPointMake(K_Width, 0);
        self.currentPage = 1;
    }
    return _scrollView;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        //注意此方法可以根据页数返回UIPageControl合适的大小
        CGSize size= [_pageControl sizeForNumberOfPages:imageCount];
        _pageControl.frame  = CGRectMake(K_Width - size.width - 30, CGRectGetMaxY(self.scrollView.frame) - size.height, size.width, size.height);
        //设置颜色
        _pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:0.846 alpha:1.000];
        //设置当前页颜色
        _pageControl.currentPageIndicatorTintColor = [UIColor colorWithWhite:0.600 alpha:1.000];
        //设置总页数
        _pageControl.numberOfPages = imageCount;
    }
    return _pageControl;
}

@end
