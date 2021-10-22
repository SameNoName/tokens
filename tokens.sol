pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract tokens {
    struct Token
    {
        string name;
        uint32 timestamp;
        uint rating;
        uint speed;
        uint power;
        bool forSale;
        uint price;
    }

    Token[] tokensArr;
    mapping(uint => uint) tokenToOwner;

    modifier Accept {
		tvm.accept();
		_;
	}

    function checkName(string newName) private returns(bool)
    {
        for (uint i = 0; i < tokensArr.length; ++i)
        {
            if (newName == tokensArr[i].name) return false;
        }
        return true;
    }

    function create(string name, uint rating, uint speed, uint power) public Accept
    {
        require(checkName(name), 101);
        tokensArr.push(Token(name, now, rating, speed, power, false, 0));
        uint keyAsLastNum = tokensArr.length - 1;
        tokenToOwner[keyAsLastNum] = msg.pubkey();
    }

    function pushForSale(uint tokenID, uint price) public Accept
    {
        require(msg.pubkey() == tokenToOwner[tokenID], 101);
        tokensArr[tokenID].forSale = true;
        tokensArr[tokenID].price = price;
    }

    constructor() public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }
}
