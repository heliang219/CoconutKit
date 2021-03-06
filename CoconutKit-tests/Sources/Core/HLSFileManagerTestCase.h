//
//  HLSFileManagerTestCase.h
//  CoconutKit-demo
//
//  Created by Samuel Défago on 21.10.13.
//  Copyright (c) 2014 Samuel Défago. All rights reserved.
//

@interface HLSFileManagerTestCase : XCTestCase

- (void)testCreationAndRemovalWithFileManager:(HLSFileManager *)fileManager;
- (void)testContentsAndExistenceWithFileManager:(HLSFileManager *)fileManager;
- (void)testCopyWithFileManager:(HLSFileManager *)fileManager;
- (void)testMoveWithFileManager:(HLSFileManager *)fileManager;
- (void)testStreamsWithFileManager:(HLSFileManager *)fileManager;
- (void)testURLsWithFileManager:(HLSFileManager *)fileManager;

@end
