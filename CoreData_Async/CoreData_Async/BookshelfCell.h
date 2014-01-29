//
//  BookshelfCell.h
//  CoreData_Async
//
//  Created by Guillaume CASTELLANA on 29/1/14.
//  Copyright (c) 2014 Guillaume CASTELLANA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bookshelf.h"

@interface BookshelfCell : UITableViewCell

- (void) configureWithBookshelf:(Bookshelf*)aBookshelf;

@end
