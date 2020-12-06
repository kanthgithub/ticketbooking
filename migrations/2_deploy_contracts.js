const lakshmiKanthToken = artifacts.require('./LakshmiKanthToken.sol')

module.exports = function (deployer, network, accounts) {
  deployer.then(async () => {
    const lakshmiKanthTokenDeployedInstance = await deployer.deploy(lakshmiKanthToken);
    console.log(`lakshmiKanthToken is deployed with Address: ${lakshmiKanthTokenDeployedInstance.address}`);
  });
};
