//
//  ZYCycleView.m
//  ZYCycleViewByCollectionView
//
//  Created by  xiazhiyao on 2018/4/3.
//  Copyright © 2018年  xiazhiyao. All rights reserved.
//

#import "ZYCycleView.h"
#import "ZYCycleCell.h"

NSString *const cellID = @"ZYCycleCell";

@interface ZYCycleView()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *ZYCollectionView;//轮播collectionView

@property (nonatomic,strong) UIPageControl *ZYPageControl;//分页控件

@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,assign) CGRect cycyleFrame;//collectionViewFrame

@property (nonatomic,assign) NSInteger totalItem;//总共Item数,数据源*100所得

@end

@implementation ZYCycleView

- (instancetype)initWithFrame:(CGRect)frame withImageArr:(NSArray *)imageArr {
    self = [super initWithFrame:frame];
    if (self) {
        _cycyleFrame = frame;
        _imageArr = imageArr;
        [self initData];//初始化默认值
        [self configCollectionView];//配置collectionView
        [self configPageControl];//配置分页控件
    }
    return self;
}

/*初始化*/
+ (instancetype)initWithFrameCycleViewFrame:(CGRect)frame imageArray:(NSArray *)imageArr {
    ZYCycleView *cycleView = [[self alloc] initWithFrame:frame withImageArr:imageArr];
    [cycleView createTimer];
    return cycleView;
}

/*初始化默认属性值*/
- (void)initData {
    _scrollTimeInterval = 2.0;
    _isShowPageControl = YES;
    _currentPageDotColor = [UIColor whiteColor];
    _pageDotColor = [UIColor lightGrayColor];
    _imageViewContentMode = UIViewContentModeScaleToFill;
    _totalItem = _imageArr.count * 100;
}

/*配置collectionView*/
- (void)configCollectionView {
    [self addSubview:self.ZYCollectionView];
}

/*配置分页控件*/
- (void)configPageControl {
    [self addSubview:self.ZYPageControl];
}

#pragma mark - UICollectionViewDataSource&UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _totalItem;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZYCycleCell *cycleCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    /*indexPath.item对数组的总数取余数得到当前需要显示的图片*/
    NSInteger currentIndex = indexPath.item % _imageArr.count;
    cycleCell.imageView.image = [UIImage imageNamed:_imageArr[currentIndex]];
    cycleCell.imageView.contentMode = _imageViewContentMode;
    return cycleCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.backIndexBlock) {
        self.backIndexBlock(indexPath.item % _imageArr.count);
    }
    if ([self.delegate respondsToSelector:@selector(cycleView:didSelectImageAtIndex:)]) {
        [self.delegate cycleView:self didSelectImageAtIndex:indexPath.item % _imageArr.count];
    }
}

#pragma mark - 循环timer
- (void)createTimer {
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:_scrollTimeInterval target:self selector:@selector(cyclePictures:) userInfo:nil repeats:YES];
    }
}

- (void)removeTimer {
    [self.timer invalidate];
    _timer = nil;
}

- (void)cyclePictures:(NSTimer *)timer {
    /*每隔scrollTimeInterval获取当期的位置,然后调用UICollectionView方法滚动至下一个位置,当滚动至最后一个Item时从图片数据源最后一张图片重新开始*/
    NSInteger currentIndex = _ZYCollectionView.contentOffset.x / CGRectGetWidth(self.bounds);
    NSInteger nextIndex = currentIndex + 1;
    if (nextIndex == _totalItem) {
        nextIndex = _imageArr.count - 1;
        [_ZYCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:nextIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        _ZYPageControl.currentPage = nextIndex;
        return;
    }
    [_ZYCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:nextIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    _ZYPageControl.currentPage = nextIndex % _imageArr.count;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self createTimer];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self removeTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    /*滑动到1/2宽时,获取下一个的位置,改变pagecontrol的currentpage未下一个位置,如果等全部滑动完全改变pagecontrol位和collectionView的切换不协调*/
    NSInteger nextIndex = (scrollView.contentOffset.x + CGRectGetWidth(self.bounds)/2)/CGRectGetWidth(self.bounds);
    _ZYPageControl.currentPage = nextIndex % _imageArr.count;
}

#pragma mark - 懒加载
- (UICollectionView *)ZYCollectionView {
    if (!_ZYCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.itemSize = self.frame.size;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _ZYCollectionView = [[UICollectionView alloc] initWithFrame:_cycyleFrame collectionViewLayout:layout];
        _ZYCollectionView.pagingEnabled = YES;
        _ZYCollectionView.showsHorizontalScrollIndicator = NO;
        _ZYCollectionView.delegate = self;
        _ZYCollectionView.dataSource = self;
        [_ZYCollectionView registerClass:[ZYCycleCell class] forCellWithReuseIdentifier:cellID];
    }
    return _ZYCollectionView;
}

- (UIPageControl *)ZYPageControl {
    if (!_ZYPageControl) {
        _ZYPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.origin.y + self.frame.size.height - 40, CGRectGetWidth(self.bounds), 40)];
        _ZYPageControl.numberOfPages = _imageArr.count;
        _ZYPageControl.pageIndicatorTintColor = _pageDotColor;
        _ZYPageControl.currentPageIndicatorTintColor = _currentPageDotColor;
    }
    return _ZYPageControl;
}

#pragma mark - Setter
- (void)setImageViewContentMode:(UIViewContentMode)imageViewContentMode {
    _imageViewContentMode = imageViewContentMode;
    [_ZYCollectionView reloadData];
}

- (void)setIsShowPageControl:(BOOL)isShowPageControl {
    _isShowPageControl = isShowPageControl;
    _ZYPageControl.hidden = !_isShowPageControl;
}

- (void)setScrollTimeInterval:(CGFloat)scrollTimeInterval {
    _scrollTimeInterval = scrollTimeInterval;
    [self removeTimer];
    [self createTimer];
}

- (void)setPageControlFrame:(CGRect)pageControlFrame {
    _pageControlFrame = pageControlFrame;
    _ZYPageControl.frame = _pageControlFrame;
}

- (void)setPageDotColor:(UIColor *)pageDotColor {
    _pageDotColor = pageDotColor;
    _ZYPageControl.pageIndicatorTintColor = _pageDotColor;
}

- (void)setCurrentPageDotColor:(UIColor *)currentPageDotColor {
    _currentPageDotColor = currentPageDotColor;
    _ZYPageControl.currentPageIndicatorTintColor = _currentPageDotColor;
}


@end
