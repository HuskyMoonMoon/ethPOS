pragma solidity ^0.4.24;

import "../libraries/Structs.sol";
import "./EmployeeContract.sol";

contract BranchContract {

    address public office;

    Structs.Branch[] branches;
    mapping (address => Structs.Branch) branchByAddress;
    mapping (uint => address) employeesInBranch;

    EmployeeContract employeeContract;

    constructor(address _employeeContractAddress, address _officeAddress, string memory name, string memory stressAddress) public {
        employeeContract = EmployeeContract(_employeeContractAddress);
        office = _officeAddress;
        Structs.Branch memory newBranch = Structs.Branch(_officeAddress, name, stressAddress, true);
        branchByAddress[_officeAddress] = newBranch;
        branches.push(newBranch);
    }

    function getOffice() public view returns(address) {
        return office;
    }

    function assignEmployeeToBranch(address branchWalletAddress, uint employeeId) public {
        Structs.Branch memory branch = branchByAddress[branchWalletAddress];
        require(branch.exist && employeeContract.isEmployeeExist(employeeId));
        employeesInBranch[employeeId] = branchWalletAddress;
    }

    function addNewBranch(address branchWalletAddress, string memory name, string memory stressAddress) public {
        Structs.Branch memory newBranch = Structs.Branch(branchWalletAddress, name, stressAddress, true);
        branchByAddress[branchWalletAddress] = newBranch;
        branches.push(newBranch);
    }

    function editDetailBranch(address branchWalletAddress, string memory name, string memory streetAddress) public {
        branchByAddress[branchWalletAddress].name = name;
        branchByAddress[branchWalletAddress].streetAddress = streetAddress;

        for(uint i = 0; i < branches.length; i++) {
            if(branches[i].branchWalletAddress == branchWalletAddress) {
                branches[i].name = name;
                branches[i].streetAddress = streetAddress;
            }
        }
    }

    function getBranch(address branchWalletAddress) public view returns(address, string memory, string memory) {
        return (
            branchByAddress[branchWalletAddress].branchWalletAddress,
            branchByAddress[branchWalletAddress].name,
            branchByAddress[branchWalletAddress].streetAddress
        );
    }

    function getBranchLength() public view returns(uint) {
        return branches.length;
    }

    function getBranchFromlength(uint length) public view returns(address, string memory, string memory) {
        return (
            branches[length].branchWalletAddress,
            branches[length].name,
            branches[length].streetAddress
        );
    }

}