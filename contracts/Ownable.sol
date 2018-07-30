pragma solidity 0.4.23;

contract Ownable {
  address public owner;

  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  event LogTransferOwnership(address indexed _exOwner, address indexed _newOwner);

  constructor() public {
    owner = msg.sender;
  }

  function transferOwnership(address _newOwner) public onlyOwner {
    require(_newOwner != address(0));

    emit LogTransferOwnership(owner, _newOwner);
    owner = _newOwner;
  }
}
