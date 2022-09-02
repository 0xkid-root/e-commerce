//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.0 < 0.9.0;
contract Ecommerce{
    struct product{
        string title;
        string desc;
        address payable seller;
        uint price;
        uint productId;
        address buyer;
        bool delivered;
    }
    uint counter=1;
    product[] public products;
    event Registered(string title,uint productId,address seller);
    event boughts(uint productId, address buyer);
    event delive(uint productId);

    function registerProduct(string memory _title,string memory _desc,uint _price) public{
        require(_price>0,'Price should be greater thsn zero');
        product memory tempProduct;
        tempProduct.title=_title;
        tempProduct.desc=_desc;
        tempProduct.price= _price*10**18;// 1ether=10**18;
        tempProduct.seller=payable(msg.sender);
        tempProduct.productId=counter;
        products.push(tempProduct);
        counter++;
        emit Registered(_title,tempProduct.productId,msg.sender);

    }
    //buyer Function ....
    
    function Buy(uint _productId) payable public{
        require(products[_productId-1].price==msg.value,'Please pay the exact price');
        require(products[_productId-1].seller!=msg.sender,"Seller can't be the Buyer");
        products[_productId-1].buyer=msg.sender;
        emit boughts(_productId,msg.sender);
    }
// delivery function .....

    function delivery(uint _productId) public {
        require(products[_productId-1].buyer==msg.sender,'Only buyer can confirm it');
        products[_productId-1].delivered=true;
        products[_productId-1].seller.transfer(products[_productId-1].price);
        emit delive(_productId);

    }
}
