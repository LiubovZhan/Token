pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract Token {

    struct House{
        string nameHouse;
        uint area;
        string location;
        uint price;
    }
    
    House[] databaseHouse;
    mapping (uint=>uint) houseToOwner;

    modifier checkOwnerAndAccept {
        require(msg.pubkey() == tvm.pubkey(), 100);
		tvm.accept();
		_;
    }

    function addHouse(string nameHouse, uint area, string location) public checkOwnerAndAccept{
        uint x = 0;
        for (uint i = 0; i < databaseHouse.length; i++) {
            if (nameHouse != databaseHouse[i].nameHouse) break; 
            x++;      
        }
        if (x==0){
        databaseHouse.push (House(nameHouse, area, location, 0));
        uint keyAsLastHouse = databaseHouse.length -1;
        houseToOwner[keyAsLastHouse] = msg.pubkey();
        }
        else {
            require(false, 102);
        }
    }
        
    function getHouseOwner(uint houseId) public view returns(uint){
        return houseToOwner[houseId];
    }

    function getHouseInfo(uint houseId) public view returns (string nameHouse, uint area, string location, string sale){
        nameHouse = databaseHouse[houseId].nameHouse;
        area = databaseHouse[houseId].area;
        location = databaseHouse[houseId].location;
        if (databaseHouse[houseId].price>0){
            sale = "The house is for sale";
        }
        else {
            sale = "The house is not for sale";
        }
    }

    function forSale(uint houseId, uint price) public checkOwnerAndAccept {
        require(msg.pubkey() == houseToOwner[houseId],101);
        databaseHouse[houseId].price = price;
    }
    
}
