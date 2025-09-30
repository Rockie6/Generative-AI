import pygame;
import random;
import math;
import sys;
class Bird {
    def __init__(
        self: Bird,
        x: Any = 100,
        y: Any = 300,
        color: Any = (255, 255, 0),
        is_ai: Any = True
    ) {
        self.x = x;
        self.y = y;
        self.velocity = 0.0;
        self.alive = True;
        self.score = 0;
        self.color = color;
        self.is_ai = is_ai;
        self.brain = self.create_random_brain() if is_ai else None;
    }
    """Create AI brain with pre-trained weights (simplified)"""
    def create_random_brain(self: Bird) {
        return
        {'weights' : [ random.uniform(-1.5, 1.5) for _ in range(4) ] , 'bias' : random.uniform(-0.5, 0.5) };
    }
    """AI decision making"""
    def think(self: Bird, pipes: Any) {
        if not self.is_ai {
            return False;
        }
        closest_pipe = None;
        min_distance = float('inf');
        for pipe in pipes {
            if (pipe.x > (self.x - 50)) {
                distance = <>abs((pipe.x - self.x));
                if (distance < min_distance) {
                    min_distance = distance;
                    closest_pipe = pipe;
                }
            }
        }
        if (closest_pipe is None) {
            closest_pipe = pipes[0];
        }
        inputs =

            [(self.y / 600.0),
            (self.velocity / 10.0),
            ((closest_pipe.x - self.x) / 400.0),
            (((closest_pipe.top_height + closest_pipe.bottom_height) / 2) / 600.0)];
        output = self.brain['bias'];
        for i in range(4) {
            output += (inputs[i] * self.brain['weights'][i]);
        }
        activated = (1.0 / (1.0 + math.exp(-max(-500, min(500, output)))));
        return (activated > 0.5);
    }
    """Update bird physics"""
    def update(self: Bird) {
        self.velocity += 0.4;
        self.y += self.velocity;
        if ((self.y <= 0) or (self.y >= 580) ) {
            self.alive = False;
        }
    }
    """Make bird flap"""
    def flap(self: Bird) {
        if self.alive {
            self.velocity = -7.0;
        }
    }
    """Draw the bird"""
    def draw(self: Bird, screen: Any) {
        if self.alive {
            pygame.draw.circle(screen, self.color, (int(self.x), int(self.y)), 12);
            pygame.draw.circle(
                screen,
                (0, 0, 0),
                ((int(self.x) + 4), (int(self.y) - 4)),
                3
            );
            beak_points =

                [((int(self.x) + 12), int(self.y)),
                ((int(self.x) + 18), (int(self.y) + 2)),
                ((int(self.x) + 12), (int(self.y) + 4))];
            pygame.draw.polygon(screen, (255, 165, 0), beak_points);
        }
    }
}
class Pipe {
    def __init__(self: Pipe, x: Any) {
        self.x = x;
        self.width = 80;
        self.speed = 2.0;
        self.reset_height();
    }
    """Randomize pipe gap"""
    def reset_height(self: Pipe) {
        gap_center = random.uniform(180, 420);
        gap_size = 180;
        self.top_height = (gap_center - (gap_size // 2));
        self.bottom_height = (gap_center + (gap_size // 2));
    }
    """Move pipe left"""
    def update(self: Pipe) {
        self.x -= self.speed;
    }
    """Check collision with bird"""
    def collides_with(self: Pipe, bird: Any) {
        bird_radius = 12;
        if (((bird.x + bird_radius) > self.x)
        and ((bird.x - bird_radius) < (self.x + self.width))
        ) {
            if (((bird.y - bird_radius) < self.top_height)
            or ((bird.y + bird_radius) > self.bottom_height)
            ) {
                return True;
            }
        }
        return False;
    }
    """Check if bird passed this pipe"""
    def passed_by(self: Pipe, bird: Any) {
        return (bird.x > (self.x + self.width));
    }
    """Draw pipe"""
    def draw(self: Pipe, screen: Any) {
        pygame.draw.rect(screen, (0, 128, 0), (self.x, 0, self.width, self.top_height));
        pygame.draw.rect(screen, (0, 100, 0), (self.x, 0, 5, self.top_height));
        pygame.draw.rect(
            screen,
            (0, 128, 0),
            (self.x, self.bottom_height, self.width, (600 - self.bottom_height))
        );
        pygame.draw.rect(
            screen,
            (0, 100, 0),
            (self.x, self.bottom_height, 5, (600 - self.bottom_height))
        );
    }
}
class FlappyGame {
    def __init__(self: FlappyGame) {
        pygame.<>init();
        self.screen = pygame.display.set_mode((800, 600));
        pygame.display.set_caption('Flappy Bird: Human vs AI');
        self.clock = pygame.time.Clock();
        self.font = pygame.font.Font(None, 36);
        self.big_font = pygame.font.Font(None, 48);
        self.pipes = [];
        self.pipe_timer = 0;
        self.pipe_spacing = 200;
        self.game_over = False;
        self.winner = None;
        self.human = Bird(x=100, y=250, color=(255, 100, 100), is_ai=False);
        self.ai_birds =

            [Bird(x=100, y=300, color=(100, 100, 255), is_ai=True),
            Bird(x=100, y=350, color=(100, 255, 100), is_ai=True),
            Bird(x=100, y=200, color=(255, 255, 100), is_ai=True)];
        self.all_birds = ([self.human] + self.ai_birds);
        self.create_initial_pipes();
        print('🎮 Flappy Bird: Human vs AI');
        print('🔴 RED bird = YOU (SPACE to flap)');
        print('🔵 BLUE, 🟢 GREEN, 🟡 YELLOW birds = AI');
        print('Press SPACE to flap, ESC to quit');
    }
    """Create initial set of pipes"""
    def create_initial_pipes(self: FlappyGame) {
        self.pipes = [Pipe(400), Pipe(600), Pipe(800)];
    }
    """Handle user input"""
    def handle_events(self: FlappyGame) {
        for event in pygame.event.get() {
            if (event.type == pygame.QUIT) {
                return False;
            } elif (event.type == pygame.KEYDOWN) {
                if (event.key == pygame.K_SPACE) {
                    self.human.flap();
                    print('🚀 Human flap!');
                } elif (event.key == pygame.K_ESCAPE) {
                    return False;
                } elif ((event.key == pygame.K_r) and self.game_over ) {
                    self.restart_game();
                }
            }
        }
        return True;
    }
    """Restart the game"""
    def restart_game(self: FlappyGame) {
        self.game_over = False;
        self.winner = None;
        self.human = Bird(x=100, y=250, color=(255, 100, 100), is_ai=False);
        self.ai_birds =

            [Bird(x=100, y=300, color=(100, 100, 255), is_ai=True),
            Bird(x=100, y=350, color=(100, 255, 100), is_ai=True),
            Bird(x=100, y=200, color=(255, 255, 100), is_ai=True)];
        self.all_birds = ([self.human] + self.ai_birds);
        self.create_initial_pipes();
        print('🔄 Game restarted!');
    }
    """Update pipe positions and create new ones"""
    def update_pipes(self: FlappyGame) {
        for pipe in self.pipes {
            pipe.update();
        }
        self.pipes = [ pipe for pipe in self.pipes if (pipe.x > -pipe.width) ];
        if ((len(self.pipes) < 4) and (not self.pipes or (self.pipes[-1].x < 600) ) ) {
            new_x = (self.pipes[-1].x + self.pipe_spacing) if self.pipes else 400;
            self.pipes.append(Pipe(new_x));
        }
    }
    """Update all birds"""
    def update_birds(self: FlappyGame) {
        alive_count = 0;
        for bird in self.all_birds {
            if not bird.alive {
                continue;
            }
            alive_count += 1;
            if (bird.is_ai and bird.think(self.pipes) ) {
                bird.flap();
            }
            bird.update();
            for pipe in self.pipes {
                if pipe.collides_with(bird) {
                    bird.alive = False;
                    if (bird == self.human) {
                        print(f" '💀 Human died! Score: ' {bird.score} ");
                    } else {
                        print(f" '🤖 AI bird died! Score: ' {bird.score} ");
                    }
                    break;
                }
            }
            if bird.alive {
                for pipe in self.pipes {
                    if (pipe.passed_by(bird) and ((pipe.x + pipe.width) < (bird.x - 5)) ) {
                        bird.score += 1;
                        if (bird == self.human) {
                            print(f" '🎯 Human score: ' {bird.score} ");
                        }
                        break;
                    }
                }
            }
        }
        if (alive_count == 0) {
            self.end_game();
        }
    }
    """End the game and determine winner"""
    def end_game(self: FlappyGame) {
        self.game_over = True;
        scores =
            [
            (bird.score,
            'Human'
            if (bird == self.human)
            else f" 'AI-' {['Blue', 'Green', 'Yellow'][self.ai_birds.index(bird)]
            if (bird in self.ai_birds)
            else 'Unknown'} ") for bird in self.all_birds ];
        scores.sort(key=lambda  x: Any: x[0], reverse=True);
        self.winner = scores[0];
        print(f" '\n🏆 GAME OVER!' ");
        print(f" '🥇 Winner: ' {self.winner[1]} ' with score ' {self.winner[0]} ");
        print('📊 Final Scores:');
        for (score, name) in scores {
            print(f" '   ' {name} ': ' {score} ");
        }
        print('Press R to restart, ESC to quit');
    }
    """Draw background"""
    def draw_background(self: FlappyGame) {
        for y in range(600) {
            color_intensity = (135 + int((((206 - 135) * y) / 600)));
            color = (color_intensity, 206, 235);
            pygame.draw.line(self.screen, color, (0, y), (800, y));
        }
        cloud_positions = [(100, 80), (300, 120), (500, 60), (700, 100)];
        for (x, y) in cloud_positions {
            pygame.draw.circle(self.screen, (255, 255, 255), (x, y), 30);
            pygame.draw.circle(self.screen, (255, 255, 255), ((x + 25), y), 25);
            pygame.draw.circle(self.screen, (255, 255, 255), ((x - 25), y), 25);
        }
    }
    """Draw user interface"""
    def draw_ui(self: FlappyGame) {
        y_offset = 10;
        human_text = f" '🔴 Human: ' {self.human.score} ";
        human_surface = self.font.render(human_text, True, (255, 100, 100));
        self.screen.blit(human_surface, (10, y_offset));
        y_offset += 35;
        colors = [(100, 100, 255), (100, 255, 100), (255, 255, 100)];
        names = ['🔵 AI-Blue', '🟢 AI-Green', '🟡 AI-Yellow'];
        for (i, (bird, color, name)) in enumerate(zip(self.ai_birds, colors, names)) {
            ai_text = f" {name} ': ' {bird.score} ";
            ai_surface = self.font.render(ai_text, True, color);
            self.screen.blit(ai_surface, (10, y_offset));
            y_offset += 35;
        }
        if not self.game_over {
            instruction = 'SPACE = Flap | ESC = Quit';
            inst_surface = self.font.render(instruction, True, (0, 0, 0));
            self.screen.blit(inst_surface, (10, 550));
        }
    }
    """Draw game over screen"""
    def draw_game_over(self: FlappyGame) {
        if not self.game_over {
            return;
        }
        overlay = pygame.Surface((800, 600));
        overlay.set_alpha(128);
        overlay.fill((0, 0, 0));
        self.screen.blit(overlay, (0, 0));
        game_over_text = 'GAME OVER!';
        game_over_surface = self.big_font.render(game_over_text, True, (255, 255, 255));
        text_rect = game_over_surface.get_rect(center=(400, 200));
        self.screen.blit(game_over_surface, text_rect);
        winner_text =
            f" '🏆 Winner: ' {self.winner[1]} ' (' {self.winner[0]} ' points)' ";
        winner_surface = self.font.render(winner_text, True, (255, 255, 0));
        winner_rect = winner_surface.get_rect(center=(400, 250));
        self.screen.blit(winner_surface, winner_rect);
        restart_text = 'Press R to Restart | ESC to Quit';
        restart_surface = self.font.render(restart_text, True, (255, 255, 255));
        restart_rect = restart_surface.get_rect(center=(400, 350));
        self.screen.blit(restart_surface, restart_rect);
    }
    """Main game loop"""
    def run(self: FlappyGame) {
        running = True;
        while running {
            running = self.handle_events();
            if not self.game_over {
                self.update_pipes();
                self.update_birds();
            }
            self.draw_background();
            for pipe in self.pipes {
                pipe.draw(self.screen);
            }
            for bird in self.all_birds {
                bird.draw(self.screen);
            }
            self.draw_ui();
            self.draw_game_over();
            pygame.display.flip();
            self.clock.tick(60);
        }
        pygame.quit();
        print('\n👋 Thanks for playing! Come back anytime!');
    }
}
"""Main function"""
def main() {
    print(('=' * 50));
    print('🎮 FLAPPY BIRD: HUMAN vs AI');
    print(('=' * 50));
    print('🔴 RED = Human Player (YOU!)');
    print('🔵🟢🟡 = AI Players');
    print('\nControls:');
    print('  SPACE = Flap');
    print('  R = Restart (after game over)');
    print('  ESC = Quit');
    print('\nObjective: Get the highest score!');
    print(('=' * 50));
    game = FlappyGame();
    game.run();
}
with entry {
    if (__name__ == '__main__') {
        main();
    }
}