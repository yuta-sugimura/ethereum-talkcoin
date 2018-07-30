pragma solidity 0.4.23;

import "openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol";
import "./Ownable.sol";

contract talk is StandardToken, Ownable {

  address public talkOwner;

  uint256 public talkValue;

  string[] public Talk;
  address[] public TalkAddress;

  event LogTransferTalkOwnership(address indexed _newOwner);
  event LogTalkSetting(uint256 _talkValue);
  event LogTalk(address indexed _from, string _message, uint256 _value);


  modifier onlyTalkOwner() {
    require(msg.sender == talkOwner || msg.sender == owner);
    _;
  }

  constructor() public { 
    talkOwner = msg.sender;
  }

  function transferTalkOwnership(address _newOwner) public onlyTalkOwner {
    talkOwner = _newOwner;

    emit LogTransferTalkOwnership(_newOwner);
  }

  function talkSetting(uint256 _talkValue) public onlyTalkOwner {
    talkValue = _talkValue;

    emit LogTalkSetting(_talkValue);
  }

  function sendTalk(string _message) public {
    require(balances[msg.sender] >= talkValue);

    balances[msg.sender] = balances[msg.sender].sub(talkValue);
    Talk.push(_message);
    TalkAddress.push(msg.sender);

    emit LogTalk(msg.sender, _message, talkValue);
  }

  function viewTalkLength() public view returns(uint256) {
    return Talk.length;
  }

  function viewTalk(uint256 _index) public view returns(address, string) {
    require(_index < Talk.length);

    return(TalkAddress[_index], Talk[_index]);
  }


}
