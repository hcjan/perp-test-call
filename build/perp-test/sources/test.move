// this is an example of how to use scoring in the contract.
// policy for scoring is defined in the function body.
module deployer::test {
    use score::score_distribute;
    use std::object::{Self, ExtendRef};
     struct Controller has key {
        extend_ref: ExtendRef
    }
 

     fun init_module(deployer: &signer) {
        let constructor_ref = object::create_named_object(deployer, b"seed", false);
        let extend_ref = object::generate_extend_ref(&constructor_ref);
        move_to(deployer, Controller { extend_ref, })
    }

    public entry fun call_test(signer: &signer, acc: address) acquires Controller {
        let controller = borrow_global<Controller>(@deployer);
        let deployer = &object::generate_signer_for_extending(&controller.extend_ref);
        score_distribute::set_spot_signer(deployer, acc);
    }

     #[view]
    public fun get_deployer_object_address(): address acquires Controller {
        let controller = borrow_global<Controller>(@deployer);
        object::address_from_extend_ref(&controller.extend_ref)
    }
    
}
