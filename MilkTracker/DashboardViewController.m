//
//  DashboardViewController.m
//  MilkTracker
//
//  Created by Yi Qin on 6/3/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

#import "DashboardViewController.h"
#import "RWBarChartView.h"
#import <MilkTracker-Swift.h>

@interface DashboardViewController () <RWBarChartViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) NSDictionary *singleItems; // indexPath -> RWBarChartItem

@property (nonatomic, strong) NSArray *itemCounts;

@property (nonatomic, strong) RWBarChartView *singleChartView;

@property (nonatomic, strong) ScrollViewContainer *scrollViewController;

@property (nonatomic, strong) NSIndexPath *indexPathToScroll;

@end



@implementation DashboardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        
    }
    return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1]; //[UIColor blackColor];
    
    self.singleChartView = [RWBarChartView new];
    self.singleChartView.dataSource = self;
    self.singleChartView.barWidth = 15;
    
    self.singleChartView.alwaysBounceHorizontal = YES;
    self.singleChartView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];
    
    self.singleChartView.scrollViewDelegate = self;
    
    self.scrollViewController = [[ScrollViewContainer alloc] init];
    self.scrollViewController.scrollView = self.singleChartView;
    [self.scrollViewController addSubview:self.singleChartView];
    [self.view addSubview:self.scrollViewController];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.itemCounts = [[NSArray alloc] init];
    self.singleItems = [[NSDictionary alloc] init];
    
    
    // Load data...
    [ParseDataManager loadDataFromParse:0 completionClosure:^(BOOL success, BOOL hasMore, NSArray *objects) {
        
        NSMutableArray *itemCounts = [NSMutableArray array];
        NSMutableDictionary *singleItems = [NSMutableDictionary dictionary];
        
        
        [itemCounts addObject:@(objects.count)];
        
        
        for (NSInteger i = 0 ; i < objects.count; i++) {
            
            
            PFObject *object = [objects objectAtIndex:i];
            
            MilkData *milkData = [[MilkData alloc] initWithParseObject:object];

            NSInteger j = 0;
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:j];
            
            // signle-segment item
            CGFloat ratio = milkData.value/100.0;
            if (ratio > 1) {
                ratio = 1;
            }
            if (ratio == 0) {
                ratio = (CGFloat)(random() % 10) / 1000.0;
            }
            
            // ratio = (CGFloat)(random() % 1000) / 1000.0;
            
            UIColor *color = nil;
            if (ratio < 0.25)
            {
                color = [UIColor colorWithRed:0.5 green:0.5 blue:1.0 alpha:1.0];
            }
            else if (ratio < 0.5)
            {
                color = [UIColor colorWithRed:0.5 green:1.0 blue:0.5 alpha:1.0];
            }
            else if (ratio < 0.75)
            {
                color = [UIColor yellowColor];
            }
            else
            {
                color = [UIColor colorWithRed:1.0 green:0.5 blue:0.5 alpha:1.0];
            }
            
            RWBarChartItem *singleItem = [RWBarChartItem itemWithSingleSegmentOfRatio:ratio color:color];
            singleItem.text = [NSString stringWithFormat:@"Milk %ld-%ld: %0.2f", (long)indexPath.section, (long)indexPath.item, ratio];
            
            NSLog(@"%@", singleItem.text);
            
            singleItems[indexPath] = singleItem;
            
        }
            
        self.itemCounts = itemCounts;
        self.singleItems = singleItems;
        
        
        NSLog(@"%@", self.itemCounts);
        
        [self updateScrollButton];
        
        [self.singleChartView reloadData];
        
        // [self createChartWithData];
    }];
    
}


