pragma solidity ^0.4.24;

import "../libraries/Structs.sol";

contract ProductContract {

    Structs.Product[] public products;
    mapping (uint => Structs.Product) productsById;

    function addNewProduct(uint id, string memory name, uint cost, uint price) public {
        Structs.Product memory newProduct = Structs.Product(id, name, cost, price, true);
        productsById[id] = newProduct;
        products.push(newProduct);
    }

    function editDetailProduct(uint id, string memory name, uint cost, uint price) public {
        productsById[id].name = name;
        productsById[id].cost = cost;
        productsById[id].price = price;

        for(uint i = 0; i < products.length; i++) {
            if(products[i].id == id) {
                products[i].name = name;
                products[i].cost = cost;
                products[i].price = price;
            }
        }
    }

    function getProducts(uint id) public view returns(uint, string memory, uint, uint) {
        return (
            productsById[id].id,
            productsById[id].name,
            productsById[id].cost,
            productsById[id].price
        );
    }

    function getNameProduct(uint id) public view returns(string memory) {
        return(productsById[id].name);
    }

    function getPriceProduct(uint id) public view returns(uint) {
        return(productsById[id].price);
    }

    function getProductsLength() public view returns(uint) {
        return products.length;
    }

    function getIdProductFromLength(uint length) public view returns(uint) {
        return products[length].id;
    }

    function getProductFromlength(uint length) public view returns(uint, string memory, uint, uint) {
        return (
            products[length].id,
            products[length].name,
            products[length].cost,
            products[length].price
        );
    }

}