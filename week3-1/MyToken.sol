// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

interface IERC20 {
//   // 当前合约总量
  function totalSupply() external view returns (uint256);

  // “account” 账户的余额
  function balanceOf(address account) external view returns (uint256);

  // 把当前的余额由调用者发送到 另一个账户
  function transfer(address recipient, uint256 amount) external returns (bool);

  //  当前账户对目标账户授权额度
  function allowance(address owner, address spender) external view returns (uint256);

  // 授权
  function approve(address spender, uint256 amount) external returns (bool);

  function transferFrom(
      address sender,
      address recipient,
      uint256 amount
    ) external returns (bool);

  // 转账
  event Transfer(address indexed from, address indexed to, uint256 value);
  // 授权
  event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract MyToken is IERC20 {
    string public name;// 代币名字
    string public symbol; // 简称
    uint256 public  decimals;// 精度
    uint256 public totalSupply; // 发行总量
    // 每个地址的余额
    mapping(address => uint256) private balances;
    // 授权额度
    mapping(address => mapping(address => uint256)) private allowances;

    // 构造函数初始化数据
    constructor () {
        name = "DYY Token";
        symbol = "DYY";
        decimals = 18;
        mint(msg.sender, 10000*10**18);

    }

    // 铸币
    function mint (address _account, uint256 _amount) internal {
        require(_account != address(0),"not to zero address");
        require(_amount != 0,"not mint zero token");
        totalSupply = totalSupply + _amount;
        balances[_account] = balances[_account] + _amount;
        emit Transfer(address(0), msg.sender, _amount);
    }


    function balanceOf(address _account) public view returns (uint256) {
        return balances[_account];
    }

    function transfer(address _recipient, uint256 _amount) public returns (bool) {
        _transfer(msg.sender, _recipient, _amount);
        return true;
    }

    function _transfer(address _sender, address _recipient, uint256 _amount) internal {
        require(_sender != address(0), "ERC20: transfer from the zero address");
        require(_recipient != address(0), "ERC20: transfer to the zero address");

        balances[_sender] = balances[_sender] - _amount;
        balances[_recipient] = balances[_recipient] + _amount;
        emit Transfer(_sender, _recipient, _amount);
    }

    function withdraw() public {
        (bool success, ) = msg.sender.call{value: balances[msg.sender]}(new bytes(0));
        require(success, 'ETH transfer failed');

        balances[msg.sender] = 0;
    }


    // 额度
    function allowance(address _owner, address _spender) public view returns (uint256) {
        return allowances[_owner][_spender];
    }

    function approve(address _spender, uint256 _value) public returns (bool) {
        _approve(msg.sender, _spender, _value);
        return true;
    }
    function _approve(address _owner, address _spender, uint256 _value) internal {
        require(_owner != address(0), "ERC20: approve from the zero address");
        require(_spender != address(0), "ERC20: approve to the zero address");

        allowances[_owner][_spender] = _value;
        // emit Approval(_owner, _spender, _value);
    }

     function transferFrom(address _sender, address _recipient, uint256 _amount) public returns (bool) {
        _transfer(_sender, _recipient, _amount);
        _approve(_sender, msg.sender, allowances[_sender][msg.sender]  - _amount);
        return true;
    }

    function increaseAllowance(address _spender, uint256 _addedValue) public returns (bool) {
        _approve(msg.sender, _spender, allowances[msg.sender][_spender] + _addedValue);
        return true;
    }

    function decreaseAllowance(address _spender, uint256 _subtractedValue) public returns (bool) {
        _approve(msg.sender, _spender, allowances[msg.sender][_spender] - _subtractedValue);
        return true;
    }

    function burn(address _account, uint256 _value) internal {
        require(_account != address(0), "ERC20: burn from the zero address");

        balances[_account] = balances[_account] - _value;
        totalSupply = totalSupply - _value;
        emit Transfer(_account, address(0), _value);
    }
    function burnFrom(address _account, uint256 _amount) internal {
        burn(_account, _amount);
        _approve(_account, msg.sender, allowances[_account][msg.sender] - _amount);
    }
}