//
//  FlowImageView.h
//  FlowImage
//
//  Created by 何松泽 on 2018/11/2.
//  Copyright © 2018年 HSZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlowImageCell.h"

static NSString *subViewClassName = @"FlowImageCell";

@class FlowImageView;

#pragma mark - FlowImageViewDelegate
@protocol FlowImageViewDelegate<NSObject>

@optional
/**
 *  设置每个Page的大小
 */
- (CGSize)sizeForFlowView:(FlowImageView *)flowImageView;

/**
 *  点击Cell事件
 */
- (void)didSelectCell:(FlowImageCell *)cell withIndex:(NSInteger)index;

@end

#pragma mark - FlowImageViewDataSorce
@protocol FlowImageViewDataSorce<NSObject>

/**
 *  cell的个数
 */
- (NSInteger)numberOfFlowImageView:(FlowImageView *)flowImageView;

@optional

/**
 *  每个Cell的设置
 */
- (FlowImageCell *)flowView:(FlowImageView *)flowImageView cellInFlowViewWithIndex:(NSInteger)index;

@end



@protocol FlowImageViewDataSorce;
@protocol FlowImageViewDelegate;

@interface FlowImageView : UIView<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSTimer *timer;

/* 设置 */
// 是否自动滚动 默认是
@property (nonatomic, assign) BOOL isAutoScroll;
// 是否无限次滚动 默认是
@property (nonatomic, assign) BOOL isForeverFlow;
// 滚动时间间隔
@property (nonatomic, assign) CGFloat flowTime;


/* 数据 */
@property (nonatomic, assign) NSInteger orginPageCount;
@property (nonatomic, assign, readonly) NSInteger currentPageIndex;
@property (nonatomic, weak) id <FlowImageViewDelegate>delegate;
@property (nonatomic, weak) id <FlowImageViewDataSorce>dataSource;


/* 布局 */
@property (nonatomic, assign) CGFloat leftRightMargin;
@property (nonatomic, assign) CGFloat topBottomMargin;


// 刷新
- (void)reloadData;
// 滚动到某页
//- (void)scrollToPage:(NSUInteger)pageNumber;
// 获取可重复使用的Cell
- (FlowImageCell *)dequeueReusableCell;


@end







