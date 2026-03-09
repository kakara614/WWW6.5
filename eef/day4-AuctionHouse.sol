//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

contract AuctionHouse{
    address public owner;
    string public item;
    uint public auctionEndTime;
    uint private highestPrice;
    address private highestBidder;
    uint private highestBid;
    bool public ended;

    mapping (address=>uint) public bids;
    address[]public bidders;

    constructor(string memory _item,uint _biddingTime){
        owner=msg.sender;
        item=_item;
        auctionEndTime=block.timestamp+_biddingTime;
    }
    //出价(bug
    function bid(uint amount)external{
        require(block.timestamp<auctionEndTime,"Auction has ended"); 
        //出价，允许一个人多次出价，金额累加
        if(bids[msg.sender]==0){
            bidders.push(msg.sender);
        }
        require(bids[msg.sender]+amount>highestBid,"Bid amount should be higher than the previous bid");
        bids[msg.sender]+=amount;
        if(bids[msg.sender]>highestBid){
            highestBid=bids[msg.sender];
            highestBidder=msg.sender;
        }
        //require(block.timestamp >= auctionEndTime, "Auction not yet ended");  // 结束时检查
    }
    //拍卖结束
    function endAuction() external {
        require(!ended,"already ended");
        require(block.timestamp>=auctionEndTime,"Auction not yet ended");  // 结束时检查
        require(msg.sender==owner,"only owner can ended");
        ended=true;
    }
    //获取胜者
    function getWinner()external view returns(address,uint){
        require(ended,"not yet ended");
        return (highestBidder,highestBid);
    }
    //获取所有参与拍卖的人手
    function getAllBidders() external view returns(address[] memory){
        return bidders;
    }
}
// 尝试以下改进:

// 添加payable修饰符,接收真实ETH
// 实现退款功能,向未中标者返还ETH
// 添加最低出价金额限制
// 添加事件记录每次出价
// 实现紧急暂停功能
// 允许owner延长拍卖时间