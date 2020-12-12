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
    }

    function doesIssuerExist(address _issuerAddress) public returns(bool){
        require(_issuerAddress, "issuerAddress is Invalid");
        return issuerMap[_issuerAddress].createdAt > 0;
    }

    function createAShow(
        string memory _showId,
        address _issuer,
        string memory _showName,
        uint _totalNumberOfTickets,
        uint256 _showPrice,
        uint256 _showTime,
        string memory _showTimeAsGMT
        ) onlyTicketIssuer public {
        require(TicketStructsLib.isANonEmptyString(_showId), "invalid showId");
        require(doesIssuerExist(_issuer), "Issuer doesnot exist" ;
        require(msg.sender] == _issuer , "TicketIssuer Can create Shows for the Self. Cannot create shows for other Issuers");
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
    }

    function doesShowExist(string memory _showId) public returns(bool){
        require(_showId, "showId is Invalid");
        return showMap[_showId].createdAt > 0;
    }

    modifier onlyTicketCustomer(string memory _ticketId) {
        require(doesTicketExist(_ticketId), "invalid ticketId");
        address customerAddress = ticketCustomerMap[_ticketId];
        require(customerAddress == msg.sender, "message sender is not the ticket-holder");
        _;
    }

    //create a New TicketBooking & Add mapping for TicketBooking
    //Mark ticket as Locked
    function bookATicket(
        string memory _ticketId,
        string memory _showId,
        address _issuer,
        address _customer,
        uint _lockPeriodInSeconds) public {
        require(TicketStructsLib.isANonEmptyString(_ticketId), "invalid ticketId");
        require(TicketStructsLib.isANonEmptyString(_showId), "invalid showId");
        require(TicketStructsLib.isAValidAddress(_issuer), "invalid issuer Address");
        require(TicketStructsLib.isAValidAddress(_customer), "invalid customer Address");
        require(TicketStructsLib.isAValidInteger(_unlockDate), "invalid unlockDate value");
        require(unlockDate > now, "unlockDate should be a future data");

        TicketStructsLib.Show memory showObjectFromStorage = showMap[_showId];

        TicketStructsLib.TicketBooking memory ticketBookingObjectForPersistence;

        ticketBookingObjectForPersistence = ClaimStructsLib.TicketBooking({
                                                        ticketId : _ticketId,
                                                        showId : _showId,
                                                        showPrice : showObjectFromStorage.showPrice,
                                                        showTime : showObjectFromStorage.showTime,
                                                        issuer: _issuer,
                                                        customer: _customer,
                                                        isLocked: block.number,
                                                        lockedAt: now,
                                                        lockPeriodInSeconds: _lockPeriodInSeconds,
                                                        claimableFrom: now + _lockPeriodInSeconds * 1 seconds,
                                                        isClaimed: 0,
                                                        claimedAt: 0,
                                                        createdAt : block.timestamp,
                                                        updatedAt : 0});

        ticketBookingMap[_ticketId] = ticketBookingObjectForPersistence;
        ticketBookingIssuerMap[_ticketId] = _issuer;
        ticketBookingCustomerMap[_ticketId] = _customer;
    }

    function claimATicket(string _ticketId) onlyTicketCustomer(_ticketId) public {
        require(TicketStructsLib.isANonEmptyString(_ticketId), "invalid ticketId");
        _claimTicket(ticketId);
    }

    function _claimTicket(string memory _ticketId) internal {
        TicketStructsLib.TicketBooking storage ticketBookingObject = ticketBookingMap[_ticketId];
        require(now >= ticketBookingObject.claimableFrom);
        ticketBookingObject.isLocked = 0;
        ticketBookingObject.isClaimed = block.number;
        ticketBookingObject.claimedAt = now;
    }

    function doesTicketExist(string memory _ticketId) public returns(bool){
        require(TicketStructsLib.isANonEmptyString(_ticketId), "invalid ticketId");
        return ticketBookingMap[_ticketId].createdAt > 0;
    }

    function isTickedLockedForCustomer(string memory _ticketId, address _customer) public returns (bool) {
        require(doesTicketExist(_ticketId), "invalid ticketId");
        require(TicketStructsLib.isAValidAddress(_customer), "invalid customer Address");
        return ticketCustomerMap[_ticketId] == _customer;
    }

    function isTicketClaimed(string memory _ticketId) public returns(bool){
        require(doesTicketExist(_ticketId), "ticket doesnot exist");
        return ticketBookingMap[_ticketId].isClaimed > 0;
    }

    function isTicketLocked(string memory _ticketId) public returns(bool){
        require(doesTicketExist(_ticketId), "ticket doesnot exist");
        return ticketBookingMap[_ticketId].isLocked > 0;
    }

    function info() public view returns(address, uint) {
        return (owner, this.balance);
    }

}