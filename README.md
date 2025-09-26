# Scale Agnostic Number Guessing Game

A simple number guessing game demonstrating Jac's scale-agnostic approach - the same code runs locally or as a web API.

## Quick Start

### Local Mode
```bash
jac run simple_guess.jac
```

### API Server Mode
```bash
jac serve guess_game.jac
```

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

## Key Feature

**Write once, run anywhere** - No code changes needed to go from local testing to web API deployment.