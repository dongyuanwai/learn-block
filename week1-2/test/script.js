var Counter = artifacts.require("Counter");

module.exports = async function(callback) {
  var counter = await Counter.deployed()

  let value = await counter.counter();

  console.log("current conter value:" + value);
}