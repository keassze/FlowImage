//
//  FlowImageView.m
//  FlowImage
//
//  Created by 何松泽 on 2018/11/2.
//  Copyright © 2018年 HSZ. All rights reserved.
//

#import "FlowImageView.h"

@interface FlowImageView()

@property (nonatomic, assign, readwrite) NSInteger currentPageIndex;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, assign) NSInteger orginPageCount;
@property (nonatomic, assign) CGSize pageSize;
@property (nonatomic, assign) NSRange visibleRange;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSMutableArray *cells;
@property (nonatomic, strong) NSMutableArray *reusableCells;

@end

@implementation FlowImageView

- (void)initConfig
{
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor whiteColor];
    
    self.pageCount = 0;
    self.isAutoScroll = YES;
    self.isForeverFlow = YES;
    self.currentPageIndex = 0;
    self.flowTime = 5.0;
    self.visibleRange = NSMakeRange(0, 0);
    
    self.reusableCells = [[NSMutableArray alloc] initWithCapacity:0];
    self.cells = [[NSMutableArray alloc] initWithCapacity:0];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.clipsToBounds = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    
    self.layout = [FlowImageViewLayout new];
    
    [self addSubview:self.scrollView];
}

#pragma mark - 重写父类方法
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initConfig];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initConfig];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initConfig];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame forLayout:(FlowImageViewLayout *)layout
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initConfig];
        self.layout = layout;
        self.pageSize = self.layout.itemSize;
    }
    return self;
}

- (FlowImageCell *)dequeueReusableCell
{
    FlowImageCell *cell = [_reusableCells lastObject];
    if (cell)
    {
        [_reusableCells removeLastObject];
    }
    
    return cell;
}

