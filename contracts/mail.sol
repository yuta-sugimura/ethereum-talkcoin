pragma solidity 0.4.23;

import "openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol";
import "./Ownable.sol";

contract mail is StandardToken, Ownable {

  address public mailOwner;

  uint256 public mailValue;

  mapping(address => mapping(uint256 => string)) private Mail;
  mapping(address => mapping(uint256 => address)) private MailAddress;
  mapping(address => uint256) private MailIndex;

  event LogTransferMailOwnership(address indexed _newOwner);
  event LogMailSetting(uint256 _mailValue);
  event LogMail(address indexed _from, address indexed _to, uint256 _value);

  modifier onlyMailOwner() {
    require(msg.sender == mailOwner || msg.sender == owner);
    _;
  }

  constructor() public { 
    mailOwner = msg.sender;
  }

  function transferMailOwnership(address _newOwner) public onlyMailOwner {
    mailOwner = _newOwner;

    emit LogTransferMailOwnership(_newOwner);
  }

  function mailSetting(uint256 _mailValue) public onlyMailOwner {
    mailValue = _mailValue;

    emit LogMailSetting(_mailValue);
  }

  function sendMail(address _to, string _message) public {
    require(
      _to != address(0) &&
      balances[msg.sender] >= mailValue
    );

    balances[msg.sender] = balances[msg.sender].sub(mailValue);
    
    uint256 messageLength = MailIndex[_to];
    MailIndex[_to]++;
    Mail[_to][messageLength] = _message;
    MailAddress[_to][messageLength] = msg.sender;

    emit LogMail(msg.sender, _to, mailValue);
  }

  function viewMailLength() public view returns(uint256) {
    return MailIndex[msg.sender];
  }

  function viewMail(uint256 _index) public view returns(address, string) {
    require(_index < MailIndex[msg.sender]);

    return(MailAddress[msg.sender][_index], Mail[msg.sender][_index]);
  }

}
