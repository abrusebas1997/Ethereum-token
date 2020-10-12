pragma solidity ^0.4.24;

// ----------------------------------------------------------------------------
// Symbol        : SEAR
// Name          : Sebastian Eduardo Abarca Runciman
// Total supply  : 100000
// Decimals      : 2
// Owner Account : 0xf3c4Bf9F77b41d24dC6f6eEa9D2604a2C74AC3c7


//SafeMath uses assert statements to verify the
// correctness of the passed parameters. Should assert
// fail, the function execution will be immediately stopped and all blockchain changes shall be rolled back.
contract SafeMath {

    function safeAdd(uint a, uint b) public pure returns (uint c) {
        c = a + b;
        require(c >= a);
    }

    function safeSub(uint a, uint b) public pure returns (uint c) {
        require(b <= a);
        c = a - b;
    }

    function safeMul(uint a, uint b) public pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }

    function safeDiv(uint a, uint b) public pure returns (uint c) {
        require(b > 0);
        c = a / b;
    }
}
// The ERC20 standard defines a set of functions to be
//implemented by all ERC20 tokens so as to allow
//integration with other contracts, wallets, or marketplaces.

contract ERC20Interface {
    function totalSupply() public constant returns (uint);
    function balanceOf(address tokenOwner) public constant returns (uint balance);
    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
    function transfer(address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}


/**
Contract function to receive approval and execute function in one call
*/
contract ApproveAndCallFallBack {
    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
}

/**
ERC20 Token, with the addition of symbol, name and decimals and assisted token transfers
*/
contract SEARToken is ERC20Interface, SafeMath {
    string public symbol;
    string public  name;
    uint8 public decimals;
    uint public _totalSupply;

    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;


    constructor() public {
        symbol = "SEAR";
        name = "Sebastian Eduardo Abarca Runciman";
        decimals = 2;
        _totalSupply = 100000;
        balances[0xf3c4Bf9F77b41d24dC6f6eEa9D2604a2C74AC3c7] = _totalSupply;
        emit Transfer(address(0), 0xf3c4Bf9F77b41d24dC6f6eEa9D2604a2C74AC3c7, _totalSupply);
    }


    function totalSupply() public constant returns (uint) {
        return _totalSupply  - balances[address(0)];
    }



    function balanceOf(address tokenOwner) public constant returns (uint balance) {
        return balances[tokenOwner];
    }



    // Transfer the balance from token owner's account to account

    function transfer(address to, uint tokens) public returns (bool success) {
        balances[msg.sender] = safeSub(balances[msg.sender], tokens);
        balances[to] = safeAdd(balances[to], tokens);
        emit Transfer(msg.sender, to, tokens);
        return true;
    }



    function approve(address spender, uint tokens) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }



    function transferFrom(address from, address to, uint tokens) public returns (bool success) {
        balances[from] = safeSub(balances[from], tokens);
        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
        balances[to] = safeAdd(balances[to], tokens);
        emit Transfer(from, to, tokens);
        return true;
    }



    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }


    function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
        return true;
    }


    //Deny ethereum
    function () public payable {
        revert();
    }
}
