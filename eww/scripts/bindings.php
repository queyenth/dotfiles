<?php declare(strict_types=1);

final class Optional {
    public function __construct(
        private mixed $value = null
    ) {}

    public function __invoke(callable $f): self {
        return $this->fmap($f);
    }

    public function __call(string $name, array $arguments): self {
        return $this->fmap(fn ($x) => call_user_func_array([$x, $name], $arguments));
    }

    public function fmap(callable $f): self {
        if ($this->isPresent()) {
            $return = $f($this->value);
            if ($return instanceof self) {
                return $return;
            }
            return new self($return);
        }
        return $this;
    }

    public function isPresent(): bool {
        return !is_null($this->value);
    }

    public function get() {
        return $this->isPresent() ? $this->value : throw new Exception("No value, dummy");
    }

    public function orElse($default) {
        return $this->isPresent() ? $this->value : $default;
    }
}

interface Arrayable {
    public function toArray(): array;
}

enum CliOptionType : string {
    case Str = 'string';
    case Num = 'number';

    public function validate(mixed $value): bool {
        return match ($this) {
            self::Str => is_string($value),
            self::Num => is_numeric($value)
        };
    }

    public function convert(mixed $value): mixed {
        if ($this->validate($value)) {
            return match ($this) {
                self::Str => $value,
                self::Num => intval($value)
            };
        }
        throw new Exception("Wrong argument type");
    }
}

class CliOption {
    public Optional $default;
    public function __construct(
        public string $name,
        public bool $required,
        public CliOptionType $type,
        mixed $default = null
    ) {
        $this->default = new Optional($default);
    }
}

abstract class ConfigFormatter {
    public function __construct(
        protected array $cli = []
    ) {}
    public function setCli(array $cli): self {
        $this->cli = $cli;
        return $this;
    }
    abstract public function name(): string;
    abstract public function options(): array;
    abstract public function format(Variables $vars, Keymap $keys): string;
}

class FormatterRegistry {
    private function __construct() {}

    private static array $formatters = [];
    public static function register(string $formatter) {
        static::$formatters[] = $formatter;
    }

    public static function getAll(): array {
        return static::$formatters;
    }
}

class FormatterFactory {
    public static function create(int $argc, array $argv): ConfigFormatter {
        $formatters = FormatterRegistry::getAll();
        if (isset($argv[1])) {
            foreach ($formatters as $formatter) {
                $formatter = new $formatter();
                if ($argv[1] === $formatter->name()) {
                    $options = $formatter->options();
                    $requiredOptions = array_filter($options, fn ($x) => $x->required && !$x->default->isPresent());
                    if ($argc - 2 >= count($requiredOptions) && $argc - 2 <= count($options)) {
                        $keys = array_map(fn ($x) => $x->name, $options);
                        $values = array_slice($argv, 2);
                        if (count($values) < count($keys)) {
                            $missingKeys = array_slice($options, count($values), count($keys) - count($values), true);
                            $values = array_merge($values, array_map(fn ($x) => $x->default->orElse(null), $missingKeys));
                        }
                        $values = array_map(fn ($x) => new Optional($x), $values);
                        foreach ($values as $i => $val) {
                            $option = $options[$i];
                            try {
                                $values[$i] = $values[$i]->fmap(fn ($x) => $option->type->convert($x));
                            } catch (Exception $e) {
                                fprintf(STDERR, "Wrong argument type for argument %s (should be %s)\n", $option->name, $option->type->value);
                                fprintf(STDERR, "usage: %s %s ", $argv[0], $argv[1]);
                                foreach ($options as $option) {
                                    fprintf(STDERR, "%s ", $option->required ? $option->name : "[{$option->name}]");
                                }
                                fprintf(STDERR, "\n");
                                exit(1);
                            }
                        }
                        $args = array_combine(
                            $keys,
                            $values
                        );
                        return $formatter->setCli($args);
                    } else {
                        fprintf(STDERR, "usage: %s %s ", $argv[0], $argv[1]);
                        foreach ($options as $option) {
                            fprintf(STDERR, "%s ", $option->required ? $option->name : "[{$option->name}]");
                        }
                        fprintf(STDERR, "\n");
                        exit(1);
                    }
                }
            }
        }
        $names = array_map(fn ($x) => (new $x())->name(), $formatters);
        fprintf(STDERR, "usage: %s <%s> ...", $argv[0], implode('|', $names));
        exit(1);
    }
}

class EwwFormatter extends ConfigFormatter {
    const DEFAULT_IN_ROW = 4;
    public function name(): string {
        return 'eww';
    }

    public function options(): array {
        return [
            new CliOption('mode', true, CliOptionType::Str),
            new CliOption('in_row', true, CliOptionType::Num, self::DEFAULT_IN_ROW)
        ];
    }

    public function format(Variables $vars, Keymap $keys): string {
        $mode = $this->cli['mode']->get();
        $modeBindings = $keys->getMode($mode);
        if ($modeBindings->isPresent()) {
            $bindings = array_map(fn ($x) => $x->toArray(), $modeBindings->getKeys()->get());
            return json_encode($this->split($bindings, intval($this->cli['in_row']->get())));
        }

        return json_encode([]);
    }

    private function split(array $array, int $n) {
        $n = max(1, $n);
        $result = [];
        while (count($array) > $n) {
            $result[] = array_splice($array, 0, $n);
        }
        if (count($array)) {
            $result[] = $array;
        }

        return $result;
    }
}

class JsonFormatter extends ConfigFormatter {
    public function name(): string {
        return 'json';
    }

