//
//  LibraryViewController.h
//  CoreData_Async
//
//  Created by Guillaume CASTELLANA on 28/1/14.
//  Copyright (c) 2014 Guillaume CASTELLANA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BooksViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, retain) IBOutlet UISwitch* theSwitch;

@end
