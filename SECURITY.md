Security Policy
===============

Supported Versions
------------------

The differences between versions are fairly small and the code
changes required to upgrade to the latest version tends to be
straight-forward.

If you do require a version outside of this chart updated with patch fix,
please contact me, otherwise I only plan to maintain the most recent
major version.

| Version | Supported          |
| ------- | ------------------ |
| 3.0.x   | :white_check_mark: |
| < 3.0   | :x:                |


Reporting a Vulnerability
-------------------------

If you identify a security vulnerability with this implementation, please
do not hesitate to contact github@ricmoo.com immediately.

I try to respond within the same day and will address any concern as
quickly as possible (including code fixes and publishing to NPM).

Any vulnerability will also be published to this file, along with credits,
pertinent information and links to fixes.


Notes
-----

The underlying scrypt algorithm has a
[known side-channel cache-timing attack](https://crypto.stanford.edu/cs359c/17sp/projects/MarkAnderson.pdf),
which cannot be addressed at the implementation level.

In many cases this is not a concern to most users and in a JavaScript context there are many other
side-channel attacks to be concerned with, but [here is an article](https://medium.com/analytics-vidhya/password-hashing-pbkdf2-scrypt-bcrypt-and-argon2-e25aaf41598e)
which may be useful for those considering between scrypt and Argon2 (its main "competitor").
