const path = require('path');
const fs = require ('fs');
const solc = require('solc');
const productPath = path.resolve(__dirname,'contracts','products.sol');
const source = fs.readFileSync(productPath,'utf8');
// console.log(solc.compile(source,1));
// module.exports = solc.compile(source,1).contracts[':Product'];
solc.compile(source,1).contracts[':Product']; //พี่ภู