- (void)startTimer
{
    if (self.orginPageCount > 1 && self.isAutoScroll && self.isForeverFlow) {
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.flowTime target:self selector:@selector(autoFlowPage) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

- (void)stopTimer
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)reloadData
{
    for (UIView * tempView in self.scrollView.subviews) {
        if ([tempView isKindOfClass:[FlowImageCell class]] || [NSStringFromClass(tempView.class) isEqualToString:subViewClassName]) {
            [tempView removeFromSuperview];
        }
    }
    [self stopTimer];
    
    // 重置pageCount
    if (_dataSource && [_dataSource respondsToSelector:@selector(numberOfFlowImageView:)]) {
        
        self.orginPageCount = [_dataSource numberOfFlowImageView:self];
        
        if (_isForeverFlow) {
            _pageCount = self.orginPageCount == 1 ? 1: [_dataSource numberOfFlowImageView:self] * 3;
        }else {
            _pageCount = self.orginPageCount == 1 ? 1: [_dataSource numberOfFlowImageView:self];
        }
        
        if (_pageCount == 0) {
            return;
        }
        
    }
    
    // 防止用其他初始化方法时没有获取到Page的大小
    self.pageSize = self.layout.itemSize;
    
    [_reusableCells removeAllObjects];
    _visibleRange = NSMakeRange(0, 0);
    
    // 填充cells数组
    [_cells removeAllObjects];
    for (NSInteger index=0; index<_pageCount; index++)
    {
        [_cells addObject:[NSNull null]];
    }
    
    // 重置ContentSize
    CGPoint theCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    _scrollView.frame = CGRectMake(0, 0, _pageSize.width, _pageSize.height);
    _scrollView.contentSize = CGSizeMake(_pageSize.width * _pageCount,0);
    _scrollView.center = theCenter;
    
    if (self.isForeverFlow) {
        // 滚到第二组
        [_scrollView setContentOffset:CGPointMake(_pageSize.width * self.orginPageCount, 0) animated:NO];
        self.page = self.orginPageCount;
        
        // 启动自动轮播
        [self startTimer];
    }else {
        // 滚到开始
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        self.page = self.orginPageCount;
    }
    
    // 根据当前scrollView的offset设置cell
    [self setPagesAtContentOffset:_scrollView.contentOffset];
    
    // 更新可视cell
    [self refreshVisibleCell];
}

- (void)setPageAtIndex:(NSInteger)index
{
    FlowImageCell *cell = [_cells objectAtIndex:index];
    
    if ((NSObject *)cell == [NSNull null]) {
        cell = [_dataSource flowView:self cellInFlowViewWithIndex: index % _orginPageCount];
        [_cells replaceObjectAtIndex:index withObject:cell];
        
        cell.tag = index % _orginPageCount;
        
        __weak __typeof(self) weakSelf = self;
        cell.didSelectCellBlock = ^(NSInteger tag, FlowImageCell *cell) {
            [weakSelf singleCellTapAction:tag withCell:cell];
        };
    }
    
    if (!cell.superview) {
        [_scrollView addSubview:cell];
    }
}

- (void)refreshVisibleCell
{
    for (NSInteger i = _visibleRange.location; i < _visibleRange.location + _visibleRange.length; i++) {
        FlowImageCell *cell = [_cells objectAtIndex:i];
        [self.layout refreshVisibleCell:cell forIndex:i withScrollContentOffset:_scrollView.contentOffset];
    }
}

- (void)setPagesAtContentOffset:(CGPoint)offset
{
    // 计算visibleRange
    CGPoint startPoint = CGPointMake(offset.x - _scrollView.frame.origin.x, offset.y - _scrollView.frame.origin.y);
    CGPoint endPoint = CGPointMake(startPoint.x + self.bounds.size.width, startPoint.y + self.bounds.size.height);
    
    NSInteger startIndex = 0;
    for (int i =0; i < [_cells count]; i++) {
        // 计算在可视区域最前方cell的索引值
        if (_pageSize.width * (i +1) > startPoint.x) {
            startIndex = i;
            break;
        }
    }
    
    NSInteger endIndex = startIndex;
    for (NSInteger i = startIndex; i < [_cells count]; i++) {
        // 计算在可视区域最后方cell的索引值
        // 如果都不超过则取最后一个
        if ((_pageSize.width * (i + 1) < endPoint.x && _pageSize.width * (i + 2) >= endPoint.x) || i+ 2 == [_cells count]) {
            //i+2 是count，index = count - 1
            endIndex = i + 1;
            break;
        }
    }
    
    //可见页分别向前向后扩展一个，提高效率
    startIndex = MAX(startIndex - 1, 0);
    endIndex = MIN(endIndex + 1, [_cells count] - 1);
    
    self.visibleRange = NSMakeRange(startIndex, endIndex - startIndex + 1);
    for (NSInteger i = startIndex; i <= endIndex; i++) {
        [self setPageAtIndex:i];
    }
    
    for (int i = 0; i < startIndex; i ++) {
        [self removeCellAtIndex:i];
    }
    
    for (NSInteger i = endIndex + 1; i < [_cells count]; i ++) {
        [self removeCellAtIndex:i];
    }
}

#pragma mark --自动轮播
- (void)autoFlowPage
{
    self.page ++;
    
    [self.scrollView setContentOffset:CGPointMake(_page * _pageSize.width, 0) animated:YES];
}

- (void)removeCellAtIndex:(NSInteger)index
{
    FlowImageCell *cell = [self.cells objectAtIndex:index];
    
    if ((NSObject *)cell == [NSNull null]) {    //
        return;
    }
    
    [self.reusableCells addObject:cell];
    
    if (cell.superview) {
        [cell removeFromSuperview];
    }
    
    [_cells replaceObjectAtIndex:index withObject:[NSNull null]];
}

#pragma mark --ScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self startTimer];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (self.orginPageCount > 1 && self.isAutoScroll && self.isForeverFlow) {

        if (self.page == floor(_scrollView.contentOffset.x / _pageSize.width)) {
            self.page = floor(_scrollView.contentOffset.x / _pageSize.width) + 1;
        }else {
            self.page = floor(_scrollView.contentOffset.x / _pageSize.width);
        }
        
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.orginPageCount == 0) {
        return;
    }
    
    NSInteger pageIndex = (int)round(scrollView.contentOffset.x / _pageSize.width) % self.orginPageCount;
    if (_isForeverFlow) {
        
        if (self.orginPageCount > 1) {
            if (scrollView.contentOffset.x / _pageSize.width >= 2 * self.orginPageCount) {
                [scrollView setContentOffset:CGPointMake(_pageSize.width * self.orginPageCount, 0) animated:NO];
                self.page = self.orginPageCount;
            }
            
            if (scrollView.contentOffset.x / _pageSize.width <= self.orginPageCount - 1) {
                [scrollView setContentOffset:CGPointMake((2 * self.orginPageCount - 1) * _pageSize.width, 0) animated:NO];
                self.page = 2 * self.orginPageCount;
            }
            
        }else {
            pageIndex = 0;
        }
        
    }
    
    [self setPagesAtContentOffset:scrollView.contentOffset];
    [self refreshVisibleCell];
    
    _currentPageIndex = pageIndex;
}

//点击了cell
- (void)singleCellTapAction:(NSInteger)selectTag withCell:(FlowImageCell *)cell
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectCell:withIndex:)]) {
        [self.delegate didSelectCell:cell withIndex:selectTag];
    }
}


@end










