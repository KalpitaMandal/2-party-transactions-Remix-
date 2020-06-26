pragma solidity ^0.5.0;

contract RazorTest{
    address payable creator;
    uint256 amount;
    uint256 deadline;
    uint256 interval;
    uint256 Interval_duration;
    
    function() external payable { } //fallback function to receive payments from user to contract
    
    function CustomPaymentType(uint256 _interval, uint256 _no_of_intervals) public returns(uint256) {
        // select among the options to set the payment type:
        // 1 => minutes
        // 2 => hourly
        // 3 => day wise
        // 4 => month wise
        interval=_interval;
        Interval_duration=_no_of_intervals;
        if(_interval == 1){
            deadline= now + (_no_of_intervals* 1 minutes);      // Calculating deadline according to the users inputs
            return deadline;
        }
        else if(_interval == 2){
            deadline= now + (_no_of_intervals* 1 hours);
            return deadline;
        }
        else if(_interval == 3){
            deadline= now + (_no_of_intervals* 1 days);
            return deadline;
        }
        else if(_interval == 4){
            deadline= now + (_no_of_intervals* 30 days);
            return deadline;
        }
        else deadline = now + (_no_of_intervals * 10 seconds); // For testing the working of the code faster
    }
    
    function MakePayment(address payable _to, uint256 _amount) public {
        require(msg.sender.balance>_amount);            // Checking for balance to be greater than the value 
        // require(msg.sender!=_to);                    // For making transfer possible only for the consumers
        require(now>deadline);                          // Checking if it's time to make the payment
        _to.transfer(_amount);
        CustomPaymentType(interval,Interval_duration);  // Calls the function to continuously check for payment times and block payments during the other times
    }
}
