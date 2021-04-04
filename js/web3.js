
<!DOCTYPE html>
<html>

<head>
    <meta charset='utf-8'>
    <meta http-equiv='X-UA-Compatible' content='IE=edge'>
    <title>Web 3 Demo</title>
    <meta name='viewport' content='width=device-width, initial-scale=1'>

    <script src='node_modules/web3/dist/web3.min.js'></script>
</head>

<body>

   

    <script type="text/javascript">
        
	// This is set to the IDO Contract
	var idosalecontract = "0xBfF89386D062C6040ed1955e180c87dD00bb71aF";
		
	// This is set to the IDO Contracts ABI
	var idoabi =[
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_issuer",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "_operator",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "_rate",
				"type": "uint256"
			},
			{
				"internalType": "contract IERC20",
				"name": "_token",
				"type": "address"
			},
			{
				"internalType": "contract IERC20",
				"name": "_tierToken",
				"type": "address"
			}
		],
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "_admin",
				"type": "address"
			},
			{
				"indexed": true,
				"internalType": "address",
				"name": "_newAdmin",
				"type": "address"
			}
		],
		"name": "AdminChanged",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "_admin",
				"type": "address"
			},
			{
				"indexed": true,
				"internalType": "bool",
				"name": "_status",
				"type": "bool"
			}
		],
		"name": "AdminUpdated",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "_sender",
				"type": "address"
			},
			{
				"indexed": true,
				"internalType": "uint256",
				"name": "_amount",
				"type": "uint256"
			}
		],
		"name": "Deposited",
		"type": "event"
	},
	{
		"inputs": [],
		"name": "enableClaim",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_lpAddress",
				"type": "address"
			}
		],
		"name": "finalizeSale",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_burnAddress",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "_amount",
				"type": "uint256"
			}
		],
		"name": "issuerBurn",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_amount",
				"type": "uint256"
			}
		],
		"name": "issuerDeposit",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_amount",
				"type": "uint256"
			}
		],
		"name": "issuerWithdraw",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "previousOwner",
				"type": "address"
			},
			{
				"indexed": true,
				"internalType": "address",
				"name": "newOwner",
				"type": "address"
			}
		],
		"name": "OwnershipTransferred",
		"type": "event"
	},
	{
		"inputs": [],
		"name": "pauseSale",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_beneficiary",
				"type": "address"
			}
		],
		"name": "purchase",
		"outputs": [],
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "refund",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "_beneficiary",
				"type": "address"
			},
			{
				"indexed": true,
				"internalType": "uint256",
				"name": "_amount",
				"type": "uint256"
			}
		],
		"name": "Refunded",
		"type": "event"
	},
	{
		"inputs": [],
		"name": "renounceOwnership",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "resumePreSale",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "resumeSale",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_admin",
				"type": "address"
			}
		],
		"name": "setAdmin",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_operator",
				"type": "address"
			}
		],
		"name": "setOperator",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_rate",
				"type": "uint256"
			}
		],
		"name": "setRate",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "contract IERC20",
				"name": "_tierToken",
				"type": "address"
			}
		],
		"name": "setTierToken",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "contract IERC20",
				"name": "_token",
				"type": "address"
			}
		],
		"name": "setToken",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "shutOffSale",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "startSale",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "string",
				"name": "_status",
				"type": "string"
			}
		],
		"name": "StatusChanged",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "_beneficiary",
				"type": "address"
			},
			{
				"indexed": true,
				"internalType": "uint256",
				"name": "_amount",
				"type": "uint256"
			}
		],
		"name": "TokenAllocated",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "_beneficiary",
				"type": "address"
			},
			{
				"indexed": true,
				"internalType": "uint256",
				"name": "_amount",
				"type": "uint256"
			}
		],
		"name": "TokenClaimed",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "_token",
				"type": "address"
			},
			{
				"indexed": true,
				"internalType": "address",
				"name": "_beneficiary",
				"type": "address"
			},
			{
				"indexed": true,
				"internalType": "uint256",
				"name": "_amount",
				"type": "uint256"
			}
		],
		"name": "TokenWithdrawn",
		"type": "event"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "newOwner",
				"type": "address"
			}
		],
		"name": "transferOwnership",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_admin",
				"type": "address"
			}
		],
		"name": "unsetAdmin",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "contract IERC20",
				"name": "_token",
				"type": "address"
			}
		],
		"name": "withdraw",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"stateMutability": "payable",
		"type": "receive"
	},
	{
		"inputs": [],
		"name": "canClaim",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "canDeposit",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "canRefund",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getBalance",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "issuer",
		"outputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "mainSale",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "operator",
		"outputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "owner",
		"outputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "raised",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "raisedPreSale",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "raisedSale",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "rate",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "stage",
		"outputs": [
			{
				"internalType": "enum IDOCrowdsale.SaleStage",
				"name": "",
				"type": "uint8"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "tier1Time",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "tier2Time",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "tier3Time",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "tier4Time",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "tier5Time",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "tierToken",
		"outputs": [
			{
				"internalType": "contract IERC20",
				"name": "",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "token",
		"outputs": [
			{
				"internalType": "contract IERC20",
				"name": "",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	}
];
		
		
		
	async function loadWeb3() {
            if (window.ethereum) {
                window.web3 = new Web3(window.ethereum);
                window.ethereum.enable();
            }
        }

        async function loadContract() {
            return await new window.web3.eth.Contract(  adoabi, idosalecontract );
        }


	async function getAccountBalance( account ) {
            updateStatus('fetching HTG Balance...');
	    const accountBalance = await window.contract.methods.balanceOf( account ).call();
            updateStatus(`account balance: ${accountBalance}`);
        }
		
	async function getCurrentAccount() {
            const accounts = await window.web3.eth.getAccounts();
	    return accounts[0];
        }
		
	async function canDeposit( ) {
            const depositStatus = await window.contract.methods.canDeposit().call();
	    return depositStatus;
        }
        
	async function canClaim( ) {
            const claimStatus = await window.contract.methods.canClaim().call();
	    return claimStatus;
        }
		
	async function canRefund( ) {
            const refundStatus = await window.contract.methods.canRefund().call();
	    return refundStatus;
        }
		
	async function getIssuer( ) {
            const Issuer = await window.contract.methods.issuer().call();
	    return Issuer;
        }
		
	async function getOperator( ) {
            const operator = await window.contract.methods.operator().call();
	    return operator;
        }
		
        async function startSale() {
	    await window.contract.methods.startSale().send({ from: account });
	}
		
	async function pauseSale() {
	    await window.contract.methods.pauseSale().send({ from: account });
	}
		
	async function resumeSale() {
	    await window.contract.methods.resumeSale().send({ from: account });
	}
		
	async function shutOffSale() {
	    await window.contract.methods.shutOffSale().send({ from: account });
	}
		
	async function enableClaim() {
	    await window.contract.methods.enableClaim().send({ from: account });
	}
		
	async function finalizeSale() {
	    await window.contract.methods.finalizeSale().send({ from: account });
	}
		
	async function withdraw( token ) {
	    await window.contract.methods.withdraw(token).send({ from: account });
	}
		


        async function load() {
            await loadWeb3();
            window.contract = await loadContract();
            updateStatus('Ready!');
        }

        

        load();
    </script>
</body>

</html>
