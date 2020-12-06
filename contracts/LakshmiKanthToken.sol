pragma solidity 0.5.16;

import 'openzeppelin-solidity/contracts/token/ERC20/ERC20Capped.sol';
import 'openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol';
import 'openzeppelin-solidity/contracts/ownership/Ownable.sol';

/**
 * @dev Example of the ERC20 Token.
 */
contract LakshmiKanthToken is Ownable, ERC20Detailed, ERC20Capped {

    using SafeMath for uint256;

     uint256 CAP = 1000000000;
     uint256 TOTALSUPPLY = CAP.mul(10 ** 18);

	constructor()
		public
		ERC20Detailed('LakshmiKanthToken', 'LAKSHMI_KANTH_TOKEN', 18)
		ERC20Capped(TOTALSUPPLY)
		Ownable()
	{
		_mint(msg.sender, TOTALSUPPLY);
	}
}