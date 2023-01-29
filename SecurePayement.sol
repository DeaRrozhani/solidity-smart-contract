pragma solidity 0.8.7; 
import "./SafeMath.sol";

contract SecurePayement {

    address agent; 
    address payable payee;
    mapping(address => uint256) deposits;
    uint256 startTime;
    uint256 interestRate;


    modifier onlyAgent() {
        require(msg.sender == agent); 
        _;
    }

    modifier onlyAtTime() {
        require(block.timestamp >= startTime + 60); 
        _;
    }

    modifier onlyAfterTransaction() {
        require(deposits[payee] == 0); 
        _;
    }

    constructor() public {
        agent = msg.sender; 
    }

    function deposit(address payable _payee) public onlyAgent payable {
        payee = _payee;
        startTime = block.timestamp;
        uint256 amount = msg.value;
        deposits[_payee] = SafeMath.add(deposits[_payee], amount);
    }

    function withdraw() public onlyAgent onlyAtTime {

        uint256 payement = deposits[payee]; 
        deposits[payee] = 0;
        payee.transfer(payement); 
    }

    function changeAgent(address _newAgent) public onlyAgent onlyAfterTransaction{
        agent = _newAgent; 
    }

}
