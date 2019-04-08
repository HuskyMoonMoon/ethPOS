pragma solidity ^0.4.24;
pragma experimental ABIEncoderV2;


import "../libraries/StringUtil.sol";
import "../libraries/Structs.sol";

contract EmployeeContract {
    Structs.Employee[] employees;
    uint latestEmployeeId = 0;
    mapping (uint => Structs.Employee) employeesByUserId;
    mapping (string => Structs.Employee) employeesByUsername;

    function addEmployee(string  memory username, string memory password) private {
        require (
            !employeesByUsername[username].exist
            && bytes(username).length > 0
            && bytes(password).length > 0
        );

        Structs.Employee memory employee = Structs.Employee(latestEmployeeId, username, password, true);
        employeesByUserId[latestEmployeeId] = employee;
        employeesByUsername[username] = employee;
        latestEmployeeId += 1;
    }

    function getEmployeeById(uint id) public view returns(Structs.Employee memory) {
        Structs.Employee memory employee = employeesByUserId[id];
        require(employee.exist);
        return employee;
    }

    function getEmployeeByUsername(string memory username) public view returns(Structs.Employee memory) {
        Structs.Employee memory employee = employeesByUsername[username];
        require(employee.exist);
        return employee;
    }

    function login(string memory username, string memory password) public view returns(uint) {
        Structs.Employee memory employee = this.getEmployeeByUsername(username);
        require(StringUtil.equals(password, employee.password));
        return employee.id;
    }

    function isEmployeeExist(uint employeeId) public view returns(bool) {
        Structs.Employee memory employee = this.getEmployeeById(employeeId);
        return employee.exist;
    }
}