//
//  AppleScriptAlert.h
//  SproutedInterface
//
//  Created by Philip Dow on xx.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <Cocoa/Cocoa.h>

@interface AppleScriptAlert : NSWindowController
{
    IBOutlet NSTextView *errorView;
    IBOutlet NSTextView *sourceView;
	
	id source;
	id error;
}

- (id) initWithSource:(id)source error:(id)error;

@end
