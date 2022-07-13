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

## Global Objects

- Global Objects help understand where Transactions come from and what happens inside
- Three very important global Properties:
- msg.sender - The address of the Account initialized the Transaction
- msg.value - How much Ether were sent along?
- now - The current timestamp
    - Beware, this can be influenced to a certain degreee from miners
    - Don’t use it for odd/even numbers!

## Key Take-Aways

- All information is public
    - Ethers are not stored in your wallet, but on the Blockchain
- Addresses have a balance and can transfer Ether
- Global Objects tell you what happens inside thet Transaction

출처: Solidity를 사용한 이더리움 블록체인 개발자 부트캠프 (2022) [Udemy]
