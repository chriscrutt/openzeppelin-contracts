find -E ../ -regex ".*\.(sol|jpeg)" > log
awk '{sub("..//contracts/","import \"./")}1' log > testFile.sol
awk '{sub("sol", "sol\";")}1' testFile.sol > log && mv log testFile.sol
awk '{sub("..//", "//")}1' testFile.sol > log && mv log testFile.sol
printf '%s\n' "// SPDX-License-Identifier:MIT" 'pragma solidity >=0.6.0 <0.9.0;' | cat - testFile.sol > log && mv log testFile.sol
solcjs -o /Users/christophercruttenden/openzeppelin-contracts/logs --base-path /Users/christophercruttenden/openzeppelin-contracts/contracts --bin /Users/christophercruttenden/openzeppelin-contracts/contracts/testFile.sol
echo Success!