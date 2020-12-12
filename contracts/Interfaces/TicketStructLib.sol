pragma solidity >=0.4.21 <=0.6.10;
pragma experimental ABIEncoderV2;

library TicketStructLib {

    struct Issuer {
        string issuerId;
        address issuerAddress;
        string issuerName;
        uint256 createdAt;
        uint256 updatedAt;
    }

    struct Show {
        string showId;
        address issuer;
        string showName;
        uint totalNumberOfTickets;
        uint availableTicketCount;
        uint256 showPrice;
        uint showTime;
        string showTimeAsGMT;
        uint256 createdAt;
        uint256 updatedAt;
    }

    struct TicketBooking {
        string ticketId;
        string showId;
        uint256 showPrice;
        uint showTime;
        address issuer;
        address customer;
        bool isLocked;
        uint lockedAt;
        uint lockPeriodInSeconds;
        uint claimableFrom;
        bool isClaimed;
        uint claimedAt;
        uint256 createdAt;
        uint256 updatedAt;
    }

    function canUnLockTicket(uint256 lockedTime, uint256 lockPeriod) public returns (bool) {
        return lockedTime.add(lockPeriod) <= block.timestamp;
    }

     function addressToString(address addressForConversion) public pure returns (string memory)  {
        bytes memory b = new bytes(20);
        for (uint i = 0; i < 20; i++)
            b[i] = byte(uint8(uint(addressForConversion) / (2**(8*(19 - i)))));
        return string(b);
    }

    function isANonEmptyString(string memory stringArgument) public pure returns(bool){
        return bytes(stringArgument).length > 0;
    }

    function isAnEmptyString(string memory stringArgument) public pure returns(bool){
        return bytes(stringArgument).length == 0;
    }

    function isANonEmptyByteValue(bytes memory byteArgument) public pure returns(bool){
        return byteArgument.length > 0;
    }

    function isAValidAddress(address addressArgument) public pure returns(bool){
        return addressArgument != address(0x0);
    }

    function isAValidInteger(uint integerValue) public pure returns(bool){
        return integerValue > 0;
    }

     function translateAddressToString(address x) public pure returns(string memory) {
        bytes memory b = new bytes(20);
        for (uint i = 0; i < 20; i++)
            b[i] = byte(uint8(uint(x) / (2**(8*(19 - i)))));
        return string(b);
    }

    function hashCompareWithLengthCheck(string memory a, string memory b) public pure returns (bool) {
        if(bytes(a).length != bytes(b).length) {
            return false;
        } else {
            return keccak256(abi.encode(a)) == keccak256(abi.encode(b));
        }
    }

    function isATrueValue(string memory a) public pure returns (bool) {
        return hashCompareWithLengthCheck(a, "true");
    }
}