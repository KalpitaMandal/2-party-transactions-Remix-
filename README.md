# Recurring Transaction
There are lots of digital content creators/consultants across the globe. A big issue with them is late payment from consumers. They do the work but they aren't sure whether they will be paid on time. A solution for this problem is a recurring platform for freelancers where project owners can streamline the payment on hourly, weekly, monthly basis.

The solution code provided can be tested in the following ways:
- **Remix Ide:** This is an easier method where remix ide UI can be used for the testing of the code.
  - For running the code simply paste the contract from contracts/RazorTest.sol and paste it on remix.
  - First we have to send ether to our smart contract so that the contract can do the transaction to the creator.
  - First deploy the contract and dropdown the instance of your contract.
  - Fill the value field above the deploy button with some amount (ether) to send your contract. The contract should have the fallback function so that the contract can receive payments from any address. Click the transact button, under the low level interactions section of your contract instance.
  - Go to the CustomPaymentType function and input the plan(hourly, daily or monthly) and the duration between the payments(eg. 2 in this field and monthly plan will make payments in a bimonthly fashion). 
  - Go to the MakePayment function and input the address of the creator/consultant and the value you want to send. This function will only transfer funds when the interval is up and once one payment is done the function will not allow further transactions untill the next interval is up.
  - Metamask is another methos using which we can test the working of the contract. For Metamask, change the environment to "Injected Web3" and connect metamask with remix on prompt. Follow the same steps as for JavaScriptVM for running the contract.
