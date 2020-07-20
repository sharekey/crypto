//
//  NAChloride
//
//  Created by Gabriel on 1/16/14.
//  Copyright (c) 2015 Gabriel Handford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>

@import NAChloride;

#import "NATestUtils.h"

@interface NASecretBoxTest : XCTestCase
@end

@implementation NASecretBoxTest

- (void)testEncrypt {
  NSData *key = [NARandom randomSecureReadOnlyData:NASecretBoxKeySize];
  NSData *nonce = [NARandom randomData:NASecretBoxNonceSize];
  NSData *message = [@"This is a secret message" dataUsingEncoding:NSUTF8StringEncoding];
  
  NASecretBox *secretBox = [[NASecretBox alloc] init];
  secretBox.secureDataEnabled = YES;
  NSData *encryptedData = [secretBox encrypt:message nonce:nonce key:key error:nil];
  NSData *decryptedData = [secretBox decrypt:encryptedData nonce:nonce key:key error:nil];
  XCTAssertNotNil(decryptedData);
  XCTAssertTrue([message isEqualToData:decryptedData]);
  XCTAssertEqualObjects(message, decryptedData);
}

- (void)testEncryptBadKey {
  NSData *badKey = [NSData data];
  NSData *nonce = [NARandom randomData:NASecretBoxNonceSize];

  NSError *error = nil;
  NASecretBox *secretBox = [[NASecretBox alloc] init];
  NSData *encryptedData = [secretBox encrypt:[@"This is a secret" dataUsingEncoding:NSUTF8StringEncoding] nonce:nonce key:badKey error:&error];
  XCTAssertNil(encryptedData);
  XCTAssertNotNil(error);
  XCTAssertEqual(NAErrorCodeInvalidKey, error.code);
}

- (void)testEncryptBadNonce {
  NSData *key = [NARandom randomSecureReadOnlyData:NASecretBoxKeySize];
  NSData *nonce = [NARandom randomData:4];

  NSError *error = nil;
  NASecretBox *secretBox = [[NASecretBox alloc] init];
  NSData *encryptedData = [secretBox encrypt:[@"This is a secret" dataUsingEncoding:NSUTF8StringEncoding] nonce:nonce key:key error:&error];
  XCTAssertNil(encryptedData);
  XCTAssertNotNil(error);
  XCTAssertEqual(NAErrorCodeInvalidNonce, error.code);
}

- (void)testEncryptBadData {
  NSData *key = [NARandom randomSecureReadOnlyData:NASecretBoxKeySize];
  NSData *nonce = [NARandom randomData:NASecretBoxNonceSize];

  NSError *error = nil;
  NASecretBox *secretBox = [[NASecretBox alloc] init];
  NSData *encryptedData = [secretBox encrypt:nil nonce:nonce key:key error:&error];
  XCTAssertNil(encryptedData);
  XCTAssertNotNil(error);
  XCTAssertEqual(NAErrorCodeInvalidData, error.code);
}

- (void)testDecryptBadKey {
  NSData *key1 = [NARandom randomSecureReadOnlyData:NASecretBoxKeySize];
  NSData *key2 = [NARandom randomSecureReadOnlyData:NASecretBoxKeySize];
  XCTAssertNotEqual(key1, key2);
  NSData *nonce = [NARandom randomData:NASecretBoxNonceSize];

  NSError *error = nil;
  NASecretBox *secretBox = [[NASecretBox alloc] init];
  NSData *encryptedData = [secretBox encrypt:[@"This is a secret" dataUsingEncoding:NSUTF8StringEncoding] nonce:nonce key:key1 error:&error];
  XCTAssertNil(error);
  XCTAssertNotNil(encryptedData);

  NSData *decryptedData = [secretBox decrypt:encryptedData nonce:nonce key:key2 error:&error];
  XCTAssertNotNil(error);
  XCTAssertNil(decryptedData);
  XCTAssertEqual(NAErrorCodeVerificationFailed, error.code);
}

- (void)testDecryptBadNonce {
  NSData *key = [NARandom randomSecureReadOnlyData:NASecretBoxKeySize];
  NSData *nonce1 = [NARandom randomData:NASecretBoxNonceSize];
  NSData *nonce2 = [NARandom randomData:NASecretBoxNonceSize];
  XCTAssertNotEqual(nonce1, nonce2);

  NSError *error = nil;
  NASecretBox *secretBox = [[NASecretBox alloc] init];
  NSData *encryptedData = [secretBox encrypt:[@"This is a secret" dataUsingEncoding:NSUTF8StringEncoding] nonce:nonce1 key:key error:&error];
  XCTAssertNil(error);
  XCTAssertNotNil(encryptedData);

  NSData *decryptedData = [secretBox decrypt:encryptedData nonce:nonce2 key:key error:&error];
  XCTAssertNotNil(error);
  XCTAssertNil(decryptedData);
  XCTAssertEqual(NAErrorCodeVerificationFailed, error.code);
}

@end
