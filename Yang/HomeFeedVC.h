//
//  HomeFeedVC.h
//  Yang
//
//  Created by Biggie Smallz on 1/11/16.
//  Copyright © 2016 Mack Hasz. All rights reserved.
//

#import "FeedVC.h"
#import "UIScrollView+EmptyDataSet.h"

@interface HomeFeedVC : FeedVC <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@end

@interface SendKarmaNav : UINavigationController

@end
