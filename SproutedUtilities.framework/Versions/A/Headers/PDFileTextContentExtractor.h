//
//  PDTextContentExtractor.h
//  SproutedUtilities
//
//  Created by Philip Dow on 5/10/07.
//  Copyright Sprouted. All rights reserved.
//	All inquiries should be directed to developer@journler.com
//

#import <Cocoa/Cocoa.h>


@interface PDFileTextContentExtractor : NSObject {
	
	NSURL *url;
}

- (id) initWithURL:(NSURL*)aURL;
- (id) initWithFile:(NSString*)aPath;

- (NSString*) content;

@end
