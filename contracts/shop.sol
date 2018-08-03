pragma solidity 0.4.23;

import "openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol";
import "./Ownable.sol";

contract shop is StandardToken, Ownable {

  address public shopOwner;

  uint256 public totalItem;

  struct Item {
    string name;
    uint256 value;
    uint256 amount;
    bool opened;
  }

  mapping(uint256 => Item) public Shop;
  mapping(address => mapping(uint256 => uint256)) public purchases;

  event LogTransferShopOwnership(address indexed _newOwner);
  event LogCreateItem(string _name, uint256 _value, uint256 _amount);
  event LogBuyItem(uint256 _itemNumber, uint256 _amount, uint256 totalValue);
  event LogChangeAmount(uint256 _itemNumber, uint256 _newAmount);
  event LogChangePrice(uint256 _itemNumber, uint256 _newValue);
  event LogChangeOpened(bool _opened);

  modifier Number(uint256 _number) {
    require(_number < totalItem);
    _;
  }

  modifier onlyShopOwner() {
    require(msg.sender == shopOwner || msg.sender == owner);
    _;
  }

  constructor() public { 
    shopOwner = msg.sender;
  }

  function transferShopOwnership(address _newOwner) public onlyShopOwner() {
    shopOwner = _newOwner;

    emit LogTransferShopOwnership(_newOwner);
  }


  function createItem(string _name, uint256 _value, uint256 _amount) public onlyShopOwner {
    uint256 index = totalItem;
    totalItem++;

    Shop[index].name = _name;
    Shop[index].value = _value;
    Shop[index].amount = _amount;
    Shop[index].opened = true;

    emit LogCreateItem(_name, _value, _amount);
  }

  function buyItem(uint256 _itemNumber, uint256 _amount) public Number(_itemNumber) {
    require(
      Shop[_itemNumber].amount >= _amount &&
      Shop[_itemNumber].opened == true
    );

    Shop[_itemNumber].amount -= _amount;
    purchases[msg.sender][_itemNumber] += _amount;

    if(Shop[_itemNumber].amount == 0 ) {
      Shop[_itemNumber].opened = false;
    }

    uint256 totalValue = Shop[_itemNumber].value * _amount;

    balances[msg.sender] = balances[msg.sender].sub(totalValue);
    balances[shopOwner] = balances[msg.sender].add(tatalValue);

    emit LogBuyItem(_itemNumber, _amount, totalValue);
  }

  function changeAmount(uint256 _itemNumber, uint256 _newAmount) public onlyShopOwner Number(_itemNumber) {
    Shop[_itemNumber].amount = _newAmount;

    if(Shop[_itemNumber].opened == false) {
      Shop[_itemNumber].opened = true;
    }

    if(_newAmount == 0) {
      Shop[_itemNumber].opened = false;
    }

    emit LogChangeAmount(_itemNumber, _newAmount);
  }

  function changePrice(uint256 _itemNumber, uint256 _newValue) public onlyShopOwner Number(_itemNumber) {
    Shop[_itemNumber].value = _newValue;

    emit LogChangePrice(_itemNumber, _newValue);
  }

  function changeOpened(uint256 _itemNumber) public onlyShopOwner Number(_itemNumber) {

    if(Shop[_itemNumber].opened == true) {
      Shop[_itemNumber].opened = false;
    } else {
      Shop[_itemNumber].opened = true;
    }

    emit LogChangeOpened(Shop[_itemNumber].opened);
  }

  function shopInfo() view public returns(address, uint256) {
    return (shopOwner, totalItem);
  }

  function itemInfo(uint256 _itemNumber) view public returns(string, uint256, uint256, bool) {
    return(
      Shop[_itemNumber].name, 
      Shop[_itemNumber].value, 
      Shop[_itemNumber].amount, 
      Shop[_itemNumber].opened
    );
  }

  function myItemInfo(uint256 _itemNumber) view public returns(uint256, uint256) {
    return(_itemNumber, purchases[msg.sender][_itemNumber]);
  }
}
