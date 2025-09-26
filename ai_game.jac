"""
Interactive AI-Enhanced Number Guessing Game
Play with intelligent hints and guidance!
"""

with entry {
    print("Welcome to the AI-Enhanced Number Guessing Game!");
    print("=" * 50);
    
    # Game setup
    secret_number = 73;  # Fixed for this demo
    min_num = 1;
    max_num = 100;
    max_attempts = 8;
    attempts = 0;
    guesses = [];
    
    print(f"\nI'm thinking of a number between {min_num} and {max_num}.");
    print(f"You have {max_attempts} attempts to find it!");
    print("\nAI Guide: I'll provide intelligent hints to help you succeed!");
    
    # Interactive game loop
    while attempts < max_attempts {
        attempts += 1;
        attempts_left = max_attempts - attempts;
        
        print(f"\n--- Attempt {attempts} of {max_attempts} ---");
        
        # Get user input
        try {
            guess_input = input(f"Enter your guess ({min_num}-{max_num}): ");
            guess = int(guess_input);
            
            if guess < min_num or guess > max_num {
                print(f"Please guess between {min_num} and {max_num}!");
                attempts -= 1;  # Don't count invalid guesses
                continue;
            }
            
            guesses.append(guess);
            
            # Check if correct
            if guess == secret_number {
                print(f"\nCONGRATULATIONS! You found the number {secret_number}!");
                
                # AI victory response
                if attempts == 1 {
                    print("AI Response: Incredible! A perfect guess on the first try! Are you psychic?");
                } elif attempts <= 3 {
                    print(f"AI Response: Brilliant deduction! Solving in {attempts} attempts shows exceptional skill.");
                } elif attempts <= 5 {
                    print(f"AI Response: Excellent work! {attempts} attempts demonstrates solid strategy.");
                } else {
                    print(f"AI Response: Well done! Victory in {attempts} attempts - persistence pays off!");
                }
                break;
            }
            
            # Generate AI-enhanced hints
            distance = abs(guess - secret_number);
            print(f"\nNot quite! Your guess: {guess}");
            
            # Context-aware hints based on proximity
            if distance == 1 {
                print("AI Hint: SO CLOSE! You're just 1 number away!");
                print("Strategy: You're practically touching the answer - tiny adjustment needed!");
            } elif distance <= 5 {
                print(f"AI Hint: Very close! You're within {distance} numbers of the target.");
                direction = "slightly higher" if guess < secret_number else "slightly lower";
                print(f"Strategy: Think {direction} - you're in the right neighborhood!");
            } elif distance <= 15 {
                print(f"AI Hint: Getting warmer! You're about {distance} numbers away.");
                if guess < secret_number {
                    print("Strategy: Your systematic approach is good - scale up meaningfully.");
                } else {
                    print("Strategy: You're thinking too big - bring it down a notch.");
                }
            } else {
                if guess < secret_number {
                    print("AI Hint: Think much higher! You're significantly below the target.");
                    print("Strategy: That's a good starting point - now make a bold leap upward!");
                } else {
                    print("AI Hint: Think much lower! You're way above the target.");
                    print("Strategy: Ambitious guess! Time to humble your expectations considerably.");
                }
            }
            
            # Pattern analysis for multiple guesses
            if len(guesses) > 1 {
                recent_distance = abs(guesses[-1] - secret_number);
                previous_distance = abs(guesses[-2] - secret_number);
                
                if recent_distance < previous_distance {
                    print("Pattern Analysis: Great! You're getting closer with each guess!");
                } elif recent_distance > previous_distance {
                    print("Pattern Analysis: You were closer before - reconsider your last direction.");
                } else {
                    print("Pattern Analysis: Same distance - try a different approach!");
                }
            }
            
            # Motivational messages based on attempts left
            if attempts_left == 0 {
                print(f"\nGAME OVER! The number was {secret_number}.");
                closest = guesses[0];
                for g in guesses {
                    if abs(g - secret_number) < abs(closest - secret_number) {
                        closest = g;
                    }
                }
                closest_distance = abs(closest - secret_number);
                print(f"AI Response: Good effort! Your closest guess was {closest}, only {closest_distance} away.");
                if closest_distance <= 5 {
                    print("You were so close! Try again for victory!");
                }
                break;
            } elif attempts_left == 1 {
                print(f"AI Motivation: This is it - your final chance! Make it count!");
            } elif attempts_left == 2 {
                print(f"AI Motivation: Two attempts left - stay focused and trust your instincts!");
            }
            
        } except ValueError {
            print("Please enter a valid number!");
            attempts -= 1;  # Don't count invalid input
        }
    }
    
    print("\n" + "=" * 50);
    print("Thanks for playing the AI-Enhanced Guessing Game!");
    print(f"Your guesses: {guesses}");
}