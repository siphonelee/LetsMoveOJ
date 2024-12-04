/// Module: main
module main::main {
    use sui::tx_context::sender;

    public struct Main has key {
        id: UID,
        sum: u64
    }

    public fun main(a: u64, b: u64, ctx: &mut TxContext) {
        let m = Main {
            id: object::new(ctx),
            sum: a + b,
        };

        transfer::transfer(m, ctx.sender());
    }
}
