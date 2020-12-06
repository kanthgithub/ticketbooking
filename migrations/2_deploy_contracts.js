const ticketBookingSystem = artifacts.require('./TicketBookingSystem')

module.exports = function (deployer, network, accounts) {
  deployer.then(async () => {
    const ticketBookingSystemDeployedInstance = await deployer.deploy(ticketBookingSystem);
    console.log(`ticketBookingSystemDeployedInstance is deployed with Address: ${ticketBookingSystemDeployedInstance.address}`);
  });
};
