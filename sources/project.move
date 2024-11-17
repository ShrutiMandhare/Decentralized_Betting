module Decentralizedbetting::Betting {

    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    /// Struct representing a betting pool for an eSports tournament.
    struct BettingPool has store, key {
        total_bets: u64,     // Total funds bet on the tournament
        outcome: u8,         // Outcome of the tournament (e.g., 1 = Team A wins, 2 = Team B wins)
    }

    /// Function to create a new betting pool for a tournament.
    public fun create_betting_pool(owner: &signer, outcome: u8) {
        let betting_pool = BettingPool {
            total_bets: 0,
            outcome,
        };
        move_to(owner, betting_pool);
    }

    /// Function for users to place a bet on a specific outcome of the tournament.
    public fun place_bet(bettor: &signer, pool_owner: address, amount: u64, outcome: u8) acquires BettingPool {
        let betting_pool = borrow_global_mut<BettingPool>(pool_owner);

        // Ensure the bet is placed on the correct outcome
        assert(betting_pool.outcome == outcome, 1);

        // Withdraw the bet amount from the bettor's account
        let bet = coin::withdraw<AptosCoin>(bettor, amount);

        // Deposit the bet amount into the betting pool
        coin::deposit<AptosCoin>(pool_owner, bet);

        // Update the total amount bet on the pool
        betting_pool.total_bets = betting_pool.total_bets + amount;
    }
}
