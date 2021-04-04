// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract IDOCrowdsale is Ownable, ReentrancyGuard {
  using SafeMath for uint256;
  using SafeERC20 for IERC20;
  using Address for address payable;

  // CLOSED - no one can deposit
  // PRESALE - anyone can deposit with tier levels based on tier token balance
  // MAINSALE - anyone can deposit without checking tier levels
  // PAUSED - no one can deposit and withdraw
  // FINALIZED - sale finalized and everyone can withdraw their token allocation
  // COMPLETED - issuer transfer the payment to self and LP
  // CANCELLED - no one can deposit but anyone can refund their wei/eth/bnb
  enum SaleStage { CLOSED, PRESALE, MAINSALE, PAUSED, FINALIZED, COMPLETED, CANCELLED }
  SaleStage public stage = SaleStage.CLOSED;

  bool public canDeposit = false;
  bool public canClaim = false;
  bool public canRefund = false;

  IERC20 public token;
  IERC20 public tierToken;

  // MANAGEMENT
  address public issuer; // issuer receives the payment
  address public operator; // operator cannot receive payment

  // // TIER
  // struct Tier {
  //   uint max; // max token they can purchase
  //   uint startTime; // time it will start
  //   uint256 rate; // multiplier
  // }
  // uint256 public tier; // the current tier, e.g 1, 2, 3, 4, 5
  // mapping(uint => Tier) tiers; // the tiers

  // DEPOSITS AND ALLOCATION
  uint256 public rate; // based on token decimal, 3 decimal token if rate is 1 == 0.001 token
  uint256 public raisedPreSale; // raised on presale
  uint256 public raisedSale; // raised after presale
  uint256 public raised; // total amount raised

  mapping(address => uint)      senderTiers; // the purchaser tier
  mapping(address => uint256)   tokenShares; // the amount each purchaser will receive
  mapping(address => uint256)   tokenClaims; // check status if how much was withdrawn
  mapping(address => uint256)   deposits; // the amount in wei each beneficiary deposited
  mapping(address => bool)      admins; // the admins

  // TIMEBASED
  uint256 public tier1Time;
  uint256 public tier2Time;
  uint256 public tier3Time;
  uint256 public tier4Time;
  uint256 public tier5Time;
  uint256 public mainSale;

  event AdminUpdated(address indexed _admin, bool indexed _status);
  event AdminChanged(address indexed _admin, address indexed _newAdmin);
  event TokenWithdrawn(address indexed _token, address indexed _beneficiary, uint256 indexed _amount);

  // eth/bnb deposited
  event Deposited(address indexed _sender, uint256 indexed _amount);
  event Refunded(address indexed _beneficiary, uint256 indexed _amount);

  // token claimed
  event TokenAllocated(address indexed _beneficiary, uint256 indexed _amount);
  event TokenClaimed(address indexed _beneficiary, uint256 indexed _amount);

  event StatusChanged(string indexed _status);

  modifier onlyAdmins() {
    require(admins[msg.sender], "Only authorize admin can call this function");
    _;
  }

  constructor(address _issuer, address _operator, uint256 _rate, IERC20 _token, IERC20 _tierToken) {
    rate = _rate;
    token = _token;
    tierToken = _tierToken;

    operator = _operator;
    issuer = _issuer;

    admins[_operator] = true;
    admins[address(msg.sender)] = true;
  }

  receive() external payable {
    purchase(_msgSender());
  }

  function purchase(address _beneficiary) public nonReentrant payable {
    uint256 amount = msg.value;

    // validate purcahse if _beneficiary and amount is ok;
    _preValidatePurchase(_beneficiary, amount);

    if (block.timestamp >= tier5Time && block.timestamp < mainSale) {
      _computeTokenShareForPreSale(_beneficiary, amount);
    } else {
      _computeTokenShareForSale(_beneficiary, amount);
    }

    // the total amount raised
    raised = raised.add(amount);

    // record the deposit
    deposits[_beneficiary] = deposits[_beneficiary] + amount;

    emit Deposited(_beneficiary, amount);
  }

  function _preValidatePurchase(address _beneficiary, uint256 _amount) internal view {
    require(_beneficiary != address(0), "Crowdsale: beneficiary is the zero address");
    require(_amount != 0, "Crowdsale: amount is 0");
    this;
  }

  function _computeTokenShareForPreSale(address _beneficiary, uint256 _amount) internal {
    uint256 _tierBalance = tierToken.balanceOf(_beneficiary);
    uint256 tierRate = 1; // tier rate starts at 1
    uint8 currentTier = 5; // tier 5

    if (_tierBalance >= 200 && block.timestamp >= tier1Time) { // tier 1
      tierRate = 6;
      currentTier = 1;
    } else if (_tierBalance >= 150 && _tierBalance < 200 && block.timestamp >= tier2Time) { // tier 2
      tierRate = 4;
      currentTier = 2;
    } else if (_tierBalance >= 100 && _tierBalance < 150 && block.timestamp >= tier3Time) { // tier 3
      tierRate = 3;
      currentTier = 3;
    } else if (_tierBalance >= 50 && _tierBalance < 100 && block.timestamp >= tier4Time) { // tier 4
      tierRate = 2;
      currentTier = 4;
    }

    uint256 shares = _amount.mul(rate);
    shares = shares.add(shares.mul(tierRate).div(100));

    tokenShares[_beneficiary] += shares;
    senderTiers[_beneficiary] = currentTier;
    raisedPreSale = raisedPreSale.add(_amount);

    emit TokenAllocated(_beneficiary, shares);
  }

  function _computeTokenShareForSale(address _beneficiary, uint256 _amount) internal {
    uint256 shares = _amount.mul(rate);

    tokenShares[_beneficiary] += shares;
    senderTiers[_beneficiary] = 6;
    raisedSale = raisedSale.add(_amount);

    emit TokenAllocated(_beneficiary, shares);
  }

  function setToken(IERC20 _token) public onlyAdmins {
    token = _token;
  }

  function setTierToken(IERC20 _tierToken) public onlyAdmins {
    tierToken = _tierToken;
  }

  function setRate(uint256 _rate) public onlyAdmins {
    rate = _rate;
  }

  function startSale() public onlyAdmins {
    mainSale = block.timestamp + 3 hours;
    tier5Time = block.timestamp;
    tier4Time = block.timestamp + 2 hours + 30 minutes;
    tier3Time = block.timestamp + 2 hours;
    tier2Time = block.timestamp + 1 hours + 30 minutes;
    tier1Time = block.timestamp + 1 hours;
    stage = SaleStage.PRESALE;
    emit StatusChanged("START SALE");
  }

  function resumePreSale() public onlyAdmins {
    stage = SaleStage.PRESALE;
    tier5Time = block.timestamp; // resets all time timestamp
    tier4Time = block.timestamp + 2 hours + 30 minutes;
    tier3Time = block.timestamp + 2 hours;
    tier2Time = block.timestamp + 1 hours + 30 minutes;
    tier1Time = block.timestamp + 1 hours;
    canDeposit = true;
    emit StatusChanged("RESUME PRESALE");
  }

  function resumeSale() public onlyAdmins {
    stage = SaleStage.MAINSALE;
    mainSale = block.timestamp; // set the timestamp as now
    canDeposit = true;
    emit StatusChanged("RESUME MAINSALE");
  }

  function pauseSale() public onlyAdmins {
    stage = SaleStage.PAUSED;
    canDeposit = false;
    emit StatusChanged("PAUSE SALE");
  }

  function shutOffSale() public onlyAdmins {
    stage = SaleStage.CANCELLED;
    canRefund = true;
    emit StatusChanged("SHUT OFF SALE");
  }

  function enableClaim() public onlyAdmins {
    canClaim = true;
  }

  function finalizeSale(address _lpAddress) public onlyAdmins {
    stage = SaleStage.FINALIZED;
    canClaim = true;
    uint256 balance = address(this).balance;
    uint256 toLP = balance.mul(50).div(100); // example 50% to liquidity provider
    _sendValue(payable(_lpAddress), toLP);
    emit StatusChanged("FINALIZE SALE");
  }

  // claim tokens by beneficiary
  function withdraw(IERC20 _token) public nonReentrant returns (bool) {
    require(canClaim, "Tokens cannot be claimed yet");

    address _msgSender = _msgSender();
    require(tokenShares[_msgSender] >= tokenClaims[_msgSender], "No more token to claim");

    uint256 shares = tokenShares[_msgSender];
    _token.safeTransferFrom(address(this), _msgSender, shares);
    tokenClaims[_msgSender] += shares;
    emit TokenClaimed(_msgSender, shares);
    return true;
  }

  // refund eth/bnb
  function refund() public nonReentrant {
    require(canRefund, "Refund is not allowed");
    address _msgSender = _msgSender();
    uint256 _amount = deposits[_msgSender];
    _sendValue(payable(_msgSender), _amount);
    emit Refunded(_msgSender, _amount);
    deposits[_msgSender] = 0;
  }

  /**
  * OWNER FUNCTIONS
  **/
  function setAdmin(address _admin) public onlyOwner {
    admins[_admin] = true;
    emit AdminUpdated(_admin, true);
  }

  function unsetAdmin(address _admin) public onlyOwner {
    admins[_admin] = false;
    emit AdminUpdated(_admin, false);
  }

  function setOperator(address _operator) public onlyOwner {
    admins[operator] = false;
    admins[_operator] = true;
    emit AdminChanged(operator, _operator);
    operator = _operator;
  }
  /**
  * ISSUER FUNCTIONS
  **/

  modifier onlyIssuer() {
    require(issuer == msg.sender, "Only issuer can deposit the tokens");
    _;
  }

  // issuer can deposit
  function issuerDeposit(uint256 _amount) public onlyIssuer {
    token.safeTransferFrom(msg.sender, address(this), _amount);
  }

  // issuer can withdraw / emergency withdraw
  function issuerWithdraw(uint256 _amount) public onlyIssuer {
    token.safeTransferFrom(address(this), msg.sender, _amount);
  }

  // burn tokens
  function issuerBurn(address _burnAddress, uint256 _amount) public onlyIssuer {
    token.safeTransferFrom(address(this), _burnAddress, _amount);
  }


  function getBalance() public view returns(uint) {
    return address(this).balance;
  }

  function _sendValue(address payable recipient, uint256 amount) internal {
    require(address(this).balance >= amount, "Address: insufficient balance");
    (bool success, ) = recipient.call{ value: amount }("");
    require(success, "Address: unable to send value, recipient may have reverted");
  }

}
