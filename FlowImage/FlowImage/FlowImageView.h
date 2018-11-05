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

@protocol FlowImageViewDataSorce;
@protocol FlowImageViewDelegate;

@interface FlowImageView : UIView<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
// 是否自动滚动 默认是
@property (nonatomic, assign) BOOL isAutoScroll;
// 是否无限次滚动 默认是
@property (nonatomic, assign) BOOL isForeverFlow;
// 滚动时间间隔
@property (nonatomic, assign) CGFloat flowTime;
// 页数
@property (nonatomic, assign) NSInteger orginPageCount;
// 当前页的索引值
@property (nonatomic, assign, readonly) NSInteger currentPageIndex;
// 代理
@property (nonatomic, weak) id <FlowImageViewDelegate>delegate;
@property (nonatomic, weak) id <FlowImageViewDataSorce>dataSource;
// 可视范围
@property (nonatomic, assign) NSRange visibleRange;
// 布局
@property (nonatomic, assign) CGFloat leftRightMargin;
@property (nonatomic, assign) CGFloat topBottomMargin;

// 建议使用的初始化方法
//- (instancetype)initWithFrame:(CGRect)frame forLayout:(FlowImageViewLayout *)layout;
// 刷新
- (void)reloadData;
// 滚动到某页
//- (void)scrollToPage:(NSUInteger)pageNumber;
// 获取可重复使用的Cell
- (FlowImageCell *)dequeueReusableCell;

@end



#pragma mark - FlowImageViewDelegate
@protocol FlowImageViewDelegate<NSObject>

@optional
/**
 设置每个Page的大小
 
 @param flowImageView 所调用的flowImageView
 @return 每个Page的大小
 */
- (CGSize)sizeForFlowView:(FlowImageView *)flowImageView;

/**
 点击Cell事件
 */
- (void)didSelectCell:(FlowImageCell *)cell withIndex:(NSInteger)index;

@end

#pragma mark - FlowImageViewDataSorce
@protocol FlowImageViewDataSorce<NSObject>

@required
/**
 cell的个数
 
 @param flowImageView 使用该方法的FlowImageView
 @return 该FlowImageView的页数
 */
- (NSInteger)numberOfFlowImageView:(FlowImageView *)flowImageView;

@optional
/**
 每个Cell的设置
 
 @param flowImageView 使用该方法的FlowImageView
 @param index 索引值
 @return 该索引值对应的Cell
 */
- (FlowImageCell *)flowView:(FlowImageView *)flowImageView cellInFlowViewWithIndex:(NSInteger)index;

@end








