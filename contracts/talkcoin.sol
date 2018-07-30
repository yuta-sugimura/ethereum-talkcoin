pragma solidity 0.4.23;

import "openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol";
import "./mail.sol";
import "./talk.sol";
import "./shop.sol";


contract talkcoin is mail, talk, shop {
  string public name = "talkToken";
  string public symbol = "talk";
  uint256 public decimals = 0;

  uint256 public getCoinAmount;
  uint256 public contractBalance;
  uint256 public stock = 21000000;
  uint256 public totalSupply_ = 21000000;

  event LogGetCoinSetting(uint256 _getCoinAmount);
  event LogGetCoin(address indexed _to, uint256 _amount);
  event LogMoveCoin(uint256 _amount);



  function getCoinSetting(uint256 _amount) public onlyOwner {
    getCoinAmount = _amount;

    emit LogGetCoinSetting(_amount);
  }

  function getCoin() public {
    require(
      contractBalance >= getCoinAmount &&
      balances[msg.sender] < getCoinAmount
    );

    contractBalance -= getCoinAmount;
    balances[msg.sender] += getCoinAmount;

    emit LogGetCoin(msg.sender, getCoinAmount);
  }

  function subCoin(uint256 _amount) public onlyOwner {
    contractBalance -= _amount;
    stock += _amount;
    emit LogMoveCoin(_amount);
  }

  function addCoin(uint256 _amount) public onlyOwner {
    contractBalance += _amount;
    stock -= _amount;
    emit LogMoveCoin(_amount);
  }

}