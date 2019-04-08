pragma solidity ^0.4.24;

import "../libraries/Structs.sol";
import "./ProductContract.sol";
import "./BranchContract.sol";

contract InventoryContract {

    ProductContract productContract;
    BranchContract branchContract;

    address public office;

    Structs.InventoryTransaction[] inventoryTransactions;
    Structs.InventoryTransactionDetail[] inventoryTransactionDetail;

    mapping (address => mapping (uint => Structs.InventoryTransactionDetail)) transactionDetailByBranchAndProduct;
    mapping (uint => Structs.InventoryTransactionDetail) transactionDetailByProduct;
    mapping (address => mapping (uint => uint)) remainingProductsInBranch;

    address[] orderers;
    address[] receivers;
    address[] sendBack;

    mapping (address => mapping (uint => uint)) orders;
    mapping (address => mapping (uint => uint)) send;
    mapping (address => mapping (uint => uint)) receive;
    mapping (address => mapping (uint => uint)) sendBacks;
    mapping (address => mapping (uint => uint)) receiveBack;

    mapping (address => mapping (uint => uint)) officeOrder;
    mapping (address => mapping (uint => uint)) officeReceive;

    constructor(address _productContractAddress,address _branchContractAddress) public {
        productContract = ProductContract(_productContractAddress);
        branchContract = BranchContract(_branchContractAddress);
        office = branchContract.getOffice();
    }

    function saleProducts(address saler, uint id, uint amount) public returns(uint) {
        if(remainingProductsInBranch[saler][id] >= amount) {
            uint price = productContract.getPriceProduct(id);
            uint sum = price*amount;
            decreaseProductInBranch(saler, id, amount);
            return sum;
        }
    }

    function orderProduct(address orderer, uint id, uint amount) public {
        orderers.push(orderer);
        orders[orderer][id] += amount;
    }

    function officeCheckOrder() public view returns(string memory, address) {

        for(uint i = 0; i < orderers.length; i++) {

            if(orderers[i] != address(0)) {
                return("YES", orderers[i]);
            }

        }

    }

    function officeGetOrder(address orderer, uint id) public view returns(uint, string memory, uint) {
        string memory name = productContract.getNameProduct(id);
        uint amount = orders[orderer][id];

        if(amount != 0) {
            return(id, name, amount);
        }

    }

    function editOrder(address orderer, uint id, uint amount) public {
        orders[orderer][id] = amount;
    }

    function deleteOrder(address orderer, uint id) public {
        orders[orderer][id] = 0;
    }

    function deleteAllOrder(address orderer) public {

        for(uint i = 0; i < orderers.length; i++) {

            if(orderers[i] == orderer) {
                delete orderers[i];
            }

        }

    }

    function officeCheckAmount(address receiver, uint id) public view returns(uint, string memory, string memory) {
        uint amount = orders[receiver][id];
        string memory name = productContract.getNameProduct(id);

        if(remainingProductsInBranch[office][id] < amount) {
            return(id, name, "insufficient");
        }

    }

    function sendProduct(address receiver) public returns(string memory) {
        uint length = productContract.getProductsLength();

        for(uint i = 0; i < length; i++) {
            uint id = productContract.getIdProductFromLength(i);
            uint amount = orders[receiver][id];

            if(amount != 0) {
                delete orders[receiver][id];
                send[receiver][id] = amount;
                decreaseProductInBranch(office, id, amount);
            }

        }

        for(uint j = 0; j < orderers.length; j++) {

            if(orderers[j] == receiver) {
                delete orderers[j];
            }

        }

        receivers.push(receiver);

    }

    function checkForReceiver(address myAddress) public view returns(string memory) {

        for(uint i = 0; i < receivers.length; i++) {

            if(receivers[i] == myAddress) {
                return("true");
            }

        }

    }

    function receiverGetProduct(address receiver, uint id) public view returns(uint, string memory, uint) {
        string memory name = productContract.getNameProduct(id);
        uint amount = send[receiver][id];

        if(amount != 0) {
            return(id, name, amount);
        }

    }

    function receiveProduct(address receiver) public {
        uint length = productContract.getProductsLength();
        for(uint i = 0; i < length; i++) {
            uint id = productContract.getIdProductFromLength(i);
            uint amount = send[receiver][id];
            if(amount != 0) {
                delete send[receiver][id];
                increaseProductInBranch(receiver, id, amount);
                receive[receiver][id] = amount;
            }
        }

        for(uint j = 0; j < receivers.length; j++) {
            if(receivers[j] == receiver) {
                delete receivers[j];
            }
        }

    }

    function checkBeforeSendBack(address sender, uint id, uint amount) public view returns(string memory){
        if (remainingProductsInBranch[sender][id] < amount) {
            return ("insufficient");
        }
    }

    function sendBackProduct(address sender, uint id, uint amount) public returns(string memory) {
            sendBacks[sender][id] += amount;
            remainingProductsInBranch[sender][id] -= amount;
            sendBack.push(sender);
    }

    function officeCheckSendBack() public view returns(string memory, address) {
        for(uint i = 0; i < sendBack.length; i++) {

            if(sendBack[i] != address(0)) {
                return("YES",sendBack[i]);
            }
        }

    }

    function officeGetFromSendBack(address sender, uint id) public view returns(uint, string memory, uint) {
        string memory name = productContract.getNameProduct(id);
        uint amount = sendBacks[sender][id];
        if(amount != 0) {
            return(id, name, amount);
        }
    }

    function officeEditSendBack(address sender, uint id, uint amount) public {
        sendBacks[sender][id] = amount;
    }

    function officeReceiveFromSendBack(address sender) public {
        uint length = productContract.getProductsLength();

        for(uint i = 0; i < length; i++) {
            uint id = productContract.getIdProductFromLength(i);
            uint amount = sendBacks[sender][id];

            if(amount != 0) {
                delete sendBacks[sender][id];
                receiveBack[sender][id] = amount;
                increaseProductInBranch(office, id, amount);
            }

            for (uint j = 0; j < sendBack.length; j++) {

                if (sendBack[j] == sender) {
                    delete sendBack[j];
                }

            }

        }

    }

    function addProductToStockOffice(uint idProduct, uint amount) public {
        remainingProductsInBranch[office][amount] += amount;
    }

    function increaseProductInBranch(address branchWalletAddress, uint id, uint amount) public {
        remainingProductsInBranch[branchWalletAddress][id] += amount;
    }

    function decreaseProductInBranch(address branchWalletAddress, uint id, uint amount) public {
        remainingProductsInBranch[branchWalletAddress][id] -= amount;
    }

}