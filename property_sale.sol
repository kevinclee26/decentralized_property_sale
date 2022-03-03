pragma solidity ^0.5.0;

contract property_sale {
    string _property_address;
    uint _ask_price;
    bool _inspected=false;
    address payable public owner=msg.sender; 

    mapping(address => uint256) applications;
    // mapping(address => uint) offers;

    constructor(string memory property_address, uint ask_price) public {
        _property_address=property_address;
        _ask_price=ask_price;
    }

    function get_address() view public returns(string memory) {
        return _property_address;
    }

    function inspect() public {
        _inspected=true;
    }

    function get_inspect_status() view public returns(bool) {
        return _inspected;
    }

    function transfer_property(address payable buyer) public {
        require(_inspected==true);
        owner=buyer;
    }

    function apply_property() public {
        applications[msg.sender]=now;
    }

    function lender_approve(address payable approved) public payable {
        require(_inspected==true);
        require(applications[approved]>0);
        require(msg.value>_ask_price);
        // lender approves credit

        // calculate overpayment
        uint overpayment=msg.value-_ask_price;
        owner.transfer(_ask_price);
        msg.sender.transfer(overpayment);

        owner=approved;
    }

    function get_application_date(address buyer) view public returns(uint256) {
        return applications[buyer];
    }
}