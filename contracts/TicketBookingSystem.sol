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
    TicketStructLib.TicketBooking[] private tickets;

    // ticketId -> TicketBooking
    mapping(uint => TicketStructLib.TicketBooking) public ticketBookingMap;

    // issuerAddress -> ticketId 
    mapping(address => uint) public issuerTicketMap;

    // ticketId -> customerAddress
    // ticketId is considered as Unique. i.e multiple shows wont share same ticketId
    mapping(uint => address) public ticketCustomerMap;

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function getOwner() public view returns(address){
        return owner;
    }

    modifier onlyTicketIssuer() {
       require(issuerMap[msg.sender].createdAt > 0 , "TicketIssuer doesnot exist in System");
        _;
    }

    function addATicketIssuer(string _issuerId, address _issuerAddress, string _issuerName) onlyOwner public  {
        require(TicketStructsLib.isANonEmptyString(_issuerId), "invalid issuerId");
        require(!doesIssuerExist(_issuerId), "A TicketIssuer is already created with this issuerId" )
        require(TicketStructsLib.isANonEmptyString(_issuerName), "invalid issuerName");
        TicketStructsLib.Issuer memory issuerObjectForPersistence;
        issuerObjectForPersistence = ClaimStructsLib.Issuer({
                                                        issuerId : _issuerId,
                                                        issuer: issuerAddress,
                                                        issuerName : _issuerName,
                                                        createdAt : block.timestamp,
                                                        updatedAt : 0});
        issuerMap[_issuerId] = issuerObjectForPersistence;
        issuers.push(issuerObjectForPersistence);
    }

    function doesIssuerExist(address _issuerAddress) public returns(bool){
        require(_issuerAddress, "issuerAddress is Invalid");
        return issuerMap[_issuerAddress].createdAt > 0;
    }

    function createAShow(
        string _showId,
        address _issuer,
        string _showName,
        uint _totalNumberOfTickets,
        uint256 _showPrice,
        uint256 _showTime,
        string _showTimeAsGMT
        ) onlyTicketIssuer public {
        require(TicketStructsLib.isANonEmptyString(_showId), "invalid showId");
        require(doesIssuerExist(_issuer), "Issuer doesnot exist" ;
        require(!doesShowExist(_showId), "A Show is already created with this showId" )
        require(TicketStructsLib.isANonEmptyString(_showName), "invalid showName");
        require(TicketStructsLib.isAValidInteger(_totalNumberOfTickets), "invalid totalNumberOfTickets");
        require(TicketStructsLib.isAValidInteger(_showPrice), "invalid showPrice");
        require(TicketStructsLib.isAValidInteger(_showTime), "invalid showTime");
        require(TicketStructsLib.isANonEmptyString(_showTimeAsGMT), "invalid showTimeAsGMT");
        TicketStructsLib.Show memory showObjectForPersistence;
        showObjectForPersistence = ClaimStructsLib.Show({
                                                        showId : _showId,
                                                        issuer: msg.sender,
                                                        showName : _showName,
                                                        totalNumberOfTickets: _totalNumberOfTickets,
                                                        availableTicketCount: _availableTicketCount,
                                                        showPrice : _showPrice,
                                                        showTime : _showTime,
                                                        showTimeAsGMT : _showTimeAsGMT,
                                                        createdAt : block.timestamp,
                                                        updatedAt : 0});
        showMap[_showId] = showObjectForPersistence;
        shows.push(showObjectForPersistence);
    }

    function doesShowExist(string memory showId) public returns(bool){
        require(showId, "showId is Invalid");
        return showMap[showId].createdAt > 0;
    }

    modifier onlyTicketCustomer(uint ticketId) {
        address customerAddress = ticketCustomerMap[ticketId];
        require(customerAddress == msg.sender, "message sender is not the ticket-holder");
        _;
    }

    //create a New TicketBooking & Add mapping for TicketBooking
    //Mark ticket as Locked
    function bookATicket(
        string ticketId,
        uint showId,
        address issuer,
        address customer,
        uint unlockDate) public {
        require(TicketStructsLib.isANonEmptyString(ticketId), "invalid ticketId");
        require(TicketStructsLib.isANonEmptyString(showId), "invalid showId");
        require(TicketStructsLib.isAValidAddress(issuer), "invalid issuer Address");
        require(TicketStructsLib.isAValidAddress(customer), "invalid customer Address");
        require(TicketStructsLib.isAValidInteger(unlockDate), "invalid unlockDate value");



    }

    function claimATicket(string ticketId) onlyTicketCustomer(msg.sender) public {
        require(TicketStructsLib.isANonEmptyString(ticketId), "invalid ticketId");
        _claimTicket(ticketId);
    }

    function _claimTicket(string ticketId, address customer) internal {
        require(doesTicketExist(ticketId), "invalid ticketId");
        require(TicketStructsLib.isAValidAddress(customer), "invalid customer Address");
        TicketStructsLib.TicketBooking storage ticketBookingObject = ticketBookingMap[ticketId];
        require(now >= ticketBookingObject.unlockDate);
        ticketBookingObject.isLocked = false;
        ticketBookingObject.isClaimed = true;
        ticketBookingObject.claimedAt = now;
    }

    function doesTicketExist(string ticketId) public returns(bool){
        require(TicketStructsLib.isANonEmptyString(ticketId), "invalid ticketId");
        return ticketBookingMap[ticketId].createdAt > 0;
    }

    function isTicketClaimed(string ticketId) public returns(bool){
        require(doesTicketExist(ticketId), "ticket doesnot exist");
        return ticketBookingMap[ticketId].isClaimed;
    }

    function isTicketLocked(string ticketId) public returns(bool){
        require(doesTicketExist(ticketId), "ticket doesnot exist");
        return ticketBookingMap[ticketId].isLocked;
    }

    function info() public view returns(address, uint) {
        return (owner, this.balance);
    }

}