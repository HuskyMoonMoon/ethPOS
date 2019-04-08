pragma solidity ^0.4.24;

library StringUtil {
    function equals(string memory s1, string memory s2) public pure returns(bool) {
        return keccak256(abi.encodePacked(s1)) == keccak256(abi.encodePacked(s2));
    }
}