- **Truffle suite:** This method gives a bit more control to the user and an insight into the working.
  - Install truffle in your working directory : 
  ```shell
  npm install -g truffle
  ```
  - Then run the command and follow the promts to setup.
  ```shell
  truffle init
  ``` 
  This command gets all the necessary files for running truffle suite on your system.
  - Paste the contract on any editor supporting solidity (I am using Visual Studio Code) and save the contract into the contracts folder as "RazorTest.sol".
  - Go to the migrations folder and save the following code as 2_razor_migrations.js. This code will help us deploy the contract to the network. 
  ```javascript
  const RazorTest = artifacts.require("RazorTest");

  module.exports = function(deployer) {
     deployer.deploy(RazorTest);
  };
  ```
  - We will not be installing ganache client separately as truffle provides inbuilt ganache client.
  - Run the following command to run the ganache client.
  ```shell
  truffle develop
  ```
  You will see 10 account addresses and their private keys displayed.
  - Before deploying the contract to the network, we will test it's working by saving the following testcode as RazorTest.js in the test folder.
  ```javascript
  const RazorTest = artifacts.require('RazorTest');

  contract('RazorTest', () => {

      function sleep(milliseconds) {              //function to sleep so that the interval has expired before testing the MakePayment function
          const date = Date.now();
          let currentDate = null;
          do {
            currentDate = Date.now();
          } while (currentDate - date < milliseconds);
      }

      it('Should set the interval values properly', async () => {       //Checking the CustomPaymentType function
          const razorTest = await RazorTest.deployed();
          const result = await razorTest.CustomPaymentType(1,2);
          var now = new Date();
          var new_now = new Date();
          new_now.setMinutes(new_now.getMinutes() + 2);
          var new_now = new Date(new_now);
          assert(new_now>now);
      });

      it('Should make a successful payment to the creator', async () => {         //Checking the MakePayment function
          const razorTest = await RazorTest.deployed();
          let accounts = await web3.eth.getAccounts();
          await razorTest.CustomPaymentType(6,2);                                 //Assigning the interval to be 10 seconds for faster testing of the contract
          await web3.eth.sendTransaction({from: accounts[0], to: razorTest.address, value: '90000000000000000000'}); 
          let CurrBal = await web3.eth.getBalance('0x92be99E3880aC66D344e143593C17f9f208Db9A1');
          sleep(13000);
          await razorTest.MakePayment('0x92be99E3880aC66D344e143593C17f9f208Db9A1',1);
          const NewBal = await web3.eth.getBalance('0x92be99E3880aC66D344e143593C17f9f208Db9A1');
          assert(NewBal>CurrBal);
      }); 
  });
  ```
  - To test the working of the contract, navigate to the test folder from a new terminal and type the following command.
  ```shell
  truffle test
  ```
  - To compile the contract type the following command. This will compile all the contracts placed in the contracts folder.
  ```shell
  > truffle compile
  ```
  - To deploy the contract to the network type the following command. The --reset command will replace all the older versions of the contracts deployed.
  ```shell
  > truffle migrate --reset
  ```
  This command will deploy the contract and reveal the address of the contract like so:
  ```shell
  Starting migrations...
  ======================
  > Network name:    'develop'
  > Network id:      5777
  > Block gas limit: 6721975 (0x6691b7)


  1_initial_migration.js
  ======================

     Replacing 'Migrations'
     ----------------------
     > transaction hash:    0x8b90a17957dd78f46574aea5e6b053f52b3b97337327f0e741497e8b9f20da69
     > Blocks: 0            Seconds: 0
     > contract address:    0xc75898457dB7DC7ed9118cB156c6Fd9b9d4A0325
     > block number:        1
     > block timestamp:     1593257860
     > account:             0x46C18767D35C3cf19a9aC0dD6552fD0d133DC9a1
     > balance:             99.9967165
     > gas used:            164175 (0x2814f)
     > gas price:           20 gwei
     > value sent:          0 ETH
     > total cost:          0.0032835 ETH


     > Saving migration to chain.
     > Saving artifacts
     -------------------------------------
     > Total cost:           0.0032835 ETH


  2_razor_migrations.js
  =====================

     Replacing 'RazorTest'
     ---------------------
     > transaction hash:    0x7922935a4fbf1baf2f4cb32974270ef0feb75cb735360fb14b8461826abd1968
     > Blocks: 0            Seconds: 0
     > contract address:    0xD6Cd94571239d5ADE176468B18351ed4ebd70DFD
     > block number:        3
     > block timestamp:     1593257860
     > account:             0x46C18767D35C3cf19a9aC0dD6552fD0d133DC9a1
     > balance:             99.9923047
     > gas used:            178249 (0x2b849)
     > gas price:           20 gwei
     > value sent:          0 ETH
     > total cost:          0.00356498 ETH


     > Saving migration to chain.
     > Saving artifacts
     -------------------------------------
     > Total cost:          0.00356498 ETH


  Summary
  =======
  > Total deployments:   2
  > Final cost:          0.00684848 ETH


  truffle(develop)>
  ```
  - Type the following command to make an instance of your contract which we will be using further for transactions.
  ```shell
  >let razor = await RazorTest.deployed()
  >razor
  ```
  - Next we will get the list of accounts for the transactions. Type the following command for the same.
  ```shell
  > let accounts = await web3.eth.getAccounts()
  > accounts
  ```
  - Now before calling any function we will deposit some ethers into the contract for the transactions using the following command. (sends 10 ethers to the contract)
  ```shell
  > await web3.eth.sendTransaction({from: accounts[0], to: razor.address, value: '10000000000000000000'})
  ```
  - Now type the following command for setting interval and duration between interval.
  ```shell
  > razor.CustomPaymentType(1,1)
  ```
  - Next type the following command to call the MakePayment function to transfer funds to the creator/consultant. The address of the account is to be pasted here in single quotes. Once the function is carried out we have to wait for the interval to be expired before we can call this function again, meanwhile if the function is called, error will be observed.
  ```shell
  > razor.MakePayment('0x92be99E3880aC66D344e143593C17f9f208Db9A1',1) 
  ```
  - To check if the function worked properly we will check the balance of the target account.
  ```shell
  > await web3.eth.getBalance(accounts[9])
  ```
This function will continuously make payments to the creator on behalf of the consumer when the MakePayment function is called. The function is open to both the creator and the consumer, hence the creator can also get the funds when appropriate time has passed.
