<?php declare(strict_types=1);

interface Jsonable {
    public function toJson(): string;
}

interface Arrayable {
    public function toArray(): array;
}

interface Swayable {
    public function toSway(): string;
}

enum CommandType : string {
    case Sway = '';
    case Exec = 'exec';
    case Mode = 'mode';

    public function getCommand(string $command): string {
        if ($this === CommandType::Mode) {
            if (!Mode::modeExists($command)) {
                throw new Exception("Mode $command does not exists!");
            }
        }
        return trim($this->value . ' ' . $command);
    }
}

class Variables {
    private static array $vars = [];
    public function __construct(
    ) {}

    public static function addMany(array $vars) {
        foreach ($vars as $name => $data) {
            static::add($name, $data);
        }
    }

    public static function add(string $name, string $data) {
        static::$vars[$name] = $data;
    }

    public static function getAs($name): string {
        if (isset(static::$vars[$name])) {
            return '$' . $name;
        }
        throw new Exception("Variable $name does not exists");
    }

    public static function get($name): string {
        return static::$vars[$name] ?? throw new Exception("Variable $name does not exists");
    }

    public static function toSway(): string {
        $variables = [];
        foreach (static::$vars as $var => $data) {
            $variables[] = sprintf('set %s %s', static::getAs($var), static::get($var));
        }
        return implode("\n", $variables);
    }
}
function emacs_like(string $key, string $command): string {
    // parse key
    $key = trim($key);
    $parts = explode('+', $key);
    foreach ($parts as &$part) {
        $part = trim($part);
        if ($part[0] === '$') {
            $part = Variables::get(substr($part, 1));
        } else if ($part === 'Shift') {
            $part = 'S';
        } else if ($part === 'Ctrl') {
            $part = 'C';
        } else if ($part === 'question') {
            $part = '?';
        } else if ($part === 'minus') {
            $part = '-';
        } else if ($part === 'plus') {
            $part = '+';
        }
    }
    return implode('-', $parts);
}

function substitute_variables(string $key, string $command): string {
    $command = trim($command);
    $command = explode(' ', $command);
    foreach ($command as &$part) {
        $part = trim($part);
        if ($part[0] === '$') {
            $part = Variables::get(substr($part, 1));
        }
    }
    return implode(' ', $command);
}

class Binding implements Jsonable, Arrayable, Swayable {
    public function __construct(
        private string $key,
        private string $command,
        private CommandType $type,
        private ?string $switchTo = null,
        private ?string $which_command = null
    ) {}

    public function toArray(): array {
        $command = $this->type->getCommand($this->command);
        if ($this->switchTo) {
            if (Mode::modeExists($this->switchTo)) {
                if ($this->type !== CommandType::Mode) {
                    $command = sprintf("mode %s, %s", $this->switchTo, $command);
                }
            } else {
                throw new Exception("Cannot switch to mode {$this->switchTo}, not exists!");
            }
        }
        return [
            "key" => $this->key,
            "command" => $command,
            "which_key" => $this->whichKey($this->key, $command, 'emacs_like'),
            "which_command" => $this->whichCommand($this->key, $this->type->getCommand($this->command), 'substitute_variables'),
            "class" => $this->type->value
        ];
    }

    public function toJson(): string {
        return json_encode($this->toArray());
    }

    public function toSway(): string {
        $data = $this->toArray();
        return sprintf("bindsym --to-code %s %s", $data['key'], $data['command']);
    }

    public function setSwitchTo($switchTo): self {
        $new = clone $this;
        $new->switchTo = $switchTo;
        return $new;
    }

    private function whichKey(string $key, string $command, callable $formatter): string {
        return $formatter($key, $command);
    }

    private function whichCommand(string $key, string $command, callable $formatter): string {
        if ($this->which_command) {
            return $this->which_command;
        }

        return match ($this->type) {
            CommandType::Sway => $formatter($key, $command),
            CommandType::Mode => '+' . $formatter($key, $this->command),
            CommandType::Exec => $formatter($key, $this->command)
        };
    }
}

class Mode implements Jsonable, Swayable {
    private static $modes = ["default" => true];
    public function __construct(
        private string $name,
        private array $keys
    ) {
        static::registerMode($name);
    }

    public static function registerMode(string $name) {
        if (static::modeExists($name)) {
            throw new Exception("Mode $name already exists!");
        }
        static::$modes[$name] = true;
    }

    public static function modeExists(string $name): bool {
        return isset(static::$modes[$name]);
    }

    public function getName(): string {
        return $this->name;
    }

    public function toJson(): string {
        return json_encode(array_map(fn ($x) => $x->toArray(), $this->keys));
    }

    public function addKey(Binding $key): self {
        $this->keys[] = $key;
        return $this;
    }

    public function getKeys(): array {
        return $this->keys;
    }

    public function toSway(): string {
        return sprintf(
            "mode %s {\n%s\n}",
            $this->name,
            implode("\n", array_map(
               function ($key) {
                   return sprintf("    %s", $key->toSway());
               },
               $this->keys
           ))
        );
    }

    public function addDefault(): self {
        static $defaultExit = [
            new Binding("g", "default", CommandType::Mode),
            new Binding("Ctrl+g", "default", CommandType::Mode),
            new Binding("Escape", "default", CommandType::Mode),
            new Binding("Menu", "default", CommandType::Mode),
            new Binding("question", "~/.config/eww/scripts/toggle_which_key", CommandType::Exec, null, "which-key"),
        ];
        $this->keys = array_merge($this->keys, $defaultExit);
        return $this;
    }
}