- (void)createChartWithData {
    NSMutableArray *itemCounts = [NSMutableArray array];
    NSMutableDictionary *singleItems = [NSMutableDictionary dictionary];
    
    // make sample values
    // section loop
    for (NSInteger isec = 0; isec < 1; ++isec)
    {
        NSInteger n = 10;
        [itemCounts addObject:@(n)];
        // row loop
        for (NSInteger irow = 0; irow < n; ++irow)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:irow inSection:isec];
            
            // signle-segment item
            {
                CGFloat ratio = (CGFloat)(random() % 1000) / 1000.0;
                UIColor *color = nil;
                if (ratio < 0.25)
                {
                    color = [UIColor colorWithRed:0.5 green:0.5 blue:1.0 alpha:1.0];
                }
                else if (ratio < 0.5)
                {
                    color = [UIColor colorWithRed:0.5 green:1.0 blue:0.5 alpha:1.0];
                }
                else if (ratio < 0.75)
                {
                    color = [UIColor yellowColor];
                }
                else
                {
                    color = [UIColor colorWithRed:1.0 green:0.5 blue:0.5 alpha:1.0];
                }
                
                RWBarChartItem *singleItem = [RWBarChartItem itemWithSingleSegmentOfRatio:ratio color:color];
                singleItem.text = [NSString stringWithFormat:@"Milk %ld-%ld: %0.2f", (long)indexPath.section, (long)indexPath.item, ratio];
                singleItems[indexPath] = singleItem;
                
                NSLog(@"%@", singleItem.text);
            }
        }
    }
    
    self.itemCounts = itemCounts;
    self.singleItems = singleItems;
    
    
    [self.singleChartView reloadData];
    [self updateScrollButton];
    
}


- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGFloat padding = 20;
    CGFloat height = (self.view.bounds.size.height - [self.topLayoutGuide length] - padding) / 2;
    CGRect rect = CGRectMake(0, [self.topLayoutGuide length], self.view.bounds.size.width, height);
    self.singleChartView.frame = rect;
    
    rect.origin.y = CGRectGetMaxY(rect) + padding;
    
    
    self.scrollViewController.frame = CGRectMake(0, [self.topLayoutGuide length], self.view.bounds.size.width, self.view.bounds.size.height - [self.topLayoutGuide length]);
}

- (NSInteger)numberOfSectionsInBarChartView:(RWBarChartView *)barChartView
{
    return self.itemCounts.count;
}

- (NSInteger)barChartView:(RWBarChartView *)barChartView numberOfBarsInSection:(NSInteger)section
{
    /*
    if (section == self.itemCounts.count - 1)
    {
        return 1;
    }
     */
    
    return [self.itemCounts[section] integerValue];
}

- (id<RWBarChartItemProtocol>)barChartView:(RWBarChartView *)barChartView barChartItemAtIndexPath:(NSIndexPath *)indexPath
{
    // NSDictionary *items = (barChartView == self.singleChartView ? self.singleItems : self.statItems);
    NSDictionary *items = self.singleItems;
    return items[indexPath];
}

- (NSString *)barChartView:(RWBarChartView *)barChartView titleForSection:(NSInteger)section
{
    NSString *prefix = (barChartView == self.singleChartView ? @"Section" : @"Section");
    return [prefix stringByAppendingFormat:@" %ld", (long)section];
}

- (BOOL)shouldShowItemTextForBarChartView:(RWBarChartView *)barChartView
{
    return YES; // barChartView == self.singleChartView;
}

- (BOOL)barChartView:(RWBarChartView *)barChartView shouldShowAxisAtRatios:(out NSArray *__autoreleasing *)axisRatios withLabels:(out NSArray *__autoreleasing *)axisLabels
{
    *axisRatios = @[@(0.25), @(0.50), @(0.75), @(1.0)];
    *axisLabels = @[@"25%", @"50%", @"75%", @"100%"];
    
    return YES;
}

// example of UIScrollView events handling
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"scrollViewDidEndDragging");
}

- (NSIndexPath *)indexPathToScroll
{
    if (!_indexPathToScroll)
    {
        NSInteger section = arc4random() % self.itemCounts.count;
        NSInteger item = arc4random() % [self.itemCounts[section] integerValue];
        _indexPathToScroll = [NSIndexPath indexPathForItem:item inSection:section];
    }
    return _indexPathToScroll;
}

- (void)updateScrollButton
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"Scroll To %ld-%ld", (long)self.indexPathToScroll.section, (long)self.indexPathToScroll.item] style:UIBarButtonItemStylePlain target:self action:@selector(scrollToBar)];
}

- (void)scrollToBar
{
    [self.singleChartView scrollToBarAtIndexPath:self.indexPathToScroll animated:YES];
    self.indexPathToScroll = nil;
    [self updateScrollButton];
}

@end
