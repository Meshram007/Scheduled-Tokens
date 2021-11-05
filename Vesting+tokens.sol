//SPDX-License-Identifier: Unlicensed

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";
pragma solidity ^0.8.0;

contract XYZToken is ERC20{
    
    address public admin;
    address[] public users;
    uint public constant duration = 365 days;
    uint public immutable end;
    
    /**
     *100 millions tokens distributed evenly to the 10 users over the period of 12 months 
     *and each tokens tranfer after every 60 seconds(1 min).
     *millions per users =(100* 10**6) / 10
                       = 10*10**6
                       
     *amount = (10*10**6) / (365*24*60*60)
           = 0.3170979198    (this is float value and it is not applicable solidity)
           = 0.3170979198*10**18 (scaled by 10**18)
     */
     
    uint256 public amount = 3170979198*10**8; //amount scaled by 10**18
    
    constructor() ERC20("xyz Token", "XYZ"){
        end = block.timestamp + duration;
        admin = msg.sender;
    }
    
    
    modifier onlyadmin {
        require(msg.sender == admin, "Olny Admin Can");
        _;
    }
    
    
    function balance() external view returns(uint256) {
        return balanceOf(msg.sender);
    }
    /**
      * @dev function to mint 100 millions XYZ tokens
     */
    function mintTokens(uint mintAmount) external onlyadmin {
        _mint(msg.sender, mintAmount*10**18); // 
    }
    
    
     /**
      * @dev function used to disperse the tokens evenly to the 10 accounts
      * @dev every 60 seconds(1 min) tokens will be distributed to the accounts
      * @dev the total duration period is 12 months(365 days) to end the distribution of tokens evenly
      */
    function distributeTokens(
        address user0,
        address user1,
        address user2,
        address user3,
        address user4,
        address user5,
        address user6,
        address user7,
        address user8,
        address user9
        ) 
        external onlyadmin {
            uint256 lastExecuted;
            users.push(user0);
            users.push(user1);
            users.push(user2);
            users.push(user3);
            users.push(user4);
            users.push(user5);
            users.push(user6);
            users.push(user7);
            users.push(user8);
            users.push(user9);
            for (uint i = 0; i < end; i++) {
               for (uint j=0; j < users.length; j++) {
                   
                  // total duration time should be less than or equal to end
                  require(
                     block.timestamp <= end,
                     "duration period over"
                  );
                  
                  //this require distribute the tokens after every 60 mins
                  require(
                     ((block.timestamp - lastExecuted) > 60),
                     "Time not elapsed"
                  );
              
                  // transfer the tokens to the particular users with fixed amount per seconds
                  _transfer(msg.sender, users[j], amount);
                  lastExecuted = block.timestamp;
               }
            }
    }
}
