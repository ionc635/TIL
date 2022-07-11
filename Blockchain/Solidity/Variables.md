# Variables

## Value Types

- Boolean
- int/Uint
- No support for fixed Point numbers
- Address
- Dynamically sized byte arrays (String)
- Enum
- Arrays
- Structs
- Mappings

## All Variables

All Variables are initialized by default

- There is no ‘null’ or ‘undefined’
- int = 0
- Bool = false
- String = “”

Public variables generate a getter with the name of the variable

- You can’t create a function with the same name as the variable yourself

Reference types need a momory location(memory/storage)

## Boolean

- Two values: true or false
- “bool myVar”
- Can negate: “myVar = !myVar”
- Boolean “or” and “and”: || or &&
    - if(myVar && myOtherVar) { … }

```
pragma solidity ^0.8.1;
    contract BooleanExample {
        bool public myBool;

        function setMyBool(bool _myBool) public {
            myBool = _myBool;
    }
}
```

## Integer

- Uint8 to Uint256 in 8bit increments
    - Uint8 from 0 to 255
    - Int7 from -128 to +127
    - 2^8 ⇒ 2**8
    - Uint256 ⇒ 2^256
    - uint is an alias for uint256
- Automatic Wrap Around
    - Uint8 myUint
    - myUint-- ⇒ 256

```
pragma solidity ^0.8.1;

contract IntegerExample {
    uint public myUint;

    function setMyUint(uint _myUint) public {
        myUint = _myUint;
    }
}
```

## Address

- Every Interaction on Ethereum is address based
- Hold 20 byte value (An Ethereum Address)
- Used to transfer ether from smart contracts to the address or from an address to a smart contract
    - .transfor(…).send(…).call.value()().delegatecall()…
- Address and address payable
- Have a member ,,balance’’ which has the balance in Wel

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

## String and Bytes

- Both are special arrays
- String is equal to bytes, but doesn’t have a length or index-access
- Byte for arbitrary length raw data
- String for arbitrary length string(UTF-8) data
- Expensive!

```
pragma solidity 0.8.1;

contract StringExample {
    string public myString = 'hello world';

    function setMyString(string memory _myString) public {
        myString = _myString;
    }
}
```

## Key Take-Aways

- Solidity has serveral typical high-level language variable types
    - All variables are statically typed
- Not all rules of modern development apply to blockchain development
    - Limited resources!
    - Variable initialization
- There are some special types not available in “traditional” language

출처: Solidity를 사용한 이더리움 블록체인 개발자 부트캠프 (2022)[Udemy]
