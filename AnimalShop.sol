//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "Interger overflow");
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(a >= b, "Interger underflow");
        uint256 c = a - b;
        return c;
    }
}

contract AnimalShop is SafeMath {
    address owner;
    uint256 duration;
    mapping(string => bool) allowedPets;
    mapping(string => uint256) pets;
    string[] private allPets;
    string[] private allCustomers;

    struct Customer {
        string gender;
        uint256 age;
        string pet;
        uint256 cId;
        uint256 time;
    }

    mapping(string => Customer) private Customers;

    constructor() public {
        owner = msg.sender;

        allowedPets["parrot"] = true;
        allowedPets["rabbit"] = true;
        allowedPets["fish"] = true;
        allowedPets["cat"] = true;
        allowedPets["dog"] = true;

        pets["parrot"] = 0;
        pets["rabbit"] = 0;
        pets["fish"] = 0;
        pets["cat"] = 0;
        pets["dog"] = 0;
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "Only Shop Owner is authorized");
        _;
    }
    modifier onlyAllowed(string memory _animal) {
        require(allowedPets[_animal], "Animal provided is not available");
        _;
    }
    modifier inTime(string memory _customer) {
        duration = Customers[_customer].time + 5 minutes;
        require(block.timestamp <= duration, "Deadline to return your pet is over");
        _;
    }

    function isCustomer(string memory _name) internal returns (bool) {
        if (allCustomers.length == 0) return false;

        return keccak256(bytes(_name)) == keccak256(bytes(allCustomers[Customers[_name].cId]));
    }
    function addPets(string memory _animal, uint256 _amount) public onlyOwner onlyAllowed(_animal) {
        pets[_animal] = pets[_animal] + _amount;
    }
    function buyPet(string memory _customer,
    uint _cAge,
    string memory _cGender,
    string memory _animal)
    public onlyAllowed(_animal)
    returns(bool successfulTransaction) {

        require(pets[_animal] > 0, "Animal no longer in stock");

        if (isCustomer(_customer)) {
            require(keccak256(bytes(Customers[_customer].pet)) == keccak256(bytes("RETURNED")),
            "Only One pet for a Lifetime");

        } 

        Customers[_customer].gender = _cGender;
        Customers[_customer].age = _cAge;
        Customers[_customer].pet = _animal;
        Customers[_customer].time = block.timestamp;

        pets[_animal] = pets[_animal]-1;
        return true;
    }

    function returnPet(string memory _customer, string memory _pet) inTime(_customer) public onlyAllowed(_pet)
    returns(bool successfulReturn) {
        require(isCustomer(_customer), "Not a previous customer!");
        require(keccak256(bytes(Customers[_customer].pet)) == keccak256(bytes(_pet)), "Returning Pet does not match animal purchased");
        Customers[_customer].pet = "RETURNED";
        pets[_pet] = pets[_pet]+1;
        return true;
    }

    function getReceipt(string memory customer) public view returns(uint cAge,
    string memory cGender,
    string memory pet,
    uint timeOfPurchase) {
        return (Customers[customer].age,
        Customers[customer].gender,
        Customers[customer].pet,
        Customers[customer].time);
    }

    function getPetCount(string memory animal) public view returns(uint amount) {
        return(pets[animal]);
    }

    function getInventory() public view returns(uint amount) {
        return(pets["fish"] + pets["cat"] + pets["dog"] + pets["parrot"] + pets["rabbit"]);
    }

}

