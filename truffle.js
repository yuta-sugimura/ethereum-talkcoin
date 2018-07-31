let HDWalletProvider = require("truffle-hdwallet-provider");
let mnemonic = "";
let infura_url = "";

module.exports = {
  networks: {
    ropsten: {
      provider: function() {
        return new HDWalletProvider(mnemonic, infura_url)
      },
      network_id: 3,
      gas: 46000000
      gasPrice: 3000000000
    },
    development: {
      host: '127.0.0.1',
      port: 7545,
      network_id: '*' // Match any network id
    }

  }
};
