const TicketStructLib = artifacts.require('./interfaces/TicketStructLib.sol');
const TicketBookingSystem = artifacts.require('./TicketBookingSystem.sol')

module.exports = function (deployer, network, accounts) {
  deployer.then(async () => {
    console.log(`default account: ${accounts[0]}`);
    await deployer.deploy(TicketStructLib);
    deployer.link(TicketStructLib, TicketBookingSystem);
    const ticketBookingSystemDeployedInstance = await deployer.deploy(TicketBookingSystem,accounts[0]);
    console.log(`ticketBookingSystemDeployedInstance is deployed with Address: 
    ${ticketBookingSystemDeployedInstance.address}`);
  });
};
