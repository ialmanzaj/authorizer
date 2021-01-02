# Authorizer

1. Read streaming incoming data: account or transactions from stdin
2. Parse data from input
3. Validate incoming data: it can be valid, invalid or absent at all.
4. Depending on which data is execute: a. create an account or b. authorize transaction.
5. When creating an account: run validations account creation rules.
6. Return an output with the account created and violations.
7. When authorizing a transaction: run validations transaction and account rules.
8. Return an output with the account created and violations.

# Code design choices
