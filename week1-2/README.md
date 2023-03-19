## week1-2

合约地址：0x6e09fbf8060c5363dfbed3923eaf102fb84338b2


浏览器中的地址：https://mumbai.polygonscan.com/address/0x6e09fbf8060c5363dfbed3923eaf102fb84338b2#code




# hardhat使用

## 安装
不建议全局安装

创建一个目录，在目录里局部安装
```js
npm install --save hardhat

```

在目录里初始化创建项目
```js
npx hardhat
```

在constracts里创建一个合约  Counter.sol
```solidity
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;


contract Counter {
    uint public counter;
    address owner;

    constructor(uint x) {
        counter = x;
        owner = msg.sender;
    }

    function count() public {
        require(msg.sender == owner, "invalid call");
        counter = counter + 1;
    }

}
```
编译
```js
npx hardhat compile
```

有可能会报关于 `hardhat-toolbox` 的错

这时再安装一下@nomicfoundation/hardhat-toolbox即可
```js
npm i --save-dev @nomicfoundation/hardhat-toolbox
```

## 部署
部署脚本写在 scripts文件夹里
并在 script 写布置脚本
```js
const main = async () => {
  try {
    const counterContractFactory = await hre.ethers.getContractFactory(
      "Counter"
    );
    const counterContract = await counterContractFactory.deploy(1);
    await counterContract.deployed();

    console.log("Contract deployed to:", counterContract.address);
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};
  
main();
```

并且需要配置一些参数 ： 合约的助记词，这些助记词一般不能发到网上

### 部署到本地
需要在 hardhat.config.js 配置文件配置本地的信息


执行这个是部署到本地
```js
npx hardhat run scripts/deploy.js
```

### 部署到测试网
部署到测试网：需要添加网络配置。在 networks 部分中添加以下代码即可：
```js
npx hardhat run scripts/deploy.js --network mumbai
```
部署成功，最后一传字符就是合约地址:0x6e09fbf8060c5363dfbed3923eaf102fb84338b2


 然后去区块链浏览器上根据这个地址进行搜索，就能看到交易信息https://mumbai.polygonscan.com/address/0x6e09fbf8060c5363dfbed3923eaf102fb84338b2


## 测试
在test文件里创建一个 Counter.js的测试文件
```js
const {
    time,
    loadFixture,
  } = require("@nomicfoundation/hardhat-network-helpers");
  const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");

  const { expect } = require("chai");
  let counter;

describe("Counter", function () {
    async function init(){
        const {owner,otherAccount} = await ethers.getSigners();
        const Counter = await ethers.getContractFactory("Counter");
        counter = await Counter.deploy();
        console.log("counter:",counter.address);
    }
    before(async function (){
        await init()
    })

    it("init equal 0",async function(){
        expect(await counter.counter()).to.equal(0);
    })

    it("add 1 equal 1",async function(){
        let tx = await counter.count();
        await tx.wait();
        expect(await counter.counter()).to.equal(1)
    })

});
  ```


执行 
```js
npx hardhat test
```

代码开源到浏览器上,
需要先在https://polygonscan.com/myapikey 创建一个 API KEY

这里的配置信息 mnemonic 和 scankey 不能公开在github上，注意销毁

然后在 hardhat.config.js 配置文件配置信息


然后执行  `npx hardhat verify <刚才部署到xxx网络的合约地址> "1" --network xxx网络`
```js
npx hardhat verify 0x6E09FBf8060c5363Dfbed3923eAF102FB84338b2 "1" --network mumbai
```
成功了会输出一个链接

https://mumbai.polygonscan.com/address/0x6E09FBf8060c5363Dfbed3923eAF102FB84338b2#code



## ABI导出
安装  hardhat-abi-exporter
```js
npm install --save-dev hardhat-abi-exporter
```
在hardhat.config.js 配置文件 引入，并配置参数


然后执行导出命令
```js
npx hardhat export-abi
```

abi有几种格式，更改参数可以导出不同的格式
