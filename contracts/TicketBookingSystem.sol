pragma solidity >=0.4.21 <=0.6.10;


contract TicketBookingSystem {

    address public owner;

    function TicketBookingSystem(
        address _owner
    ) public {
        owner = _owner;
    }

    // ticketId -> Ticket
    mapping(uint => Ticket) public ticketMap;

    // issuerAddress -> ticketId 
    mapping(address => uint) public issuerTicketMap;

    // customerAddress -> ticketId
    mapping(address => uint) public customerTicketMap;

    Ticket[] private tickets;

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    modifier onlyTicketIssuer(address ticketIssuer) {
        require(msg.sender == ticketIssuer);
        _;
    }

    modifier onlyTicketCustomer(address ticketCustomer) {
        require(msg.sender == ticketCustomer);
        _;
    }

    function addAnIssuer(address issuer) public onlyOwner {



    }

    function createAShow(address issuer,
        uint showId,
        address issuer,
        string showName,
         uint showTime,
        string showTimeAsGMT,
        uint showPrice) public {



    }

    //create a New Ticket & Add mapping for Ticket
    //Mark ticket as Locked
    function lockATicket(
        address issuer,
        uint ticketId,
        uint showId,
        address customer,
        uint lockedfor,
        uint lockedAt) public   {
        require(ClaimStructsLib.isAValidAddress(subject),'cannot check existence of invalid address');

    }

    function info() public view returns(address, uint) {
        return (owner, this.balance);
    }

}