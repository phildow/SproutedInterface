//
//  IntegrationCopyFiles.h
//  SproutedInterface
//
//  Created by Philip Dow on xx.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <Cocoa/Cocoa.h>

@interface IntegrationCopyFiles : NSWindowController
{
	IBOutlet NSObjectController *controller;
	IBOutlet NSProgressIndicator *progress;
	
	NSString *noticeText;
}

- (NSString*)noticeText;
- (void) setNoticeText:(NSString*)aString;

- (void) runNotice;
- (void) endNotice;

@end
