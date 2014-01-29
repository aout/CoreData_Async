//
//  Book.m
//  CoreData_Async
//
//  Created by Guillaume CASTELLANA on 28/1/14.
//  Copyright (c) 2014 Guillaume CASTELLANA. All rights reserved.
//

#import "Book.h"
#import "Page.h"
#import "Bookshelf.h"


@implementation Book

@dynamic title;
@dynamic domain;
@dynamic pages;
@dynamic bookshelf;

- (void) configure
{
    // Create the title
    {
        int len = 40;
        NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
        for (int i=0; i<len; i++) {
            [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
        }
        [self setTitle:randomString];
    }
    
    // Create the domain
    {
        int len = 3;
        NSString *letters = @"ab";
        NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
        for (int i=0; i<len; i++) {
            [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
        }
        [self setDomain:randomString];
    }
    
    // Create Bookshelf
    {
        Bookshelf* bs = [Bookshelf findFirstByAttribute:@"domain" withValue:self.domain inContext:[NSManagedObjectContext defaultContext]];
        if (bs) {
            bs = [bs inContext:self.managedObjectContext];
        } else {
            bs = [Bookshelf createInContext:self.managedObjectContext];
            [bs setDomain:self.domain];
        }
        [self setBookshelf:bs];
    }
}

@end
