pragma solidity >=0.4.21 <=0.6.10;
pragma experimental ABIEncoderV2;
import "./interfaces/TicketStructLib.sol";

contract TicketBookingSystem {

    address public owner;

    function TicketBookingSystem(
        address _owner
    ) public {
        owner = _owner;
    }

    //storage variables for Issuers
    TicketStructLib.Issuer[] public issuers;

    // issuerAddress -> Issuer
    mapping(address => TicketStructLib.Issuer) public issuerMap;

    //storage variables for shows

    TicketStructLib.Show[] public shows;

    // mapping for: showId -> Show
    mapping(string => TicketStructLib.Show) public showMap;

    //storage variables for ticket

    //array of Tickets
    TicketStructLib.Ticket[] private tickets;

    // ticketId -> Ticket
    mapping(uint => TicketStructLib.Ticket) public ticketMap;

    // issuerAddress -> ticketId 
    mapping(address => uint) public issuerTicketMap;

    // customerAddress -> ticketId
    // ticketId is considered as Unique. i.e multiple shows wont share same ticketId
    mapping(address => uint) public customerTicketMap;

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

    function addAnIssuer(address _issuer, string _issuerName) public onlyOwner {
        require(TicketStructsLib.isAValidAddress(_issuer), "invalid issuer issuer");
        require(TicketStructsLib.isANonEmptyString(_issuerName), "invalid issuerName");
        require(!issuers[_issuer].isActive, "Issuer already exists")
        issuerObject = TicketStructLib.Issuer({  issuer : _issuer,
                                                  issuerName : _issuerName, 
                                                  isActive : true,
                                                  creationTimeStamp : block.timestamp,
                                                  blockNumberAtCreation : block.number,
                                                  updationTimeStamp : 0,
                                                  blockNumberAtUpdate : 0});
        issuers.push(issuerObject);
        issuerMap[_issuer] = issuerObject;
    }

    function createAShow(address issuer,
        string showId,
        address issuer,
        string showName,
        string showTimeAsGMT,
        uint256 showPrice) public {
        require(TicketStructsLib.isANonEmptyString(showId), "invalid ticketId");
        require(TicketStructsLib.isAValidAddress(issuer), "invalid issuer Address");
        require(TicketStructsLib.isAValidAddress(customer), "invalid customer Address");
        require(TicketStructsLib.isANonEmptyString(showName), "invalid showName");
        require(TicketStructsLib.isAValidInteger(showTime), "invalid showTime");
        require(TicketStructsLib.isANonEmptyString(showTimeAsGMT), "invalid showTimeAsGMT");
        require(TicketStructsLib.isAValidInteger(showPrice), "invalid showPrice");



    }

    //create a New Ticket & Add mapping for Ticket
    //Mark ticket as Locked
    function bookATicket(
        address issuer,
        string ticketId,
        uint showId,
        address customer,
        uint lockedfor,
        uint lockedAt) public {
        require(TicketStructsLib.isAValidAddress(issuer), "invalid issuer Address");
        require(TicketStructsLib.isAValidAddress(customer), "invalid customer Address");
        require(TicketStructsLib.isANonEmptyString(ticketId), "invalid ticketId");
        require(TicketStructsLib.isANonEmptyString(showId), "invalid showId");
        require(TicketStructsLib.isAValidInteger(lockedfor), "lockedFor time should be positive value");
        require(TicketStructsLib.isAValidInteger(lockedAt), "invalid lockedAt value");



    }

    function info() public view returns(address, uint) {
        return (owner, this.balance);
    }

}