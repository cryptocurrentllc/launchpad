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

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }
    
     /**
     * @dev Throws if called by any account other than the owner.
     */
    

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
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
  // set the token and rate
  function setSetting(IToken token, IToken tierToken, IToken _lpToken, uint256 rate, address issuer, address lp) external;

  // set the sale distribution
  function setDist(uint8 teamPerc, uint8 liquidityPerc, uint8 issuerPerc, uint8 tokenWeight) external;

  // set the managers enable/disable
  function setManager(address manager, bool status) external;

  // add team members
  function addTeam(address[] memory addresses) external;

  // finalized the sale and compute distributions
  // function finalizeSale() external returns(bool);

  // distribute funds
  // function distributeFunds() external returns(bool);
}

library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain`call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: value }(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.staticcall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.delegatecall(data);
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


library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
            // benefit is lost if 'b' is also tested.
            // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
    }

    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator.
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return a % b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a % b;
        }
    }
}

abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor () {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and make it call a
     * `private` function that does the actual work.
     */
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

library SafeERC20 {
    using Address for address;
    function safeTransfer(IToken token, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
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

  mapping(uint8 => uint256)     public raisedTiers;
  mapping(uint8 => uint256)     public participants;

  uint8                         public totalMembers;
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
  
  uint256 public timePaused;

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
    require ( msg.value > minimumPurchase );
    require ( canDeposit == true );

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

  /**
  * rate as follows:
  * 1. Tier 1 = 200+ LP @ base alloc + 6%
  * 2. Tier 2 = 200  @ base alloc + 4%
  * 2. Tier 3 = 150+ @ base alloc + 3%
  * 3. Tier 4 = 100+ @ base alloc + 2%
  * 4. Tier 5 = 50+ @ base alloc  ( can purchase earlier than public )
  * 5. Tier 6 = <50 @ base alloc
  **/
  function _computeTokenShareForPreSale(address _beneficiary, uint256 _amount) internal {
    uint256 _tierBalance = tierToken.balanceOf(_beneficiary).div(10 ** tierToken.decimals());
   // uint256 _lpBalance = lpToken.balanceOf(_beneficiary).div(10 ** lpToken.decimals());

    // Starts at Tier 5
    uint8 currentTier;
    uint256 tierRate;
    uint256 shares = _amount.mul(rate);

    // Tier 1
    if ( checkTier1( _beneficiary ) ) {
      tierRate = 6;
      currentTier = 1;
      shares = _amount.mul((rate*103)/100);
    // Tier 2
    } else if (_tierBalance >= 200 && block.timestamp >= tier2Time) { // tier 2
      tierRate = 4;
      currentTier = 2;
    // Tier 3
    } else if (_tierBalance >= 150 && _tierBalance < 200 && block.timestamp >= tier3Time) { // tier 2
      tierRate = 3;
      currentTier = 3;
    // Tier 4
    } else if (_tierBalance >= 100 && _tierBalance < 150 && block.timestamp >= tier4Time) { // tier 3
      tierRate = 2;
      currentTier = 4;
    // Tier 5
    } else if (_tierBalance >= 50 && _tierBalance < 100 && block.timestamp >= tier5Time) { // tier 4
      tierRate = 1;
      currentTier = 5;
    } else if (teamMembers[_beneficiary]) {
         tierRate = 6;
         currentTier = 1;
    } else {
        revert('Unauthorized Transaction - Main Sale Only');
    } 

    // all team members should be at tier 1
    

    require ( _amount  <=  getMaxBNBSend ( currentTier) + tokenShares[ _beneficiary ] );
    require( currentTier < 6, 'No Tier Token or LP Balance');

    // only tier 1 - 4 can have bonus
    // if (currentTier < 5) {
    //      shares = shares.add(shares.mul(tierRate).div(100));
    //  }

    tokenShares[_beneficiary] = tokenShares[_beneficiary].add(shares);
    senderTiers[_beneficiary] = currentTier;
    participants[currentTier] = participants[currentTier].add(1); // increment by 1
    raisedTiers[currentTier] = raisedTiers[currentTier].add(shares);
    raisedPreSale = raisedPreSale.add(_amount);
    tokens = tokens.add(shares);
    emit TokenAllocated(_beneficiary, shares);
  }

  function computeTier(address _beneficiary, uint256 _amount) public view returns(uint8 tierRate, uint8 currentTier, uint256 tierBalance,  uint256 shares) {
    tierBalance = tierToken.balanceOf(_beneficiary).div(10 ** tierToken.decimals());
    //lpBalance = lpToken.balanceOf(_beneficiary).div(10 ** lpToken.decimals());

    tierRate = 1;
    currentTier = 6;
    shares = _amount.mul(rate);

    if ( checkTier1( _beneficiary )  ) {
      tierRate = 6;
      currentTier = 1;
        shares = _amount.mul( (rate*103)/100 );
    // Tier 2
    } else if (tierBalance >= 200 ) { // tier 2
      tierRate = 4;
      currentTier = 2;
    // Tier 3
    }else if (tierBalance >= 150 && tierBalance < 200) { // tier 2
      tierRate = 3;
      currentTier = 3;
    // Tier 3
    } else if (tierBalance >= 100 && tierBalance < 150) { // tier 3
      tierRate = 2;
      currentTier = 4;
    // Tier 4
    } else if (tierBalance >= 50 && tierBalance < 100) { // tier 4
      tierRate = 1;
      currentTier = 5;
    }
    
   
   
    require ( _amount <= getMaxBNBSend ( currentTier ));
    //if (currentTier < 5) {
    //  shares = shares.add(shares.mul(tierRate).div(100));
    //}
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
    setSchedule ( utctime );
    canDeposit = true;
    canRefund = false;
    canClaim = false;
    stage = SaleStage.SALE;
    emit StatusChanged(stage);
  }
  
  function setSchedule( uint256 utctime ) internal {
      
     mainSale = utctime + 3 hours;
     tier1Time = utctime;
     tier2Time = utctime + 1 hours;
     tier3Time = utctime + 1 hours + 30 minutes;
     tier4Time = utctime + 2 hours;
     tier5Time = utctime + 2 hours + 30 minutes;
      
      
  }
 
  
  
  
  
  function getCurrentUTCTime() public view returns ( uint256 ) {
      return block.timestamp;
  }
  
  function preSaleStarted() public view returns ( bool ) {
  
      return ( block.timestamp >= tier1Time  && tier1Time != 0 );
  }
  
  function mainSaleStarted() public view returns ( bool ) {
  
      return ( block.timestamp >= mainSale  && mainSale != 0 );
  }
  
  function getBaseAllocation() public view returns ( uint256 ) {
      return baseAllocation;
  }
  
  function setBaseAllocation(  uint256 _baseAllocation ) public onlyManagers{
      baseAllocation = _baseAllocation * 1000000000000000000;
  }
  
  function getMaxTierAllocation ( uint256 _tier ) public view returns ( uint256 ){
      require ( _tier > 0 );
      if ( _tier == 1 ) return (((6600 * baseAllocation)/1000)*1000000000000000000);
      if ( _tier == 2 ) return (((4400 * baseAllocation)/1000)*1000000000000000000);
      if ( _tier == 3 ) return (((3300 * baseAllocation)/1000)*1000000000000000000);
      if ( _tier == 4 ) return (((2300 * baseAllocation)/1000)*1000000000000000000);
      if ( _tier == 5 ) return (((1000 * baseAllocation)/1000)*1000000000000000000);
      return ((1 * baseAllocation)*1000000000000000000);
  }
  
  function getMaxBNBSend ( uint256 _tier ) public view returns ( uint256 ){
      require ( _tier > 0 );
      if ( _tier == 1 ) return (((6600 * baseAllocation)/1000)/rate*1000000000000000000);
      if ( _tier == 2 ) return (((4400 * baseAllocation)/1000)/rate*1000000000000000000);
      if ( _tier == 3 ) return (((3300 * baseAllocation)/1000)/rate*1000000000000000000);
      if ( _tier == 4 ) return (((2300 * baseAllocation)/1000)/rate*1000000000000000000);
      if ( _tier == 5 ) return (((1000 * baseAllocation)/1000)/rate*1000000000000000000);
      return ((1 * baseAllocation/rate)*1000000000000000000);
  }
  
  function getIDOContractTokenBalance() public view returns ( uint256 ){
      
      return token.balanceOf(address(this));
  }
  
  function checkTier1( address _beneficiary ) public view returns ( bool ){
      
      IDOManager _manager = IDOManager( owner() );
      return ( _manager.isUserStaked ( _beneficiary ) || teamMembers[_beneficiary] );
      
      
  }
  
  function getCurrentTier() public view returns ( uint8 ){
    // Defaults to IDO did not start yet
    uint8 currentTier = 0; 
    
       // Tier 1
    if (  block.timestamp >= tier1Time ) {
     
      currentTier = 1;
   
    // Tier 2
    } else if ( block.timestamp >= tier2Time) { // tier 2
     
      currentTier = 2;
    // Tier 3
    } else if ( block.timestamp >= tier3Time) { // tier 2
     
      currentTier = 3;
    // Tier 4
    } else if ( block.timestamp >= tier4Time) { // tier 3
     
      currentTier = 4;
    // Tier 5
    } else if (  block.timestamp >= tier5Time) { // tier 4
     
      currentTier = 5;
    } else if ( block.timestamp >= mainSale ) {
         
         currentTier = 6;
    } else if ( tier1Time == 8888888888 ) {
         
         currentTier = 255; // IDO is Paused
    } 
      
    return currentTier;
      
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
    emit StatusChanged(stage);
    issuerLock = block.timestamp + (1 days * 365); // total of 1 year
  }

  // manager should be able to withdraw
  // TODO: team issuance
  function sendFunds() public onlyManagers {
    require(!issuerWithdrawn, 'Funds are withdrawn');
    _sendValue(payable(lp), liquidityShare);
    _sendValue(payable(issuer), issuerShare);
    token.safeTransfer(lp, lpTokenShare);
    issuerWithdrawn = true;
    stage = SaleStage.COMPLETED;
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
  function claim(IToken _token) public nonReentrant allowClaim {
    address _claimer = _msgSender();
    require(tokenShares[_claimer] > tokenClaims[_claimer], "No More Tokens");
    uint256 shares = tokenShares[_claimer];
    tokenClaims[_claimer] = tokenClaims[_claimer].add(shares);
    _token.safeTransfer(_claimer, shares);
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

  /**
  * ISSUER FUNCTIONS
  **/
  modifier onlyIssuer() {
    require(issuer == msg.sender, 'Issuer Access Only');
    _;
  }

  // issuer can deposit anytime
  function issuerDeposit(IToken _token, uint256 _amount) public onlyIssuer {
    _token.safeTransfer(address(this), _amount);
  }

  // issuer can withdraw / emergency withdraw tokens if the the contract is shut off
  // issuer can withdraw if the holders can refund
  function issuerClaim(IToken _token, uint256 _amount) public onlyIssuer {
    _token.safeTransfer(msg.sender, _amount);
  }

  // issuer can claim the bnb/eth after a year
  function issuerWithdraw() public onlyIssuer {
    // once the issuer can withdraw their 37% share
    if (!issuerWithdrawn && issuerShare > 0 && liquidityShare > 0 && lpTokenShare > 0) {
      _sendValue(payable(issuer), issuerShare);
      _sendValue(payable(lp), liquidityShare); // 100% of the liquidityShare
      token.safeTransfer(lp, lpTokenShare); // 97% of the tokens
      issuerWithdrawn = true;
    }
    // after a year
    if (block.timestamp >= issuerLock) {
      _sendValue(payable(issuer), address(this).balance);
    }
  }

  // burn tokens
  function issuerBurn(address _burnAddress, uint256 _amount) public onlyIssuer {
    require(claimed >= tokens, 'Issuer Cannot Burn Token < Claimed');
    token.safeTransfer(_burnAddress, _amount);
  }

  function _sendValue(address payable recipient, uint256 amount) internal {
    require(address(this).balance >= amount, 'Insufficient Balance');
    (bool success, ) = recipient.call{ value: amount }("");
    require(success, 'Unable To Send, Reverted');
  }

}



contract IDOManager is Ownable {

  event ContractCreated(address indexed);

  address public manager;
  address[] public team;
  uint256 public teamCount;
  bool public tokensSet;

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
   mapping ( address => uint256 ) public stakedAmount;
    
   uint256 public minimumLP;

  struct ContractDetails {
    string    name;
    address   issuer;
    uint8     version;
  }

  mapping (address => ContractDetails) public contracts;
  mapping (uint256 => address) public contractAddresses;






  // deploy the ido contract
  function deployIDO(string memory _name, address _issuer, address _manager, uint256 _rate, uint256 _baseAllocation, IToken _idotoken, uint256 _minimumPurchase, uint8 _version) public onlyTeam returns(address) {

    require ( tokensSet );
    
    
    IDOCrowdsale newIDO = new IDOCrowdsale(_issuer, _manager, _rate , tierToken, lpToken, lpaddress, _baseAllocation, _idotoken, _minimumPurchase  );

    newIDO.setManager(manager, true);
    newIDO.setDist(teamPerc, liquidityPerc, issuerPerc, tokenWeight);
    newIDO.addTeam(team);

    address _newIDOAddress = address(newIDO);
    emit ContractCreated(_newIDOAddress);
    contracts[_newIDOAddress] = ContractDetails(_name, _issuer, _version);
    contractAddresses[contractCount] = _newIDOAddress;
    contractCount++;
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
  }
  
  function getTeam()public view returns( address  [] memory){
    return team;
  }
  
  
  function setMinimumLP ( uint256 _minLP ) public onlyTeam {
        
        minimumLP = _minLP;
        
    }
    
     /**
     * @dev deposit LP Tokens
     * @param _lptokens value to store
     */
    function deposit(uint256 _lptokens) public {
        
        require ( _lptokens >= minimumLP );
        stakedAmount [ msg.sender ] += _lptokens;
        lpToken.transferFrom( msg.sender , address(this), _lptokens );
        
    }

    /**
     * @dev Withdraw LP Tokens 
     */
    function withdrawal() public {
        uint256 withdrawalamount = stakedAmount [ msg.sender ];
        stakedAmount [ msg.sender ] = 0;
        lpToken.transfer ( msg.sender , withdrawalamount );
    }
    
    function isUserStaked( address _user ) public view returns ( bool ){
        
        if ( stakedAmount[ _user] >0 ) {return true;} else { return false; }
        
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
