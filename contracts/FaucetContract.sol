pragma solidity >=0.4.22 <0.9.0;

contract Faucet {

  address public owner;
  uint public numOfFunders;
  mapping(address => bool) private funders; 
  mapping(uint => address) private lutFunders;

  constructor() {
    owner = msg.sender;
  }

  modifier limitWithdraw(uint withdrawAmount) {
    require(
      withdrawAmount <= 2000000000000000000, 
      "Can only withdraw 2 eth or less"
    );

    _;  //run function body if condition met
  }

  modifier onlyOwner {
    require (
      msg.sender == owner,
      "Only owner is authorized to call this function."
    );

    _;
  }

  
  receive() external payable {}

  function addFunds() external payable {
    address funder = msg.sender;
    if (!funders[funder]) {
      funders[funder] = true;
      lutFunders[numOfFunders++] = funder;
    }

  }

  function withdraw(uint withdrawAmount) external limitWithdraw(withdrawAmount) {
    payable(msg.sender).transfer(withdrawAmount);
    
  }

  function getAllFunders() external view returns (address[] memory) {
    address[] memory _funders = new address[](numOfFunders);
    for (uint i = 0; i < numOfFunders; i++) {
      _funders[i] = lutFunders[i];
    }
    return _funders;
  }



  function getFunderAtIndex(uint8 index) external view returns(address) {
    return lutFunders[index];
  }
}




// const instance = await Faucet.deployed()

// instance.addFunds({ from: accounts[0], value: "2000000000000000000" })  
// instance.withdraw("2000000000000000000", { from: accounts[1] })
//instance.getFunderAtIndex()
//instance.getAllFunders()
