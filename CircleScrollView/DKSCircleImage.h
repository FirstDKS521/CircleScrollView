//
//  DKSCircleImage.h
//  CircleScrollView
//
//  Created by aDu on 16/8/12.
//  Copyright © 2016年 DuKaiShun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ImageIndexBlock)(NSInteger imageIndex);
@interface DKSCircleImage : UIView<UIScrollViewDelegate>

/**
 *  传递点击的哪张图片
 */
- (void)getSelectWhichImage:(ImageIndexBlock)imageIndex;

/**
 * 初始化
 */
- (id)initWithFrame:(CGRect)frame imageArray:(NSArray *)imageArray;

@end
