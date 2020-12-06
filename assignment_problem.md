# Online Ticket Booking System

- Design an online ticket booking system using Blockchain where:

## Task 1 : Design Task

1. ticket issuers should be able to add new movies , Other shows with the price & date information for the show.
2. Ticket buyers should be able to book a movie/show based on its availability and date.
3. Ticket checkers at the venue should be able to verify the ticket online.

### Design Considerations:

- Design should be modular, extensible
- Decide what information would you store on-chain and what would you store off-chain and why?
- Solution should include smart contracts design (schema)
- Solution should include the design for different modules of the backend system
- How modules interact with each other
- Database schema to be used to store off-chain information and why you chose that database.

## Task 2 : Smart Contract Task

- Create a Time Locked Smart Contract on kovan network
- Contract allows the owner to lock a movie ticket for an user for a certain interval of time
- After the lock time, receiver can claim the ticket.

### Design Considerations:

- There should be a single smart contract where tickets are locked for every user
- Not a smart contract for each user.

### Functional Constrains:
- Claim Ticket operation will be done by the user only after the lock period is over.
- Make the claim operation native meta transaction enabled so claim operation can be done via meta transaction also.

## Integration Test Mechanism:
For interacting with the smart contract you can create a simple UI or use remix or oneclickdapp.com


## Resources for help

https://web3js.readthedocs.io/

https://solidity.readthedocs.io/en/v0.6.0/

https://remix.ethereum.org/

http://oneclickdapp.com/