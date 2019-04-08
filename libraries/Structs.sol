pragma solidity ^0.4.24;

library Structs {

    struct InventoryTransaction {
        string transactionId;
        address branchWalletAddress;
        string transactionType;
        string transactionStatus;
        bool exist;
    }

    struct InventoryTransactionDetail {
        string transactionId;
        uint productId;
        uint amount;
        uint cost;
        uint price;
    }

    struct Branch {
        address branchWalletAddress;
        string name;
        string streetAddress;
        bool exist;
    }

    struct Product {
        uint id;
        string name;
        uint cost;
        uint price;
        bool exist;
    }

    struct Employee {
        uint id;
        string username;
        string password;
        // uint createdTime;
        bool exist;
    }

}