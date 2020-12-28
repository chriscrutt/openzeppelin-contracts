// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.9.0;

abstract contract Data {
    mapping(string => address) private _prices;

    constructor() {
        _prices[AUD] = 0x21c095d2aDa464A294956eA058077F14F66535af;
        _prices[BAT] = 0x031dB56e01f82f20803059331DC6bEe9b17F7fC9;
        _prices[BNB] = 0xcf0f51ca2cDAecb464eeE4227f5295F2384F84ED;
        _prices[BTC] = 0xECe365B379E1dD183B20fc5f022230C044d51404;
        _prices[CHF] = 0x5e601CF5EF284Bcd12decBDa189479413284E1d2;
        _prices[DAI] = 0x2bA49Aaa16E6afD2a993473cfB70Fa8559B523cF;
        _prices[ETH] = 0x8A753747A1Fa494EC906cE90E9f37563A8AF630e;
        _prices[EUR] = 0x78F9e60608bF48a1155b4B2A5e31F32318a1d85F;
        _prices[FNX] = 0xcf74110A02b1D391B27cE37364ABc3b279B1d9D1;
        _prices[GBP] = 0x7B17A813eEC55515Fb8F49F2ef51502bC54DD40F;
        _prices[JPY] = 0x3Ae2F46a2D84e3D5590ee6Ee5116B80caF77DeCA;
        _prices[LINK] = 0xd8bD0a1cB028a31AA859A21A3758685a95dE4623;
        _prices[LTC] = 0x4d38a35C2D87976F334c2d2379b535F1D461D9B4;
        _prices[MktCap] = 0x9Dcf949BCA2F4A8a62350E0065d18902eE87Dca3;
        _prices[Oil] = 0x6292aA9a6650aE14fbf974E5029f36F95a1848Fd;
        _prices[REP] = 0x9331b55D9830EF609A2aBCfAc0FBCE050A52fdEa;
        _prices[SNX] = 0xE96C4407597CD507002dF88ff6E0008AB41266Ee;
        _prices[TRX] = 0xb29f616a0d54FF292e997922fFf46012a63E2FAe;
        _prices[USDC] = 0xa24de01df22b63d23Ebc1882a5E3d4ec0d907bFB;
        _prices[XAG] = 0x9c1946428f4f159dB4889aA6B218833f467e1BfD;
        _prices[XAU] = 0x81570059A0cb83888f1459Ec66Aad1Ac16730243;
        _prices[XFT] = 0xab4a352ac35dFE83221220D967Db41ee61A0DeFa;
        _prices[XRP] = 0xc3E76f41CAbA4aB38F00c7255d4df663DA02A024;
        _prices[XTZ] = 0xf57FCa8B932c43dFe560d3274262b2597BCD2e5A;
        _prices[ZRX] = 0xF7Bbe4D7d13d600127B6Aa132f1dCea301e9c8Fc;
        _prices[sCEX] = 0x1a602D4928faF0A153A520f58B332f9CAFF320f7;
        _prices[sDEFI] = 0x0630521aC362bc7A19a4eE44b57cE72Ea34AD01c;
    }

    function prices(string memory symbol) public return (address) {
        return _prices[symbol];
    }

}
