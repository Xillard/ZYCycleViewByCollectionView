//
//  ZYCycleCell.m
//  ZYCycleViewByCollectionView
//
//  Created by  xiazhiyao on 2018/4/3.
//  Copyright © 2018年  xiazhiyao. All rights reserved.
//

#import "ZYCycleCell.h"

@implementation ZYCycleCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configImageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _imageView.frame = self.bounds;
}

- (void)configImageView {
    _imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_imageView];
}

@end
