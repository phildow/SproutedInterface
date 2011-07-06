//
//  SproutedAboutBoxController.h
//  SproutedInterface
//
//  Created by Philip Dow on xx.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//


#import <Cocoa/Cocoa.h>

@interface SproutedAboutBoxController : NSWindowController
{
    IBOutlet NSTextView			*additionalText;
    IBOutlet NSTextField		*appnameField;
    IBOutlet NSImageView		*imageView;
    IBOutlet NSTextField		*versionField;
	IBOutlet NSTextView			*aboutText;
}

+ (id)sharedController;

@end
