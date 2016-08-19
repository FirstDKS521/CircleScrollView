//
//  ViewController.m
//  CircleScrollView
//
//  Created by aDu on 16/8/11.
//  Copyright © 2016年 DuKaiShun. All rights reserved.
//

#import "ViewController.h"
#import "DKSCircleImage.h"

#define K_Width [UIScreen mainScreen].bounds.size.width

static NSInteger const imageCount = 3;

@interface ViewController ()

@property (nonatomic, strong) DKSCircleImage *circleImage;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, assign) NSInteger currentPage; //当前的点数

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.scrollView];
    
    [self addImage];
    
    [self.view addSubview:self.pageControl];
    
    //添加定时器
    [self addTimer];
    
    
    //封装的
    NSArray *imageArray = @[@"image1", @"image2", @"image3"];
    self.circleImage = [[DKSCircleImage alloc] initWithFrame:CGRectMake(0, 300, K_Width, 200) imageArray:imageArray];
    [self.circleImage getSelectWhichImage:^(NSInteger imageIndex) {
        NSLog(@"点击了第%d张图片", imageIndex);
    }];
    [self.view addSubview:self.circleImage];
}

#pragma mark - 添加图片

- (void)addImage
{
    UIImageView *image0 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, K_Width, 200)];
    image0.backgroundColor = [UIColor yellowColor];
    image0.userInteractionEnabled = YES;
    image0.tag = 100;
    UITapGestureRecognizer *tap0 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [image0 addGestureRecognizer:tap0];
    [self.scrollView addSubview:image0];
    
    UIImageView *image1 = [[UIImageView alloc] initWithFrame:CGRectMake(K_Width, 0, K_Width, 200)];
    image1.userInteractionEnabled = YES;
    image1.tag = 101;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [image1 addGestureRecognizer:tap1];
    image1.backgroundColor = [UIColor redColor];
    [self.scrollView addSubview:image1];
    
    UIImageView *image2 = [[UIImageView alloc] initWithFrame:CGRectMake(K_Width * 2, 0, K_Width, 200)];
    image2.userInteractionEnabled = YES;
    image2.tag = 102;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [image2 addGestureRecognizer:tap2];
    image2.backgroundColor = [UIColor orangeColor];
    [self.scrollView addSubview:image2];
    
    UIImageView *image3 = [[UIImageView alloc] initWithFrame:CGRectMake(K_Width * 3, 0, K_Width, 200)];
    image3.userInteractionEnabled = YES;
    image3.tag = 103;
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [image3 addGestureRecognizer:tap3];
    image3.backgroundColor = [UIColor yellowColor];
    [self.scrollView addSubview:image3];
    
    UIImageView *image4 = [[UIImageView alloc] initWithFrame:CGRectMake(K_Width * 4, 0, K_Width, 200)];
    image4.userInteractionEnabled = YES;
    image4.tag = 104;
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [image4 addGestureRecognizer:tap4];
    image4.backgroundColor = [UIColor redColor];
    [self.scrollView addSubview:image4];
}

#pragma mark - 图片点击事件

- (void)tap:(UITapGestureRecognizer *)tap
{
    NSLog(@"点击了第%d张图片", tap.view.tag - 100);
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
        _scrollView.frame = CGRectMake(0, 50, K_Width, 200);
        _scrollView.backgroundColor = [UIColor blackColor];
        _scrollView.contentSize = CGSizeMake(K_Width * (imageCount + 2), 200);
        _scrollView.bounces = NO; //左右不晃动
        _scrollView.pagingEnabled = YES;  //整屏滚动
        _scrollView.delegate = self;
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

- (DKSCircleImage *)circleImage
{
    if (!_circleImage) {
        _circleImage = [[DKSCircleImage alloc] initWithFrame:CGRectMake(0, 300, K_Width, 200) imageArray:nil];
    }
    return _circleImage;
}

@end
