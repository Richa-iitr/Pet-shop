# Animal Pet Shop SmartContract

The animal shop contract inherits SafeMath contract to avoid integer overflows.

The contract is implements a shop where any customer can purchase: 
    Fish,
    Cat,
    Dog,
    Rabbit,
    Parrot.

The shop will store information for all the customers who buy a pet.

The contract called AnimalShop has:

    function add (animalType, number) – only the owner can give add to animals in the shop
    function buy (customerAge, customerGender, animalType)
        save when the animal is bought
        you can only adopt one animal for lifetime
        function giveBackAnimal(animalType)
        you can give the animal back in the first 5 minutes after purchase
