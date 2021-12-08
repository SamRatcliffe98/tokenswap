This smart contract was created for an assignment, according to the following brief:

First, assume two contracts, C1 and C2, that manage a token. The API of each contract is the same
as defined in Assignment #3; therefore, for example, to create C1 and C2 you can simply deploy two
instances of the contract that you have written for Assignment #3.

Next, assume a user A, who owns at least x tokens on contract C1, and user B, who owns at least y
tokens on contract C2. You should write a new smart contract that implements a special type of fair
swap of tokens between A and B. Specifically, your contract should ensure that, during the swap,
either both user A receives y tokens on C2 and user B receives x tokens on C1, or neither the
balance of A on C1 nor the balance of B on C2 are reduced. Note that the contract should perform a
swap between exactly x C1 tokens and y C2 tokens, regardless of price changes in each token
contract before, during, or after the swap.

Your contract should be as fair and secure as possible; any design choices that diverge on either
property should be clearly justified. You may assume that the contract implements only one fair
swap at a time.

Additionally, a report of the security considerations and gas costs/fairness was required.
