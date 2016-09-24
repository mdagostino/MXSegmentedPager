// MXParallaxViewController.m
//
// Copyright (c) 2015 Maxime Epain
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "MXParallaxViewController.h"
#import "MXSegmentedPager.h"
#import "MXRefreshHeaderView.h"
#import "MXCustomView.h"

@interface MXParallaxViewController () <MXSegmentedPagerDelegate, MXSegmentedPagerDataSource, UIPageViewControllerDelegate,UIPageViewControllerDataSource>
@property (nonatomic, strong) MXRefreshHeaderView * cover;
@property (nonatomic, strong) MXSegmentedPager  * segmentedPager;
@property (nonatomic, strong) UITableView       * tableView;
@property (nonatomic, strong) UIWebView         * webView;
@property (nonatomic, strong) UITextView        * textView;
@property (nonatomic, strong) MXCustomView      * customView;
@end

@implementation MXParallaxViewController {
    
    UIPageViewController* pageViewController;
    NSArray* viewControllers;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self loadPageViewController];

    [self.view addSubview:self.segmentedPager];
    
    // Parallax Header
    self.segmentedPager.parallaxHeader.view = self.cover;
    self.segmentedPager.parallaxHeader.mode = MXParallaxHeaderModeFill;
    self.segmentedPager.parallaxHeader.height = 250;
    self.segmentedPager.parallaxHeader.minimumHeight = 64 + 44;
    
    // Segmented Control customization
    self.segmentedPager.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentedPager.segmentedControl.backgroundColor = [UIColor clearColor];
    self.segmentedPager.segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor blackColor]};
    self.segmentedPager.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor orangeColor]};
    self.segmentedPager.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    self.segmentedPager.segmentedControl.selectionIndicatorColor = [UIColor orangeColor];
    self.segmentedPager.segmentedControlPosition = MXSegmentedControlPositionTopOver;
    self.segmentedPager.segmentedControlEdgeInsets = UIEdgeInsetsMake(12, 12, 12, 12);
    
}

- (void) loadPageViewController {
    
    UITableViewController* tableViewController = [[UITableViewController alloc] init];
    tableViewController.view.backgroundColor = [UIColor redColor];
    tableViewController.title = @"ViewController 1";
    
    UITableViewController* tableViewController2 = [[UITableViewController alloc] init];
    tableViewController2.view.backgroundColor = [UIColor redColor];
    tableViewController2.title = @"ViewController 2";

    UITableViewController* tableViewController3 = [[UITableViewController alloc] init];
    tableViewController3.view.backgroundColor = [UIColor redColor];
    tableViewController3.title = @"ViewController 3";
    
    UITableViewController* tableViewController4 = [[UITableViewController alloc] init];
    tableViewController4.view.backgroundColor = [UIColor redColor];
    tableViewController4.title = @"ViewController 4";

    viewControllers = @[tableViewController,tableViewController2,tableViewController3,tableViewController4];
    
    pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    pageViewController.delegate = self;
    pageViewController.dataSource = self;

    NSArray *initControllers = @[tableViewController];
    [pageViewController setViewControllers:initControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];

    [self addChildViewController:pageViewController];
    
    // Set a segmented pager below the cover
    _segmentedPager = [[MXSegmentedPager alloc] initWithPagerView:pageViewController.view];
    _segmentedPager.delegate    = self;
    _segmentedPager.dataSource  = self;

//    [self.view addSubview:pageViewController.view];
    pageViewController.view.backgroundColor = [UIColor orangeColor];
    
    [pageViewController didMoveToParentViewController:self];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger index = [viewControllers indexOfObject:viewController];
    if (index == 0 ){
        return nil;
    }
    return [viewControllers objectAtIndex:index-1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger index = [viewControllers indexOfObject:viewController];
    if (index == [viewControllers count] - 1 ){
        return nil;
    }
    return [viewControllers objectAtIndex:index+1];
}

- (void)pageViewController:(UIPageViewController *)_pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    NSInteger index = [viewControllers indexOfObject:pageViewController.viewControllers[0]];
    [self.segmentedPager.segmentedControl setSelectedSegmentIndex:index animated:YES];
}

- (void)segmentedPager:(MXSegmentedPager *)segmentedPager showPageAtIndex:(NSInteger)index reverse:(BOOL)reverse {
    UIPageViewControllerNavigationDirection direction = (reverse)?UIPageViewControllerNavigationDirectionReverse:UIPageViewControllerNavigationDirectionForward;
    [pageViewController setViewControllers:@[viewControllers[index]] direction:direction animated:YES completion:^(BOOL finished) {
        
    }];
}


- (void)viewWillLayoutSubviews {
    self.segmentedPager.frame = (CGRect){
        .origin = CGPointZero,
        .size   = self.view.frame.size
    };
    [super viewWillLayoutSubviews];
}

#pragma mark Properties

- (MXRefreshHeaderView *)cover {
    if (!_cover) {
        // Set a cover on the top of the view
        _cover = [MXRefreshHeaderView instantiateFromNib];
    }
    return _cover;
}

#pragma mark <MXSegmentedPagerDelegate>

- (CGFloat)heightForSegmentedControlInSegmentedPager:(MXSegmentedPager *)segmentedPager {
    return 30.f;
}

- (void)segmentedPager:(MXSegmentedPager *)segmentedPager didSelectViewWithTitle:(NSString *)title {

}

#pragma mark <MXSegmentedPagerDataSource>

- (NSInteger)numberOfPagesInSegmentedPager:(MXSegmentedPager *)segmentedPager {
    return [viewControllers count];
}

- (NSString *)segmentedPager:(MXSegmentedPager *)segmentedPager titleForSectionAtIndex:(NSInteger)index {
    NSString* title = [viewControllers[index] title];
    if (!title){
        title = @"";
    }
    return title;
}

@end
