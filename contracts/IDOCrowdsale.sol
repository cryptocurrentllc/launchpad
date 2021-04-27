/**
 *Submitted for verification at BscScan.com on 2021-04-26
*/

// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return a % b;
    }

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
    }

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a % b;
        }
    }
}

interface IToken {
    function decimals() external pure returns (uint256);
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface IIDOCrowdsale {
  function setSetting(IToken token, IToken tierToken, IToken _lpToken, uint256 rate, address issuer, address lp) external;
  function setDist(uint8 teamPerc, uint8 liquidityPerc, uint8 issuerPerc, uint8 tokenWeight) external;
  function setManager(address manager, bool status) external;
  function addTeam(address[] memory addresses) external;
}

library Address {

    function isContract(address account) internal view returns (bool) {
        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }

    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: value }(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

abstract contract ReentrancyGuard {
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor () {
        _status = _NOT_ENTERED;
    }

    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}

interface IRouter {
  function addLiquidityETH(
      address token,
      uint amountTokenDesired,
      uint amountTokenMin,
      uint amountETHMin,
      address to,
      uint deadline
  ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
  function removeLiquidityETH(
      address token,
      uint liquidity,
      uint amountTokenMin,
      uint amountETHMin,
      address to,
      uint deadline
  ) external returns (uint amountToken, uint amountETH);
}

library SafeERC20 {
  using Address for address;
  function safeTransfer(IToken token, address to, uint256 value) internal {
    _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
  }
  function safeTransferFrom(IToken token, address from,  address to, uint256 value) internal {
    _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, from, to, value));
  }
  function _callOptionalReturn(IToken token, bytes memory data) private {
    bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
    if (returndata.length > 0) {
      require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
    }
  }
}

contract IDOCrowdsale is IIDOCrowdsale, Ownable, ReentrancyGuard {
  using SafeMath for uint256;
  using SafeMath for uint8;
  using SafeERC20 for IToken;

  // CLOSED - no one can deposit
  // SALE - anyone can deposit
  // PAUSED - no one can deposit and withdraw
  // FINALIZED - sale finalized and everyone can withdraw their token allocation
  // COMPLETED - issuer transfer the payment to self and LP
  // CANCELLED - no one can deposit but anyone can refund their wei/eth/bnb
  enum SaleStage { CLOSED, SALE, PAUSED, FINALIZED, COMPLETED, CANCELLED }
  SaleStage public stage = SaleStage.CLOSED;

  bool public canDeposit = false;
  bool public canClaim = false;
  bool public canRefund = false;
  bool public issuerWithdrawn = false;

  IToken public token;
  IToken public tierToken;
  IToken public lpToken;

  // MANAGEMENT
  address public issuer; // issuer receives the payment
  uint256 public issuerLock; // issuer should be locked for 1 year before they can withdraw the lp tokens
  address public lp;

  // DISTRIBUTION PERCENTAGE
  uint8 public teamPerc = 5; // 3%
  uint8 public liquidityPerc = 60; // 60%
  uint8 public issuerPerc = 35; // 37%
  uint8 public tokenWeight = 97; // 97% to make token value increase by 1.3% in the lp
  uint8 public totalPerc = 100;
  

  // SHARES BASED ON DISTRIBUTION PERCENTAGE
  uint256 public teamShare;
  uint256 public memberShare;
  uint256 public liquidityShare;
  uint256 public lpTokenShare;
  uint256 public issuerShare;

  // DEPOSITS AND ALLOCATION
  uint256 public baseAllocation; // the amount of tokens the lowest preSale tier can purchase
  uint256 public rate; // based on token decimal, 3 decimal token if rate is 1 == 0.001 token
  uint256 public raisedPreSale; // raised on presale
  uint256 public raisedSale; // raised after presale

  uint256 public raised; // total amount raised
  uint256 public claimed;
  uint256 public tokens; // total tokens should match the deposited token of the issuer
  uint256 public minimumPurchase; //minimumPurchase in BNB for sale



  uint256 public total_participants;
  mapping(uint8 => uint256)     public raisedTiers;
  mapping(uint8 => uint256)     public participants;
  mapping( address => bool )    public participated;

  // uint8                         public totalMembers;
  address[]                     public members;
  mapping(address => bool)      public teamMembers;

  mapping(address => uint)      public senderTiers; // the purchaser tier
  mapping(address => uint256)   public tokenShares; // the amount each purchaser will receive
  mapping(address => uint256)   public tokenClaims; // check status if how much was withdrawn
  mapping(address => uint256)   public deposits; // the amount in wei each beneficiary deposited
  mapping(address => bool)      public managers; // the managers

    
  // TIMEBASED
  uint256 public tier1Time;
  uint256 public tier2Time;
  uint256 public tier3Time;
  uint256 public tier4Time;
  uint256 public tier5Time;
  uint256 public mainSale;
  uint256 public saleEnds;
  
  uint8 public finalTier;

  uint256 public timePaused;
  uint256 public timeIDOEnded;

  // EVENTS
  event Deposited(address indexed _sender, uint256 indexed _amount);
  event Withdrawn(address indexed _beneficiary, uint256 indexed _amount);
  event TokenAllocated(address indexed _beneficiary, uint256 indexed _amount);
  event TokenClaimed(address indexed _beneficiary, uint256 indexed _amount);
  event StatusChanged(SaleStage _status);
  event ManagerUpdated(address indexed _manager, bool indexed _status);

  modifier onlyManagers() {
    require(managers[msg.sender], 'Manager Access Only');
    _;
  }

  modifier allowDeposit() {
    require(canDeposit, 'Deposit Not Allowed');
    _;
  }

  modifier allowRefund() {
    require(canRefund, 'Refund Not Allowed');
    _;
  }

  modifier allowClaim() {
    require(canClaim, 'Claim Not Allowed');
    _;
  }

  constructor(address _issuer, address _manager, uint256 _rate, IToken _tierToken, IToken _lpToken, address _lpaddress , uint256 _baseAllocation, IToken _idotoken, uint256 _minimumPurchase  ) {
    rate = _rate;
    issuer = _issuer;
    managers[msg.sender] = true;
    managers[_manager] = true;
    tierToken = _tierToken;
    lpToken =  _lpToken;
    lp = _lpaddress;
    baseAllocation = _baseAllocation;
    token = _idotoken;
    minimumPurchase = _minimumPurchase;
  }

  receive() external payable allowDeposit {
    purchase(_msgSender());
  }

  function purchase(address _beneficiary) public nonReentrant allowDeposit payable {
    require( _beneficiary != address(0), 'Zero Address');
    require( msg.value != 0, 'Zero Amount');
    require ( block.timestamp > tier1Time );
    require ( msg.value + deposits[ _beneficiary ] >= minimumPurchase );
    require ( canDeposit == true );
    require ( block.timestamp < saleEnds );
    require ( tokens <  maximumTokensForSale() );   
    

    uint256 amount = msg.value;

    // TIER 1 Starts 3 hours before mainsale
    if ( block.timestamp >= tier1Time && block.timestamp <= mainSale) {
      _computeTokenShareForPreSale(_beneficiary, amount);
    } else if (block.timestamp >= mainSale) {
      _computeTokenShareForSale(_beneficiary, amount);
    } else {
      revert('Unauthorized Transaction - Main Sale Only');
    }
   
    raised = raised.add(amount);
    deposits[_beneficiary] += amount;
    emit Deposited(_beneficiary, amount);
  }
  
  function maximumTokensForSale() public view returns ( uint256)  {
      if ( getIDOContractTokenBalance() == 0 ) return 0;
      return (( getIDOContractTokenBalance() * ( totalPerc.sub(liquidityPerc)))/100);
  }


  function _computeTokenShareForPreSale(address _beneficiary, uint256 _amount) internal {
    IDOManager _manager = IDOManager( owner() );
    uint tierLevel = _manager.userTierLevel ( _beneficiary );


    // Starts at Tier 5
    uint8 currentTier;
    //uint256 tierRate;
    uint256 shares = _amount.mul(rate);

    // Tier 1
    if ( tierLevel == 1 ) {

      currentTier = 1;
      shares = _amount.mul((rate*103)/100);
      // Tier 2
    } else if ( tierLevel == 2 && block.timestamp >= tier2Time) { // tier 2
      currentTier = 2;

      // Tier 3
    } else if ( tierLevel == 3 && block.timestamp >= tier3Time) { // tier 3
      currentTier = 3;

      // Tier 4
    } else if ( tierLevel == 4 && block.timestamp >= tier4Time) { // tier 4
      currentTier = 4;

      // Tier 5
    } else if ( tierLevel == 2 && block.timestamp >= tier5Time) { // tier 5
      currentTier = 5;

    }  else {
      revert('Unauthorized Transaction - Main Sale Only');
    }

    require(_amount <= getMaxBNBSend(currentTier).sub(deposits[_beneficiary ]) );
    require(shares + tokenShares[_beneficiary] <= getMaxTierAllocation(tierLevel));
    require(currentTier < 6, 'No Tier Token or LP Balance');

    tokenShares[_beneficiary] = tokenShares[_beneficiary].add(shares);
    senderTiers[_beneficiary] = currentTier;
    
    if( !participated[_beneficiary] ) { participants[currentTier] = participants[currentTier].add(1); participated[_beneficiary] = true; total_participants++; }// increment by 1
    raisedTiers[currentTier] = raisedTiers[currentTier].add(shares);
    raisedPreSale = raisedPreSale.add(_amount);
    tokens = tokens.add(shares);
    emit TokenAllocated(_beneficiary, shares);
  }


  

  function _computeTokenShareForSale(address _beneficiary, uint256 _amount) internal {
    uint256 shares = _amount.mul(rate);
    tokenShares[_beneficiary] += shares;
    senderTiers[_beneficiary] = 6;
    raisedSale = raisedSale.add(_amount);
    participants[6] = participants[6].add(1);
    tokens = tokens.add(shares);
    emit TokenAllocated(_beneficiary, shares);
  }

  function startSale( uint256 utctime ) public onlyManagers {
    require ( utctime > block.timestamp  );
    require ( baseAllocation > 0 );
    require ( getIDOContractTokenBalance() > 100000000000000000000, "IDO Contract needs IDO Tokens");
    setSchedule ( utctime );
    canDeposit = true;
    canRefund = false;
    canClaim = false;
    stage = SaleStage.SALE;
    emit StatusChanged(stage);
  }

  function setSchedule( uint256 utctime ) internal {
    
    tier1Time = utctime;
    tier2Time = utctime + 30 minutes;
    tier3Time = utctime + 1 hours;
    tier4Time = utctime + 1 hours + 30 minutes;
    tier5Time = utctime + 2 hours;
    mainSale  = utctime + 3 hours;
    saleEnds  = utctime + 24 hours;
  }


  function preSaleStarted() public view returns ( bool ) {
    return ( block.timestamp >= tier1Time  && tier1Time != 0 );
  }

  function mainSaleStarted() public view returns ( bool ) {
    return ( block.timestamp >= mainSale  && mainSale != 0 );
  }

  

  function setBaseAllocation(  uint256 _baseAllocation ) public onlyManagers{
    baseAllocation = _baseAllocation * 1000000000000000000;
  }

  function getMaxTierAllocation ( uint256 _tier ) public view returns ( uint256 ){
    require ( _tier > 0 );
    if ( _tier == 1 ) return (((6600 * baseAllocation)/1000));
    if ( _tier == 2 ) return (((4400 * baseAllocation)/1000));
    if ( _tier == 3 ) return (((3300 * baseAllocation)/1000));
    if ( _tier == 4 ) return (((2300 * baseAllocation)/1000));
    if ( _tier == 5 ) return (((1000 * baseAllocation)/1000));
    return ((1 * baseAllocation));
  }

  function getMaxBNBSend ( uint256 _tier ) public view returns ( uint256 ){
    require ( _tier > 0 );
    if ( _tier == 1 ) return (((6600 * baseAllocation)/1000)/(rate*103/100));
    if ( _tier == 2 ) return (((4400 * baseAllocation)/1000)/rate);
    if ( _tier == 3 ) return (((3300 * baseAllocation)/1000)/rate);
    if ( _tier == 4 ) return (((2300 * baseAllocation)/1000)/rate);
    if ( _tier == 5 ) return (((1000 * baseAllocation)/1000)/rate);
    return ((1 * baseAllocation/rate));
  }

  function getIDOContractTokenBalance() public view  returns ( uint256 ){
    return token.balanceOf(address(this));
  }

  

  function getCurrentTier() public view returns ( uint8 ){
    // Defaults to IDO did not start yet
    uint8 currentTier = 0;
    
    if ( finalTier > 0 ) return finalTier;

    // Tier Paused
    if (tier1Time == 8888888888) {

      currentTier = 255;// IDO is paused
      // Tier Mainsale
    } else if ( tier1Time == 0) { // tier 2
      currentTier = 0;

      // Tier 5
    } else if ( block.timestamp >= mainSale) { // tier 2
      currentTier = 6;

      // Tier 5
    } else if ( block.timestamp >= tier5Time) { // tier 2
      currentTier = 5;

      // Tier 4
    } else if ( block.timestamp >= tier4Time) { // tier 3
      currentTier = 4;

      // Tier 3
    } else if (  block.timestamp >= tier3Time) { // tier 4
      currentTier = 3;

      // Tier 2
    } else if ( block.timestamp >= tier2Time ) {
      currentTier = 2;

      // Tier 1
    } else if ( block.timestamp >= tier1Time ) {
      currentTier = 1;
    }

    return currentTier;

  }

  function availableAllocationLeft ( address _user ) public view returns ( uint256 ){
    IDOManager _manager = IDOManager( owner() );
    return getMaxTierAllocation ( _manager.userTierLevel ( _user )).sub(tokenShares [_user]) ;
  }

  function availableAllocationLeftinBNB ( address _user ) public view returns ( uint256 ){
    IDOManager _manager = IDOManager( owner() );
    return getMaxBNBSend ( _manager.userTierLevel ( _user )).sub( deposits [_user])  ;
  }

  function pauseSale() public onlyManagers {
    require ( stage == SaleStage.SALE );
    canRefund = true;
    canDeposit = false;
    canClaim = false;
    stage = SaleStage.PAUSED;
    timePaused = block.timestamp - tier1Time;
    setSchedule ( 8888888888 );
    emit StatusChanged(stage);
  }

  function unPauseSale() public onlyManagers {
    require ( stage == SaleStage.PAUSED );
    canRefund = false;
    canDeposit = true;
    stage = SaleStage.SALE;
    setSchedule( block.timestamp - timePaused );
    emit StatusChanged(stage);
  }

  function shutOffSale() public onlyManagers {
    canRefund = true;
    canDeposit = false;
    canClaim = false;
    stage = SaleStage.CANCELLED;
    emit StatusChanged(stage);
  }

  function finalizeSale() public onlyManagers {
    canClaim = true;
    canDeposit = false;
    canRefund = false;
    computeDistribution();
    stage = SaleStage.FINALIZED;
    finalTier = getCurrentTier();
    if ( block.timestamp < saleEnds ) {timeIDOEnded = block.timestamp; } else timeIDOEnded = saleEnds ;
    emit StatusChanged(stage);
    issuerLock = block.timestamp + (1 days * 365); // total of 1 year
  }

  // allows recomputation of distribution incase sale is extended
  function computeDistribution() public onlyManagers {
    uint256 balance = address(this).balance;
    teamShare = balance.mul(teamPerc).div(100);
    memberShare = teamShare.div(members.length);
    liquidityShare = balance.mul(liquidityPerc).div(100);
    issuerShare = balance.sub(teamShare.add(liquidityShare)); // all remaining balance will be allocated to the issuer
    lpTokenShare = liquidityShare.mul(rate).mul(tokenWeight).div(100);
  }

  // claim tokens by beneficiary
  function claim() public nonReentrant allowClaim {
    address _claimer = _msgSender();
    require(tokenShares[_claimer] > tokenClaims[_claimer], "No More Tokens");
    uint256 shares = tokenShares[_claimer];
    tokenClaims[_claimer] = tokenClaims[_claimer].add(shares);
    token.safeTransfer(_claimer, shares);
    claimed = claimed.add(shares);
    emit TokenClaimed(_claimer, shares);
  }

  // withdraw refund eth/bnb
  function withdraw() public nonReentrant allowRefund {
    address receiver = _msgSender();
    uint256 amount = deposits[receiver];
    _sendValue(payable(receiver), amount);
    emit Withdrawn(payable(receiver), amount);
    deposits[receiver] = 0;
    tokenShares[receiver] = 0;
  }

  // team member can withdraw their eth/bnb shares
  function teamWithdraw() public nonReentrant allowClaim {
    require(teamMembers[_msgSender()], 'Team Member Only');
    _sendValue(payable(_msgSender()), memberShare);
  }

  /**
  * OWNER FUNCTIONS
  **/
  function addTeam(address[] memory _members) public onlyOwner override {
    members = _members;
    for (uint8 i = 0; i < _members.length; i++) {
      teamMembers[_members[i]] = true;
    }
  }

  function setManager(address _manager, bool _status) public override onlyOwner {
    managers[_manager] = _status;
    emit ManagerUpdated(_manager, _status);
  }

  function setDist(uint8 _teamPerc, uint8 _liquidityPerc, uint8 _issuerPerc, uint8 _tokenWeight) public override onlyManagers {
    require(_teamPerc + _issuerPerc + _liquidityPerc == 100, 'Total < 100');
    teamPerc = _teamPerc;
    issuerPerc = _issuerPerc;
    liquidityPerc = _liquidityPerc;
    tokenWeight = _tokenWeight;
  }

  function setSetting(IToken _token, IToken _tierToken, IToken _lpToken, uint256 _rate, address _issuer, address _lp) public override onlyOwner {
    token = _token;
    tierToken = _tierToken;
    lpToken = _lpToken;
    rate = _rate;
    issuer = _issuer;
    lp = _lp;
  }

  function setIDOToken(IToken _token ) public  onlyManagers {
    token = _token;
  }

  function createPair(IRouter _router, address _to) public onlyManagers {
    require(stage == SaleStage.FINALIZED, 'Not Finalized');
    require(address(this).balance >= liquidityShare, 'Insufficient Balance');
    require(getIDOContractTokenBalance() >= lpTokenShare, 'Insufficient Tokens');
    _router.addLiquidityETH(address(token), lpTokenShare, lpTokenShare, liquidityShare, _to, block.timestamp);
    stage = SaleStage.COMPLETED;
  }

  function sendLP() public onlyManagers {
    require(stage == SaleStage.FINALIZED, 'Not Finalized');
    token.transfer( lp, lpTokenShare );  
    _sendValue(payable(lp), liquidityShare);
      
      
  }



  /**
  * ISSUER FUNCTIONS
  **/
  modifier onlyIssuer() {
    require(issuer == msg.sender, 'Issuer Access Only');
    _;
  }

  // issuer can deposit anytime
  function issuerDeposit(IToken _token, uint256 _amount) public onlyIssuer {
    _token.transferFrom( msg.sender, address(this), _amount);
  }

  // issuer can withdraw / emergency withdraw tokens if the the contract is shut off
  // issuer can withdraw if the holders can refund
  function issuerClaim(IToken _token, uint256 _amount) public onlyIssuer {
    require( canRefund );
    _token.safeTransfer(msg.sender, _amount);
  }

  // issuer can claim the bnb/eth after a year
  function issuerWithdraw() public onlyIssuer {
    // once the issuer can withdraw their 37% share
    if (!issuerWithdrawn && issuerShare > 0 && liquidityShare > 0 && lpTokenShare > 0) {
      _sendValue(payable(issuer), issuerShare);
      issuerWithdrawn = true;
    }
  }

  // burn tokens
  function issuerBurn( uint256 _amount ) public onlyManagers {
    require(claimed >= tokens, 'Issuer Cannot Burn Token < Claimed');
    token.safeTransfer( 0x0000000000000000000000000000000000000000, _amount);
  }

  function _sendValue(address payable recipient, uint256 amount) internal {
    require(address(this).balance >= amount, 'Insufficient Balance');
    (bool success, ) = recipient.call{ value: amount }("");
    require(success, 'Unable To Send, Reverted');
  }

}

contract IDOManager is Ownable {

  using SafeERC20 for IToken;
  using SafeMath for uint256;

  event ContractCreated(address indexed);

  address public manager;
  address[] public team;
  uint256 public teamCount;
  bool public tokensSet;
  bool public teamSet;

  address public lpaddress;
  IToken public lpToken;
  IToken public tierToken;
  uint8 public teamPerc = 5;
  uint8 public liquidityPerc = 60;
  uint8 public issuerPerc = 35;
  uint8 public tokenWeight = 97;

  uint256 public contractCount=0;


  IToken public token;
  //address public vltbnb_token;
  mapping ( address => uint256 ) public stakedAmountLP;
  mapping ( address => uint256 ) public stakedTimeLP;
  mapping ( address => uint256 ) public stakedAmountVLT;
  mapping ( address => uint256 ) public stakedTimeVLT;
  uint256 public lastIDODeployedTime;
  uint256 public minimumLockTime;
  uint256 public minimumLP;

  struct ContractDetails {
    string    name;
    address   issuer;
    uint8     version;
    address   manager;
    uint256   rate;
    uint256   baseAllocation;
    address   idoToken;
    uint256   minimumPurchase;
  }

  mapping (address => ContractDetails) public contracts;
  mapping (uint256 => address) public contractAddresses;

  constructor() {
    minimumLP = 46000000000000000000;
    lpaddress = 0x1ef932e9574542BC2730c6DC5Fa0003023c62b5e;
    tierToken = IToken(0xda8336cc6A4C37e69d539BFA5Da1B3499f376162);
    lpToken = IToken(0x451f70056FfdCBe4F4Db04d717DAE818054C0688);
    tokensSet = true;
    team = [0x0509A3053C83F55c88DBc726eb29A19972f29A36,0xf2b90042164e84A4f9599c8948d63A8DED7d29c1];
    teamCount = team.length;
    teamSet = true;
    minimumLockTime = 3 minutes;
  }

  // deploy the ido contract
  function deployIDO(string memory _name, address _issuer, address _manager, uint256 _rate, uint256 _baseAllocation, IToken _idotoken, uint256 _minimumPurchase, uint8 _version) public onlyTeam returns(address) {
    require ( tokensSet && teamSet );
    IDOCrowdsale newIDO = new IDOCrowdsale(_issuer, _manager, _rate , tierToken, lpToken, lpaddress, _baseAllocation*1000000000000000000, _idotoken, _minimumPurchase  );

    newIDO.setManager(manager, true);
    newIDO.setDist(teamPerc, liquidityPerc, issuerPerc, tokenWeight);
    newIDO.addTeam(team);

    address _newIDOAddress = address(newIDO);
    emit ContractCreated(_newIDOAddress);
    contracts[_newIDOAddress] = ContractDetails(_name, _issuer, _version, _manager, _rate, _baseAllocation, address(_idotoken), _minimumPurchase );
    contractAddresses[contractCount] = _newIDOAddress;
    contractCount++;
    lastIDODeployedTime = block.timestamp;
    return _newIDOAddress;
  }

  // set the ido sale setting


  function setIDOSetting(IIDOCrowdsale _contract, IToken _token, uint256 _rate, address _issuer, address _lp) public onlyOwner {
    _contract.setSetting(_token, tierToken, lpToken, _rate, _issuer, _lp);
  }

  function setTokensAndLp(IToken _tierToken, IToken _lpToken, address _lpaddress) public onlyTeam {
    tierToken = _tierToken;
    lpToken = _lpToken;
    lpaddress = _lpaddress;
    tokensSet = true;
  }



  // set the distribution percentage
  function setDistribution(IIDOCrowdsale _contract, uint8 _teamPerc, uint8 _liquidityPerc, uint8 _issuerPerc, uint8 _tokenWeight) public onlyOwner {
    _contract.setDist(_teamPerc, _liquidityPerc, _issuerPerc, _tokenWeight);
  }

  // set the manager(s) for the contract
  function setManager(address _manager) public onlyOwner {
    manager = _manager;
  }

  function addManager(IIDOCrowdsale _contract, address _manager, bool _status) public onlyOwner {
    _contract.setManager(_manager, _status);
  }

  function setTeam(address[] memory _team) public onlyOwner {
    team = _team;
    teamCount = _team.length;
    teamSet = true;
  }

  function getTeam() public view returns( address  [] memory){
    return team;
  }

 function setMinimumLPVLTLockTime ( uint256 _minimumLockTime ) public onlyTeam {
     
     minimumLockTime = _minimumLockTime;
     
 }

  function setMinimumLP ( uint256 _minLP ) public onlyTeam {
    minimumLP = _minLP;
  }

  /**
  * @dev deposit LP Tokens
  * @param _lptokens value to store
  */
  function depositLP(uint256 _lptokens) public {
    require ( _lptokens >= minimumLP );
    stakedAmountLP [ msg.sender ] += _lptokens;
    if ( stakedTimeLP [ msg.sender ] ==  0 ) stakedTimeLP [ msg.sender ] = block.timestamp; 
    lpToken.transferFrom( msg.sender , address(this), _lptokens );

  }

  /**
  * @dev Withdraw LP Tokens
  */
  function withdrawLP() public {
    uint256 withdrawalamount = stakedAmountLP [ msg.sender ];
    stakedAmountLP [ msg.sender ] = 0;
    stakedTimeLP [ msg.sender ] = 0;
    lpToken.safeTransfer ( msg.sender , withdrawalamount );
  }

  function doesUserHaveLPStaked( address _user ) public view returns ( bool ){
    return stakedAmountLP[ _user] > 0;
  }

  /**
  * @dev deposit VLT Tokens
  * @param _amount value to store
  */
  function depositVLT(uint256 _amount) public {
    stakedAmountVLT [ msg.sender ] += _amount;
    if (stakedTimeVLT [ msg.sender ] == 0) {
      stakedTimeVLT[ msg.sender ] = block.timestamp;
    }
    tierToken.transferFrom( msg.sender , address(this), _amount );
  }

  /**
  * @dev Withdraw VLT Tokens
  */
  function withdrawVLT() public {
    uint256 withdrawalamount = stakedAmountVLT [ msg.sender ];
    stakedAmountVLT [ msg.sender ] = 0;
    stakedTimeVLT[ msg.sender ] = 0;
    tierToken.safeTransfer ( msg.sender , withdrawalamount );
  }

  function userTierLevel(address _user) public view returns ( uint8 ){
    if ( isTeamMember( _user ) ) return 1;
    if ( doesUserHaveLPStaked( _user ) && stakedTimeLP [ _user ] + minimumLockTime < block.timestamp ) return 1;
    if ( stakedTimeVLT[ _user ] == 0  && !doesUserHaveLPStaked( _user )) return 6;
    if ( stakedTimeVLT[ _user ] + minimumLockTime > block.timestamp ) return 6;
    if ( stakedAmountVLT[ _user] < 100000000000000000000 && stakedAmountVLT[ _user] >=50000000000000000000   ) return 5;
    if ( stakedAmountVLT[ _user] < 150000000000000000000 && stakedAmountVLT[ _user] >=100000000000000000000  ) return 4;
    if ( stakedAmountVLT[ _user] < 200000000000000000000 && stakedAmountVLT[ _user] >=150000000000000000000  ) return 3;
    if ( stakedAmountVLT[ _user] >= 200000000000000000000  ) return 2;
    return 6;
  }

  function userDepositTierLevel(address _user) public view returns ( uint8 , uint256 ) {
    uint256 timeSinceDeposit = block.timestamp.sub(stakedTimeVLT[ _user ]);
    uint256 timeSinceDepositLP = block.timestamp.sub(stakedTimeLP[ _user ]);
    if ( isTeamMember( _user ) ) return (1,9999999999);
     if ( doesUserHaveLPStaked( _user )  ) return (1,timeSinceDepositLP);
    if ( stakedAmountVLT[ _user] < 100000000000000000000 && stakedAmountVLT[ _user] >=50000000000000000000   ) return (5, timeSinceDeposit );
    if ( stakedAmountVLT[ _user] < 150000000000000000000 && stakedAmountVLT[ _user] >=100000000000000000000  ) return (4, timeSinceDeposit );
    if ( stakedAmountVLT[ _user] < 200000000000000000000 && stakedAmountVLT[ _user] >=150000000000000000000  ) return (3, timeSinceDeposit );
    if ( stakedAmountVLT[ _user] >= 200000000000000000000  ) return (2,timeSinceDeposit);
    return (6,0);
  }

  function isTeamMember(address _user) public view returns ( bool ){
    for( uint i=0; i<teamCount ; i++) {
      if(team[i] == _user) return true;
    }
    return false;
  }

  modifier onlyTeam() {

    bool team_member = false;
    for( uint i=0; i<teamCount ; i++){
      if( team[i] == msg.sender ) team_member = true;
    }
    require(team_member == true , 'Team Access Only');
    _;
  }
}
