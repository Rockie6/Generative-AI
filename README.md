# Scale Agnostic Number Guessing Game

A demonstration of Jac's capabilities through multiple versions of a number guessing game, culminating in AI-enhanced gameplay.

## Quick Start

### Step 5: Scale Agnostic Approach
```bash
jac run simple_guess.jac
```

### Step 6: AI-Enhanced Gameplay  
```bash
jac run ai_game.jac
```

### API Server Mode
```bash
jac serve guess_game.jac
```

## Features

**Step 5 - Scale Agnostic**: Same code runs locally or as API
**Step 6 - AI Enhanced**: Intelligent hints using byLLM concepts
- Context-aware responses
- Adaptive difficulty levels  
- Strategic guidance
- Personalized feedback

## API Usage

Start a game:
```bash
curl -X POST http://localhost:8000/NumberGuessingGame/start_game \
  -H "Content-Type: application/json" \
  -d '{"min_num": 1, "max_num": 10}'
```

Make a guess:
```bash
curl -X POST http://localhost:8000/NumberGuessingGame/make_guess \
  -H "Content-Type: application/json" \
  -d '{"game_id": 123456, "guess": 7}'
```

## Key Features

**Scale Agnostic**: Write once, run anywhere - No code changes needed to go from local testing to web API deployment.

**AI Enhanced**: Intelligent gameplay with context-aware hints and adaptive responses powered by byLLM integration concepts.