require('dotenv').config();
const Web3 = require('web3');
const web3 = new Web3();
const HDWalletProvider = require('@truffle/hdwallet-provider');
const NonceTrackerSubprovider = require('web3-provider-engine/subproviders/nonce-tracker');
const DEV_MNEMONIC = require('./mnemonic.js').MNEMONIC;

module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // for more about customizing your Truffle configuration!
  networks: {
    development: {
      host: process.env.GANACHE_HOST || '127.0.0.1',
      // host: "127.0.0.1",
      port: 8545,
      network_id: '*', // Match any network id,
      //gas: 6721975,
      gas: 6721975,
      gasPrice: web3.utils.toWei('1', 'gwei'),
    },
    kovan: {
      // multi-client
      provider: function () {
        var wallet = new HDWalletProvider(
          DEV_MNEMONIC,
          'https://kovan.infura.io/v3/ca5185b25a334fc0b9bc9380167dbe87',
          0,
          1000,
        ); 
        var nonceTracker = new NonceTrackerSubprovider();
        wallet.engine._providers.unshift(nonceTracker);
        nonceTracker.setEngine(wallet.engine);
        return wallet;
      },
      network_id: '*', // 3
      gas: 5000000,
      gasPrice: web3.utils.toWei('30', 'gwei'),
      confirmations: 1,
      skipDryRun: true,
      timeoutBlocks: 100,
    },
    // Configure your compilers
    compilers: {
      solc: {
        version: '0.6.0', // 0.5.13 // Fetch exact version from solc-bin (default: truffle's version)
        docker: true, // Use "0.5.8" you've installed locally with docker (default: false)
        settings: {
          // See the solidity docs for advice about optimization and evmVersion
          optimizer: {
            enabled: true,
            runs: 10,
          },
          evmVersion: 'byzantium',
        },
      },
    },
    all: false,
    compileAll: false,
  },
};
