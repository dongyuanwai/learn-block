
# 步骤
### 1、配置 cofig,并把网络添加到metamask
在 `hardhat.config.js` 中配置
```js
networks: {
    dev: {
      url: "http://127.0.0.1:8545",
      chainId: 31337,
    },
  }
```

并 在 metamask中添加网络

### 2、部署合约,查看合约余额
要想查看合约余额 需要先创建一个命令：

新建一个task执行文件 `task/balance.js`
```js
task("balance", "Prints an account's balance")
  .addParam("account", "The account's address")
  .setAction(async (taskArgs) => {
    const balance = await ethers.provider.getBalance(taskArgs.account);

    console.log("当前账户余额：",ethers.utils.formatEther(balance), "ETH");
  });
```

部署合约：

```js
npx hardhat run scripts/deploy.js --network dev
```
成功后 会有一个合约地址
deployed to: 0xDc64a140Aa3E981100a9becA4E685f962f0cF6C9


运行命令，查看合约余额
```js
npx hardhat balance --account 0xDc64a140Aa3E981100a9becA4E685f962f0cF6C9 --network dev
```

## 3、获取一些测试账户，进行转账
```js
npx hardhat node
```
会生成一些测试账户 和 秘钥

使用秘钥导入metamask

然后 根据合约地址：0xDc64a140Aa3E981100a9becA4E685f962f0cF6C9 向这个合约转账
