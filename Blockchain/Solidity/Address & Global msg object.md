# Address & Global msg object

## Address

- Remember: All information is public
    - it’s a global database
- Address has two important members:
    - .balance
    - .transfer(amount)
- address myAddress = “0xabc123…”
    - myAddress.balance ⇒ balance in Wei
    - myAddress.transfer(amountInWei) ⇒ Transfers from the smart contract to the address an amount in Wei
   
```
pragma solidity 0.8.1;

contract AddressExample {
    address public myAddress;

    function setAddress(address _address) public {
        myAddress = _address;
    }

    function getBalanceOfAddress() public view returns(uint) {
        return myAddress.balance;
    }
}
```

## Address - Low-Level calls

- There are also low-level calls
    - .send() returns a Boolean, doesn’t cascade exceptions
    - .call.gas().value()() let’s you forward a specific amount of gas, also returns a boolean
- Be-aware of possible re-entrancy dangers
- .send, .transfer both only transfer 2300 gas along
    - Be aware when sending funds to smart contracts
    - More on the later!
    

## Payable Functions Addresses

- A function cannot receive Ether
    - Unless marked as “payable”
        - address payable myAddress
        - function myFunction() public payable { … }
- If a function/address is not marked as payable and receives Ether, it fails

```
pragma solidity ^0.8.1;

contract SendMoneyExample {
    uint public balanceReceived;
    uint public lockedUntil;

    function receiveMoney() public payable {
        balanceReceived += msg.value;
        lockedUntil = block.timestamp + 1 minutes;
    }

    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    function withdrawMoney() public {
        if (lockedUntil < block.timestamp) {
            address payable to = payable(msg.sender);
            to.transfer(getBalance());
        }
    }

    function withdrawMoneyTo(address payable _to) public {
        if (lockedUntil < block.timestamp) {
            _to.transfer(getBalance());
        }
    }
}
```

## Global Objects

- Global Objects help understand where Transactions come from and what happens inside
- Three very important global Properties:
- msg.sender - The address of the Account initialized the Transaction
- msg.value - How much Ether were sent along?
- now - The current timestamp
    - Beware, this can be influenced to a certain degreee from miners
    - Don’t use it for odd/even numbers!

```
pragma solidity ^0.8.1;

contract StartStopUpdateExample {
    address public owner;
    bool public paused;

    constructor() {
        owner = msg.sender;
    }

    function sendMoney() public payable {

    }

    function setPaused(bool _paused) public {
        require(msg.sender == owner, "You are not the owner");
        paused = _paused;
    }

    function withdrawAllMoney(address payable _to) public {
        require(owner == msg.sender, "You cannot withdraw.");
        require(paused == false, "Contract Paused");
        _to.transfer(address(this).balance);
    }

    function destroySmartContract(address payable _to) public {
        require(msg.sender == owner, "You are not the owner");
        selfdestruct(_to);
    }
}
```

## Key Take-Aways

- All information is public
    - Ethers are not stored in your wallet, but on the Blockchain
- Addresses have a balance and can transfer Ether
- Global Objects tell you what happens inside thet Transaction

출처: Solidity를 사용한 이더리움 블록체인 개발자 부트캠프 (2022) [Udemy]
