//
//  FlowImageView.h
//  FlowImage
//
//  Created by 何松泽 on 2018/11/2.
//  Copyright © 2018年 HSZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlowImageCell.h"
#import "FlowImageViewLayout.h"

static NSString *subViewClassName = @"FlowImageCell";

@class FlowImageViewLayout;
@protocol FlowImageViewDataSorce;
@protocol FlowImageViewDelegate;

@interface FlowImageView : UIView<UIScrollViewDelegate>

/// 布局

/** 布局 */
@property (nonatomic, strong) FlowImageViewLayout *layout;
/** 是否自动滚动 默认是 */
@property (nonatomic, assign) BOOL isAutoScroll;
/** 是否无限次滚动 默认是 */
@property (nonatomic, assign) BOOL isForeverFlow;
/** 滚动时间间隔 默认5s */
@property (nonatomic, assign) CGFloat flowTime;
/** 当前页的索引值 只读 */
@property (nonatomic, assign, readonly) NSInteger currentPageIndex;
/** 代理 */
@property (nonatomic, weak) id <FlowImageViewDelegate>delegate;
@property (nonatomic, weak) id <FlowImageViewDataSorce>dataSource;

/**
 建议使用的初始化方法

 @param frame frame
 @param layout 布局
 @return self
 */
- (instancetype)initWithFrame:(CGRect)frame forLayout:(FlowImageViewLayout *)layout;

/**
 刷新数据以及样式
 */
- (void)reloadData;

/**
 获取可重复使用的Cell

 @return 可重复使用的cell
 */
- (FlowImageCell *)dequeueReusableCell;

@end



#pragma mark - FlowImageViewDelegate
@protocol FlowImageViewDelegate<NSObject>

@optional
///**
// 设置每个Page的大小
// 
// @param flowImageView 所调用的flowImageView
// @return 每个Page的大小
// */
//- (CGSize)sizeForFlowView:(FlowImageView *)flowImageView;

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
/** */
- (FlowImageCell *)flowView:(FlowImageView *)flowImageView cellInFlowViewWithIndex:(NSInteger)index;

@end








