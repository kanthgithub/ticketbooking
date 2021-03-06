pragma solidity >=0.4.21 <=0.6.10;
pragma experimental ABIEncoderV2;
import "./interfaces/TicketStructLib.sol";

contract TicketBookingSystem {

    address public owner;

    constructor(
        address _owner
    ) public {
        owner = _owner;
    }

    //storage variables for Issuers

    // issuerAddress -> Issuer
    mapping(address => TicketStructLib.Issuer) public issuerMap;

    //storage variables for shows

    // mapping for: showId -> Show
    mapping(string => TicketStructLib.Show) public showMap;

    //storage variables for ticket

    // ticketId -> TicketBooking
    mapping(string => TicketStructLib.TicketBooking) public ticketBookingMap;

    // ticketId -> issuerAddress 
    mapping(string => address) public ticketBookingIssuerMap;

    // ticketId -> customerAddress
    // ticketId is considered as Unique. i.e multiple shows wont share same ticketId
    mapping(string => address) public ticketBookingCustomerMap;

    modifier onlyOwner {
        require(msg.sender == owner, "only Owner can invoke the function");
        _;
    }

    function getOwner() public view returns(address){
        return owner;
    }

    modifier isIssuerAuthorised(address issuerAddress){
        require(issuerMap[msg.sender].issuerAddress == issuerAddress , "not Authorized to Invoke the function");
        _;
    }

    modifier isAnIssuerOfAShow(string memory _showId){
         require(showMap[_showId].issuer == msg.sender , "only Show Issuer can invoke the function");
        _;
    }

    function addATicketIssuer(string memory _issuerId, address _issuerAddress, string memory _issuerName) onlyOwner public  {
        require(TicketStructLib.isANonEmptyString(_issuerId), "invalid issuerId");
        require(!doesIssuerExist(_issuerAddress), "A TicketIssuer is already created with this issuerId" );
        require(TicketStructLib.isANonEmptyString(_issuerName), "invalid issuerName");
        TicketStructLib.Issuer memory issuerObjectForPersistence;
        issuerObjectForPersistence = TicketStructLib.Issuer({
                                                        issuerId : _issuerId,
                                                        issuerAddress: _issuerAddress,
                                                        issuerName : _issuerName,
                                                        createdAt : now,
                                                        updatedAt : 0});
        issuerMap[_issuerAddress] = issuerObjectForPersistence;
    }

    function getTicketIssuerDetails(address _issuerAddress) public view returns(TicketStructLib.Issuer memory issuer){
        require(doesIssuerExist(_issuerAddress), "TicketIssuer doesnot exist with this issuerAddress");
        return issuerMap[_issuerAddress];
    }

    function doesIssuerExist(address _issuerAddress) public view returns(bool){
        require(TicketStructLib.isAValidAddress(_issuerAddress), "issuerAddress is Invalid");
        return issuerMap[_issuerAddress].createdAt > 0;
    }

    function createAShow(
        string memory _showId,
        address _issuer,
        string memory _showName,
        uint256 _totalNumberOfTickets,
        uint256 _showPrice,
        uint256 _showTime,
        string memory _showTimeAsGMT
        ) isIssuerAuthorised(_issuer) public {
        require(TicketStructLib.isANonEmptyString(_showId), "invalid showId");
        require(doesIssuerExist(_issuer), "Issuer doesnot exist" );
        require(msg.sender == _issuer , "TicketIssuer Can create Shows for the Self. Cannot create shows for other Issuers");
        require(!doesShowExist(_showId), "A Show is already created with this showId" );
        require(TicketStructLib.isANonEmptyString(_showName), "invalid showName");
        require(TicketStructLib.isAValidInteger(_totalNumberOfTickets), "invalid totalNumberOfTickets");
        require(TicketStructLib.isAValidInteger(_showPrice), "invalid showPrice");
        require(TicketStructLib.isAValidInteger(_showTime), "invalid showTime");
        require(TicketStructLib.isANonEmptyString(_showTimeAsGMT), "invalid showTimeAsGMT");

        TicketStructLib.Show memory showObjectForPersistence;
        showObjectForPersistence = TicketStructLib.Show({
                                                        showId : _showId,
                                                        issuer: _issuer,
                                                        showName : _showName,
                                                        totalNumberOfTickets: _totalNumberOfTickets,
                                                        availableTicketCount: _totalNumberOfTickets,
                                                        showPrice : _showPrice,
                                                        showTime : _showTime,
                                                        showTimeAsGMT : _showTimeAsGMT,
                                                        createdAt : now,
                                                        updatedAt : 0});
        showMap[_showId] = showObjectForPersistence;
    }

    function getShowDetails(string memory _showId) public view returns(TicketStructLib.Show memory show){
        require(doesShowExist(_showId), "show doesnot exist with this showId");
        return showMap[_showId];
    }
    
    function doesShowExist(string memory _showId) public view returns(bool){
        require(TicketStructLib.isANonEmptyString(_showId), "showId is Invalid");
        return showMap[_showId].createdAt > 0;
    }

    modifier onlyTicketCustomer(string memory _ticketId) {
        require(doesTicketExist(_ticketId), "invalid ticketId");
        require(ticketBookingCustomerMap[_ticketId] == msg.sender, "message sender is not the ticket-holder");
        _;
    }

    //create a New TicketBooking & Add mapping for TicketBooking
    //Mark ticket as Locked
    function bookATicket(
        string memory _ticketId,
        string memory _showId,
        address _issuer,
        address _customer,
        uint8 _lockPeriodInSeconds) isAnIssuerOfAShow(_showId) public {
        require(TicketStructLib.isANonEmptyString(_ticketId), "invalid ticketId");
        require(TicketStructLib.isANonEmptyString(_showId), "invalid showId");
        require(TicketStructLib.isAValidAddress(_issuer), "invalid issuer Address");
        require(TicketStructLib.isAValidAddress(_customer), "invalid customer Address");
        require(TicketStructLib.isAValidInteger(_lockPeriodInSeconds), "invalid unlockDate value");
        require(_lockPeriodInSeconds > 0, "lockPeriodInSeconds should be a positive number");

        TicketStructLib.Show storage showObjectFromStorage = showMap[_showId];
        require(showObjectFromStorage.availableTicketCount>0, "Tickets not Available for the Show");

        TicketStructLib.TicketBooking memory ticketBookingObjectForPersistence;

        ticketBookingObjectForPersistence = TicketStructLib.TicketBooking({
                                                        ticketId : _ticketId,
                                                        showId : _showId,
                                                        showPrice : showObjectFromStorage.showPrice,
                                                        showTime : showObjectFromStorage.showTime,
                                                        issuer: _issuer,
                                                        customer: _customer,
                                                        isLocked: 10,
                                                        lockedAt: now,
                                                        lockPeriodInSeconds: _lockPeriodInSeconds,
                                                        claimableFrom: now + _lockPeriodInSeconds * 1 seconds,
                                                        claimedAt: 0,
                                                        createdAt : now});

        ticketBookingMap[_ticketId] = ticketBookingObjectForPersistence;
        ticketBookingIssuerMap[_ticketId] = _issuer;
        ticketBookingCustomerMap[_ticketId] = _customer;
        showObjectFromStorage.availableTicketCount = showObjectFromStorage.availableTicketCount-1;
    }

    function getTicketBookingDetails(string memory _ticketId) public view returns(TicketStructLib.TicketBooking memory ticketBooking){
        require(doesTicketExist(_ticketId), "TicketBooking doesnot exist with this ticketId");
        return ticketBookingMap[_ticketId];
    }

    function claimATicket(string memory _ticketId) onlyTicketCustomer(_ticketId) public {
        require(TicketStructLib.isANonEmptyString(_ticketId), "invalid ticketId");
        _claimTicket(_ticketId);
    }

    function _claimTicket(string memory _ticketId) internal {
        TicketStructLib.TicketBooking storage ticketBookingObject = ticketBookingMap[_ticketId];
        require(ticketBookingObject.claimedAt == 0 , "Ticket is already Claimed");
        require(now >= ticketBookingObject.claimableFrom);
        ticketBookingObject.isLocked = 0;
        ticketBookingObject.claimedAt = now;
    }

    function doesTicketExist(string memory _ticketId) public view returns(bool){
        require(TicketStructLib.isANonEmptyString(_ticketId), "invalid ticketId");
        return ticketBookingMap[_ticketId].createdAt > 0;
    }

    function isTickedLockedForCustomer(string memory _ticketId, address _customer) public returns (bool) {
        require(doesTicketExist(_ticketId), "invalid ticketId");
        require(TicketStructLib.isAValidAddress(_customer), "invalid customer Address");
        return ticketBookingCustomerMap[_ticketId] == _customer;
    }

    function isTicketClaimed(string memory _ticketId) public returns(bool){
        require(doesTicketExist(_ticketId), "ticket doesnot exist");
        return ticketBookingMap[_ticketId].claimedAt > 0;
    }

    function isTicketLocked(string memory _ticketId) public returns(bool){
        require(doesTicketExist(_ticketId), "ticket doesnot exist");
        return ticketBookingMap[_ticketId].isLocked > 0;
    }
}