"use strict";

const assert = require("assert");

const scrypt = require('../scrypt.js');

const testVectors = require('./test-vectors.json');

for (let i = 0; i < testVectors.length; i++) {
    const test = testVectors[i];

    const password = new Buffer(test.password, 'hex');
    const salt = new Buffer(test.salt, 'hex');
    const N = test.N;
    const p = test.p;
    const r = test.r;
    const dkLen = test.dkLen;

    const derivedKeyHex = test.derivedKey;

    it("Test async " + String(i), function() {
      this.timeout(60000);

      return new Promise(function(resolve, reject) {
        scrypt(password, salt, N, r, p, dkLen, function(error, progress, key) {
            if (error) {
                console.log(error);
                assert.ok(false);
                reject(error);

            } else if (key) {
                assert.equal(derivedKeyHex, Buffer.from(key).toString('hex'), 'failed to match derived key');
                resolve();
            } else {
            }
        });
      });
    });
}

