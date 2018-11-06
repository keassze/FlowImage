//
//  FlowImageViewLayout.m
//  FlowImage
//
//  Created by 何松泽 on 2018/11/5.
//  Copyright © 2018年 HSZ. All rights reserved.
//

#import "FlowImageViewLayout.h"
//#import "FlowImageView.h"
//#import "FlowImageCell.h"
//
//@interface FlowImageViewLayout()
//
//@property (nonatomic, strong) FlowImageView *flowImageView;
//
//@end

@implementation FlowImageViewLayout


//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        self.leftRightMargin = 20;
//        self.topBottomMargin = 30;
//    }
//    return self;
//}
//
//- (void)setLeftRightMargin:(CGFloat)leftRightMargin
//{
//    _leftRightMargin = leftRightMargin * 0.5;
//    
//}
//
//- (void)setTopBottomMargin:(CGFloat)topBottomMargin
//{
//    _topBottomMargin = topBottomMargin * 0.5;
//}
//
//- (void)refreshVisibleCell
//{
//    CGFloat offset = _flowImageView.scrollView.contentOffset.x;
//    
//    for (NSInteger i = _flowImageView.visibleRange.location; i < _flowImageView.visibleRange.location + _flowImageView.visibleRange.length; i++) {
//        FlowImageCell *cell = [_cells objectAtIndex:i];
//        CGFloat origin = cell.frame.origin.x;
//        CGFloat delta = fabs(origin - offset);
//        CGFloat alpha = 0.5f;
//        
//        CGRect originCellFrame = CGRectMake(_pageSize.width * i, 0, _pageSize.width, _pageSize.height);//如果没有缩小效果的情况下的本该的Frame
//        
//        if (delta < _pageSize.width) {
//            
//            cell.coverView.alpha = (delta / _pageSize.width)*alpha;
//            
//            CGFloat leftRightInset = _leftRightMargin * delta / _pageSize.width;
//            CGFloat topBottomInset = _topBottomMargin * delta / _pageSize.width;
//            
//            cell.layer.transform = CATransform3DMakeScale((_pageSize.width-leftRightInset*2)/_pageSize.width,(_pageSize.height-topBottomInset*2)/_pageSize.height, 1.0);
//            cell.frame = UIEdgeInsetsInsetRect(originCellFrame, UIEdgeInsetsMake(topBottomInset, leftRightInset, topBottomInset, leftRightInset));
//            
//            
//        } else {
//            cell.coverView.alpha = alpha;
//            cell.layer.transform = CATransform3DMakeScale((_pageSize.width-self.leftRightMargin*2)/_pageSize.width,(_pageSize.height-self.topBottomMargin*2)/_pageSize.height, 1.0);
//            cell.frame = UIEdgeInsetsInsetRect(originCellFrame, UIEdgeInsetsMake(_topBottomMargin, _leftRightMargin, _topBottomMargin, _leftRightMargin));
//            
//        }
//    }
//}

@end






