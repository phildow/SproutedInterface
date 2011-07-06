//
//  PDTableView.h
//  SproutedInterface
//
//  Created by Philip Dow on 2/1/07.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <Cocoa/Cocoa.h>


@interface PDTableView : NSTableView {

}

@end


@interface NSObject (PDTableViewDelegate)

- (void) tableView:(NSTableView*)aTableView leftNavigationEvent:(NSEvent*)anEvent;
- (void) tableView:(NSTableView*)aTableView rightNavigationEvent:(NSEvent*)anEvent;

@end