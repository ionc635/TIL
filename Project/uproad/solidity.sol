// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract uproad {
    struct AdInfo {
        address adOwner;
        uint256 adPrice;
    }
    
    constructor() {}
    
    uint256 price = 1e16;
    
    mapping(uint256 => AdInfo) public adMapping;
    
    event NewAd(uint256 adIndex, address sender, string title, string link, uint256 adPrice);
    
    event SetAd(uint256 adIndex, address sender, string title, string link, uint256 adPrice);
    
    function newAd(uint256 adIndex, string memory title, string memory link) public {
        require(adMapping[adIndex].adOwner == address(0), "[ERROR] DUPLICATE AD INDEX." );
        AdInfo storage adInfo = adMapping[adIndex];
        adInfo.adOwner = msg.sender;
        adInfo.adPrice = price;
        emit NewAd(adIndex, msg.sender, title, link, adInfo.adPrice);
    }
    
    function setAd(uint256 adIndex, string memory title, string memory link) public payable {
        require(msg.value >= adMapping[adIndex].adPrice, "[ERROR] NOT ENOUGH ETH.");
        require(adMapping[adIndex].adOwner != msg.sender, "[ERROR] YOU ARE ALREADY AN AD OWNER.");
        payable(adMapping[adIndex].adOwner).transfer(adMapping[adIndex].adPrice);
        payable(msg.sender).transfer(msg.value - adMapping[adIndex].adPrice);
        AdInfo storage adInfo = adMapping[adIndex];
        adInfo.adOwner = msg.sender;
        adInfo.adPrice = adMapping[adIndex].adPrice + price;
        emit SetAd(adIndex, msg.sender, title, link, adInfo.adPrice);
    }
    
    function getAd(uint256 adIndex) public view returns (AdInfo memory) {
        return adMapping[adIndex];
    }
}
