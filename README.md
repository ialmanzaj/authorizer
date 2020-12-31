# Authorizer

1. Read streaming incoming data: account or transactions from stdin
2. Validate incoming data: it can be valid, invalid or absent at all.
3. Depending on which data is execute: a. create an account or b. authorize transaction.
4. When creating an account: run verification account creation rules.
5. Return an output with the account created and violations.
6. When authorizing a transaction: run verification transaction and account rules.
7. Return an output with the account created and violations.
