//
//  LibraryViewController.m
//  CoreData_Async
//
//  Created by Guillaume CASTELLANA on 28/1/14.
//  Copyright (c) 2014 Guillaume CASTELLANA. All rights reserved.
//

#import "BooksViewController.h"
#import "Book.h"
#import "Bookshelf.h"
#import "Page.h"
#import "BookCell.h"

@interface BooksViewController ()

@property (nonatomic, strong) NSFetchedResultsController* fetchedResultsController;

@end

@implementation BooksViewController

static NSNumber* isRunning;

+(void)initialize
{
    isRunning = [NSNumber numberWithBool:NO];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self configureFetchedResultsController];
    //[self.tableView registerClass:[BookCell class] forCellReuseIdentifier:@"BookCell"];
}

- (void) viewDidAppear:(BOOL)animated
{
    @synchronized(isRunning) {
        [self.theSwitch setOn:[isRunning boolValue] animated:animated];
    }
}

- (void) configureFetchedResultsController {
    self.fetchedResultsController = [Book MR_fetchAllGroupedBy:Nil
                                                 withPredicate:Nil
                                                      sortedBy:@"title"
                                                     ascending:YES
                                                      delegate:self];
}

-(IBAction)createObjects:(id)sender
{
    @synchronized(isRunning) {
        isRunning = [NSNumber numberWithBool:![isRunning boolValue]];
    }
    [self performSelectorInBackground:@selector(createBookShelves) withObject:Nil];
    [self performSelectorInBackground:@selector(createBooks) withObject:Nil];
    [self performSelectorInBackground:@selector(createPages) withObject:Nil];
}

- (void) createBookShelves
{
    while ([isRunning boolValue]) {
        usleep(1000000); // 1 per sec
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            Bookshelf* bs = [Book createInContext:localContext];
            [bs configure];
        }];
    }
}

- (void) createBooks
{
    while ([isRunning boolValue]) {
        usleep(100000); // 10 per sec
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            Book* b = [Book createInContext:localContext];
            [b configure];
        }];
    }
}

- (void) createPages
{
    // Wait for some books to be created first
    sleep(2);
    while ([isRunning boolValue]) {
        usleep(10000); // 100 per sec
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            Page* p = [Page createInContext:localContext];
            [p configure];
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.fetchedResultsController.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id  sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BookCell";
    BookCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Book* b = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell configureWithBook:b];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new]; // Hacky way to prevent extra dividers after the end of the table from showing
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN; // Hacky way to prevent extra dividers after the end of the table from showing
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [tableView cellForRowAtIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray
                                               arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray
                                               arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id )sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.tableView endUpdates];
}

@end
