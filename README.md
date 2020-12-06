# Ticket Booking -Smart Contracts

# Online Ticket Booking System

1. ticket issuers should be able to add new movies , Other shows with the price & date information for the show.
2. Ticket buyers should be able to book a movie/show based on its availability and date.
3. Ticket checkers at the venue should be able to verify the ticket online.

- Create a Time Locked Smart Contract on kovan network
- Contract allows the owner to lock a movie ticket for an user for a certain interval of time
- After the lock time, receiver can claim the ticket.

### Design Considerations:

- There should be a single smart contract where tickets are locked for every user
- Not a smart contract for each user.

### Functional Constrains:
- Claim Ticket operation will be done by the user only after the lock period is over.
- Make the claim operation native meta transaction enabled so claim operation can be done via meta transaction also.