    public function options(): array {
        return [
            new CliOption('mode', false, CliOptionType::Str)
        ];
    }

    public function format(Variables $vars, Keymap $keys): string {
        $mode = $this->cli['mode'];
        $modeBindings = $mode->fmap(fn ($x) => $keys->getMode($x));
        if (!$mode->isPresent()) {
            $bindings = array_map(
                fn ($modeKeys) => array_map(fn ($x) => $x->toArray(), $modeKeys->getKeys()),
                $keys->getAllModes()
            );
            return json_encode($bindings);
        } else if ($modeBindings->isPresent()) {
            $bindings = array_map(fn ($x) => $x->toArray(), $modeBindings->getKeys()->get());
            return json_encode($bindings);
        }

        return json_encode([]);
    }
}

class SwayFormatter extends ConfigFormatter {
    public function name(): string {
        return 'sway';
    }

    public function options(): array {
        return [];
    }

    public function format(Variables $vars, Keymap $keys): string {
        $result = "";
        $variables = [];
        foreach ($vars->toArray() as $var => $data) {
            $variables[] = sprintf('set %s %s', $vars->getAs($var), $vars->get($var));
        }
        $result .= implode("\n", $variables) . "\n";
        foreach ($keys->getAllModes() as $mode => $modeBindings) {
            $modeFormat = $mode === 'default' ? "%s\n" : "mode $mode {\n%s\n}\n";
            $bindingFormat = 'bindsym --to-code %s %s';
            if ($mode !== 'default') {
                $bindingFormat = '    ' . $bindingFormat;
            }
            $result .= sprintf(
                $modeFormat,
                implode("\n",
                        array_map(
                            function ($data) use ($bindingFormat) {
                                $data = $data->toArray();
                                return sprintf($bindingFormat, $data['key'], $data['command']);
                            },
                            $modeBindings->getKeys()
                        )
                )
            );
        }
        return $result;
    }
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

class Variables implements Arrayable {
    private function __construct(
        private array $vars = []
    ) {}

    private static ?self $instance = null;
    public static function getInstance(): self {
        if (is_null(static::$instance)) {
            static::$instance = new self();
        }
        return static::$instance;
    }

    public function addMany(array $vars) {
        foreach ($vars as $name => $data) {
            $this->add($name, $data);
        }
    }

    public function add(string $name, string $data) {
        $this->vars[$name] = $data;
    }

    public function getAs($name): string {
        if (isset($this->vars[$name])) {
            return '$' . $name;
        }
        throw new Exception("Variable $name does not exists");
    }

    public function get($name): string {
        return $this->vars[$name] ?? throw new Exception("Variable $name does not exists");
    }

    public function toArray(): array {
        return $this->vars;
    }
}

class Binding implements Arrayable {
    public function __construct(
        private string $key,
        private string $command,
        private CommandType $type,
        private ?string $switchTo = null,
        private ?string $which_command = null,
        private ?Variables $vars = null
    ) {
        if ($this->vars === null) {
            $this->vars = Variables::getInstance();
        }
    }

    public function setKey(string $key): self {
        $this->key = $key;
        return $this;
    }

    public function getKey(): string {
        return $this->key;
    }

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
            "which_key" => $this->whichKey($this->key),
            "which_command" => $this->whichCommand($this->type->getCommand($this->command)),
            "class" => $this->type->value
        ];
    }

    public function setSwitchTo($switchTo): self {
        $new = clone $this;
        $new->switchTo = $switchTo;
        return $new;
    }

    private function whichKey(string $key): string {
        // parse key
        $key = trim($key);
        $parts = explode('+', $key);
        foreach ($parts as &$part) {
            $part = trim($part);
            if ($part[0] === '$') {
                $part = $this->vars->get(substr($part, 1));
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

    private function whichCommand(string $command): string {
        if ($this->which_command) {
            return $this->which_command;
        }

        return match ($this->type) {
            CommandType::Sway => $this->substitute_variables($command),
            CommandType::Mode => '+' . $this->substitute_variables($command),
            CommandType::Exec => $this->substitute_variables($command)
        };
    }

    private function substitute_variables(string $command): string {
        $command = trim($command);
        $command = explode(' ', $command);
        foreach ($command as &$part) {
            $part = trim($part);
            if ($part[0] === '$') {
                $part = $this->vars->get(substr($part, 1));
            }
        }
        return implode(' ', $command);
    }
}

class Mode implements Arrayable {
    private static $modes = [];
    public function __construct(
        private string $name,
        private array $keys
    ) {
        static::registerMode($name);
    }

    public static function registerMode(string $name) {
        static::$modes[$name] = true;
    }

    public static function modeExists(string $name): bool {
        return isset(static::$modes[$name]);
    }

    public function getName(): string {
        return $this->name;
    }

    public function addKey(Binding $key): self {
        $this->keys[] = $key;
        return $this;
    }

    public function getKeys(): array {
        return $this->keys;
    }

    public function mapKeys(callable $fn): self {
        $this->keys = array_map($fn, $this->keys);
        return $this;
    }

    public function toArray(): array {
        return array_map(fn ($x) => $x->toArray(), $this->keys);
    }
}

class Keymap {
    public function __construct(
        private array $modes = []
    ) {}

    public function addMode(Mode $mode): self {
        $this->modes[$mode->getName()] = $mode;
        return $this;
    }

    public function getMode(string $name): Optional {
        return new Optional($this->modes[$name] ?? null);
    }

    public function getAllModes(): array {
        return $this->modes;
    }
}
