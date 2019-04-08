pragma solidity ^0.4.24;
contract Numbers {
    uint no_ = 1000000000;

    function getNumbers() public returns(uint) {
        return no_++;
    }

}