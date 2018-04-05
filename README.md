# ZYCycleViewByCollectionView
前几天写了一篇使用UIScrollView实现轮播图,现在使用UICollectionView再次实现轮播图.

使用UICollectionView实现轮播图的原理和使用UIScrollView的大致相同,通过NSTimer间隔改变当前显示的item,根据当前UICollectionView的偏移量计算出当前的itemIndex,然后调用- (void)scrollToItemAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UICollectionViewScrollPosition)scrollPosition animated:(BOOL)animated;滑动至下一个itemIndex,当滑动到最后一个item时再从头开始.不同的是不需要像UIScrollView那样在首尾各添加一个尾首元素来实现无限循环的效果.使用UICollectionView只需将数据源的总数*一个比较大的数得到item总数,然后每次调UICollectionView的dataSource方法时,取当前的indexPath.item对数据源图片个数取余获取当前需要显示的图片.
