"""
Step 5 - Scale Agnostic Approach Demo
Simple Number Guessing Game - Same code runs locally or as API
"""

import:py random;

# Game state storage (in real deployment, use database)
global game_sessions = {};

walker NumberGuessingGame {
    can start_game(min_num: int = 1, max_num: int = 10) -> dict {
        game_id = random.randint(100000, 999999);
        secret_number = random.randint(min_num, max_num);
        
        game_sessions[game_id] = {
            "secret": secret_number,
            "min": min_num,
            "max": max_num,
            "attempts": 0,
            "max_attempts": 5,
            "status": "active",
            "guesses": []
        };
        
        return {
            "game_id": game_id,
            "message": "Game started! Guess a number between {min_num} and {max_num}",
            "min_number": min_num,
            "max_number": max_num,
            "max_attempts": 5,
            "attempts_left": 5
        };
    }
    
    can make_guess(game_id: int, guess: int) -> dict {
        if game_id not in game_sessions {
            return {"error": "Game not found! Start a new game first."};
        }
        
        game = game_sessions[game_id];
        
        if game["status"] != "active" {
            return {"error": f"Game is {game['status']}. Start a new game!"};
        }
        
        game["attempts"] += 1;
        game["guesses"].append(guess);
        attempts_left = game["max_attempts"] - game["attempts"];
        
        if guess == game["secret"] {
            game["status"] = "won";
            return {
                "result": "correct",
                "message": "Congratulations! You guessed {guess} in {game['attempts']} attempts!",
                "game_id": game_id,
                "attempts": game["attempts"],
                "status": "won"
            };
        }
        elif game["attempts"] >= game["max_attempts"] {
            game["status"] = "lost";
            return {
                "result": "game_over",
                "message": "Game over! The number was {game['secret']}",
                "secret_number": game["secret"],
                "game_id": game_id,
                "attempts": game["attempts"],
                "status": "lost"
            };
        }
        elif guess < game["secret"] {
            return {
                "result": "too_low",
                "message": "Too low! Try a higher number.",
                "guess": guess,
                "game_id": game_id,
                "attempts": game["attempts"],
                "attempts_left": attempts_left
            };
        }
        else {
            return {
                "result": "too_high",
                "message": "Too high! Try a lower number.",
                "guess": guess,
                "game_id": game_id,
                "attempts": game["attempts"],
                "attempts_left": attempts_left
            };
        }
    }
    
    can get_game_stats(game_id: int) -> dict {
        if game_id not in game_sessions {
            return {"error": "Game not found!"};
        }
        
        game = game_sessions[game_id];
        return {
            "game_id": game_id,
            "status": game["status"],
            "attempts": game["attempts"],
            "max_attempts": game["max_attempts"],
            "guesses": game["guesses"],
            "range": f"{game['min']}-{game['max']}"
        };
    }
}

walker GameManager {
    can list_active_games() -> dict {
        active_games = [];
        for game_id, game_data in game_sessions.items() {
            if game_data["status"] == "active" {
                active_games.append({
                    "game_id": game_id,
                    "attempts": game_data["attempts"],
                    "attempts_left": game_data["max_attempts"] - game_data["attempts"],
                    "range": f"{game_data['min']}-{game_data['max']}"
                });
            }
        }
        return {"active_games": active_games, "count": len(active_games)};
    }
}

# Local execution entry point
with entry {
    print("Number Guessing Game - Scale Agnostic Demo");
    print("=" * 50);
    
    game = NumberGuessingGame();
    manager = GameManager();
    
    # Start a local game
    print("\nStarting local game...");
    result = game.start_game(1, 20);
    print(f"Game ID: {result['game_id']}");
    print(result["message"]);
    
    game_id = result["game_id"];
    
    # Simulate some guesses
    test_guesses = [10, 15, 8, 12];
    print("Making test guesses: {test_guesses}");
    
    for guess in test_guesses {
        print(f"\n  Guessing: {guess}");
        guess_result = game.make_guess(game_id, guess);
        print(f"  {guess_result['message']}");
        
        if guess_result.get("status") in ["won", "lost"] {
            break;
    }
    
    # Show game stats
    print("Game Statistics:");
    stats = game.get_game_stats(game_id);
    for key, value in stats.items() {
        print(f"  {key}: {value}");
    }
    
    print("\n" + "=" * 50);
    print("To serve as API endpoints, run:");
    print("   jac serve guess_game.jac");
    print("\nAPI Endpoints:");
    print("   POST /NumberGuessingGame/start_game");
    print("   POST /NumberGuessingGame/make_guess");  
    print("   POST /NumberGuessingGame/get_game_stats");
    print("   POST /GameManager/list_active_games");
}