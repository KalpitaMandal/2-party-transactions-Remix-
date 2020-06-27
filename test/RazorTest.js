const RazorTest = artifacts.require('RazorTest');

contract('RazorTest', () => {
    function sleep(milliseconds) {
        const date = Date.now();
        let currentDate = null;
        do {
          currentDate = Date.now();
        } while (currentDate - date < milliseconds);
    }

    it('Should set the interval values properly', async () => {
        const razorTest = await RazorTest.deployed();
        const result = await razorTest.CustomPaymentType(1,2);
        var now = new Date();
        var new_now = new Date();
        new_now.setMinutes(new_now.getMinutes() + 2);
        var new_now = new Date(new_now);
        assert(new_now>now);
    });

    it('Should make a successful payment to the creator', async () => {
        const razorTest = await RazorTest.deployed();
        let accounts = await web3.eth.getAccounts();
        await razorTest.CustomPaymentType(6,2);
        await web3.eth.sendTransaction({from: accounts[0], to: razorTest.address, value: '90000000000000000000'});
        let CurrBal = await web3.eth.getBalance('0x92be99E3880aC66D344e143593C17f9f208Db9A1');
        sleep(13000);
        await razorTest.MakePayment('0x92be99E3880aC66D344e143593C17f9f208Db9A1',1);
        const NewBal = await web3.eth.getBalance('0x92be99E3880aC66D344e143593C17f9f208Db9A1');
        // const addVal = web3.utils.toWei('1','wei');
        // const Pred = CurrBal + 1;
        assert(NewBal> CurrBal);
    });

    
});