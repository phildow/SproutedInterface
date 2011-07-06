//
//  ZipUtilities.h
//  SproutedUtilities
//
//  Created by Philip Dow on 8/21/07.
//  Copyright 2007 Sprouted. All rights reserved.
//	All inquiries should be directed to developer@journler.com
//

#import <Cocoa/Cocoa.h>


@interface ZipUtilities : NSObject {

}

+ (BOOL) zip:(NSString*)targetPath toFile:(NSString*)targetZip;
+ (BOOL) unzipPath:(NSString*)sourcePath toPath:(NSString*)destinationPath;

@end
