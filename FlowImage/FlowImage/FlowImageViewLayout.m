//
//  FlowImageViewLayout.m
//  FlowImage
//
//  Created by 何松泽 on 2018/11/5.
//  Copyright © 2018年 HSZ. All rights reserved.
//

#import "FlowImageViewLayout.h"
#import "FlowImageCell.h"

static const CGFloat kBannerRatio = 0.58;

@implementation FlowImageViewLayout


- (instancetype)init
{
    self = [super init];
    if (self) {
        //默认值
        self.edgeInsetsMargin = UIEdgeInsetsMake(10, 15, 10, 15);
        self.alpha = 0.5f;
        self.itemSize = CGSizeMake(200, 200 *kBannerRatio);
    }
    return self;
}

// 刷新当前所看见的page的样式，在scrollViewDidScroll 以及 reloadData时都需要及时更新
- (void)refreshVisibleCell:(FlowImageCell *)cell forIndex:(NSInteger)index withScrollContentOffset:(CGPoint)contentOffset
{
    CGFloat offset = contentOffset.x;
    CGFloat origin = cell.frame.origin.x;
    CGFloat delta = fabs(origin - offset)/_itemSize.width;
    
    // 没有使用缩小效果情况下的Frame
    CGRect originCellFrame = CGRectMake(_itemSize.width * index, 0, _itemSize.width, _itemSize.height);
    
    // 根据cell位置，设置cell自身的样式
    if (delta < 1) {
        CGFloat leftInset  = _edgeInsetsMargin.left *delta;
        CGFloat rightInset = _edgeInsetsMargin.right *delta;
        CGFloat topInset   = _edgeInsetsMargin.top *delta;
        CGFloat bottomInset= _edgeInsetsMargin.bottom *delta;
        
        cell.coverView.alpha = delta*_alpha;
        cell.layer.transform = CATransform3DMakeScale((_itemSize.width - leftInset - rightInset)/_itemSize.width,(_itemSize.height - bottomInset - topInset)/_itemSize.height, 1.0);
        cell.frame = UIEdgeInsetsInsetRect(originCellFrame, UIEdgeInsetsMake(topInset, leftInset, bottomInset, rightInset));
    } else {
        cell.coverView.alpha = _alpha;
        cell.layer.transform = CATransform3DMakeScale((_itemSize.width - _edgeInsetsMargin.left - _edgeInsetsMargin.right)/_itemSize.width,(_itemSize.height - _edgeInsetsMargin.bottom - _edgeInsetsMargin.top)/_itemSize.height, 1.0);
        cell.frame = UIEdgeInsetsInsetRect(originCellFrame, _edgeInsetsMargin);
    }
    
    // 重设cell内容布局大小
    [cell setSubviewsWithSuperViewBounds:CGRectMake(0, 0, _itemSize.width, _itemSize.height)];
}


@end






