//
//  FlowImageCell.h
//  FlowImage
//
//  Created by 何松泽 on 2018/11/2.
//  Copyright © 2018年 HSZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlowImageCell : UIView

@property (nonatomic, strong) UIImageView *mainImageView;
@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *coverView;

@property (nonatomic, copy) void (^didSelectCellBlock)(NSInteger tag, FlowImageCell *cell);

// 设置子控件frame
- (void)setSubviewsWithSuperViewBounds:(CGRect)superViewBounds;

// 设置数据
- (void)setCellWithModel:(id)model;

@end






