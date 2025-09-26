"""
Simple Number Guessing Game in Jac - Local Version Only
"""

# Simple game without imports for now
with entry {
    print("Number Guessing Game - Scale Agnostic Demo");
    print("=" * 50);
    
    # Hardcoded values for demo (in real version would use random)
    secret_number = 7;
    max_attempts = 3;
    
    print(f"I'm thinking of a number between 1 and 10.");
    print(f"You have {max_attempts} attempts to guess it!");
    
    # Simulate some guesses for demo
    guesses = [5, 8, 7];
    
    for i in range(len(guesses)) {
        attempt = i + 1;
        guess = guesses[i];
        
        print(f"\nAttempt {attempt}: Guessing {guess}");
        
        if guess == secret_number {
            print("Correct! You guessed {secret_number} in {attempt} attempts!");
            break;
        } elif guess < secret_number {
            print("Too low! Try a higher number.");
        } else {
            print("Too high! Try a lower number.");
        }
        
        if attempt == max_attempts {
            print("Game over! The number was {secret_number}");
        }
    }
    
    print("\n" + "=" * 50);
    print("This is a demo version of the scale-agnostic game.");
    print("The full version with random numbers and API support");
    print("   would be served with: jac serve guess_game.jac");
}