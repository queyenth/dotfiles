<?php declare(strict_types=1);

require_once('bindings.php');

$vars = Variables::getInstance();
$vars->addMany([
   'mod' => 'Mod4',
   'left' => 'm',
   'down' => 'n',
   'up' => 'e',
   'right' => 'i',
   'term' => 'alacritty',
   'ws1' => 'α',
   'ws2' => 'β',
   'ws3' => 'γ',
   'ws4' => 'δ',
   'ws5' => 'ε',
   'ws6' => 'ζ',
   'ws7' => 'η',
   'ws8' => 'θ',
   'ws9' => 'ι',
   'ws0' => 'λ',
   'base' => '#faf4ed',
   'surface' => '#fffaf3',
   'overlay' => '#f2e9e1',
   'muted' => '#9893a5',
   'subtle' => '#797593',
   'text' => '#575279',
   'love' => '#b4637a',
   'gold' => '#ea9d34',
   'rose' => '#d7827e',
   'pine' => '#286983',
   'foam' => '#56949f',
   'iris' => '#907aa9',
   'highlightlow' => '#f4ede8',
   'highlightmed' => '#dfdad9',
   'highlighthigh' => '#cecacd',
]);

$vars->add(
    'dmenu_cmd',
    sprintf(
        '-b -h 25 -i -nb "%s" -nf "%s" -sb "%s" -sf "%s"',
        $vars->getAs('base'),
        $vars->getAs('text'),
        $vars->getAs('rose'),
        $vars->getAs('surface'),
    )
);

$vars->add(
    'menu',
    sprintf(
        '~/scripts/sway_run %s',
        $vars->getAs('dmenu_cmd'),
    )
);

$vars->add(
    'passmenu',
    sprintf(
        'passmenu %s',
        $vars->getAs('dmenu_cmd'),
    )
);

$vars->add(
    'passmenu_type',
    sprintf(
        'passmenu --type %s',
        $vars->getAs('dmenu_cmd'),
    )
);

$vars->add(
    'windowswitch',
    sprintf(
        '~/scripts/switch_window.sh -l 5 %s',
        $vars->getAs('dmenu_cmd'),
    )
);

$vars->add(
    'closeewwwindow',
    sprintf(
        '~/scripts/close_eww_window.sh %s',
        $vars->getAs('dmenu_cmd'),
    )
);

$vars->add(
    'clipman',
    sprintf(
        'clipman pick --err-on-no-selection --tool=CUSTOM --tool-args="dmenu-wl -l 5 %s" && wtype -M shift -k Insert',
        $vars->getAs('dmenu_cmd'),
    )
);

$wmLayout = new Mode(
    "wm-layout",
    [
        new Binding("h", "splith", CommandType::Sway, "default"),
        new Binding("v", "splitv", CommandType::Sway, "default"),
        new Binding("s", "layout stacking", CommandType::Sway, "default"),
        new Binding("t", "layout tabbed", CommandType::Sway, "default"),
        new Binding("c", "move position center", CommandType::Sway, "default"),
        new Binding("d", "layout toggle split", CommandType::Sway, "default"),
        new Binding("f", "fullscreen", CommandType::Sway, "default"),
        new Binding("space", "floating toggle", CommandType::Sway, "default"),
        new Binding("Ctrl+space", "focus mode_toggle", CommandType::Sway, "default"),
        new Binding("Escape", "default", CommandType::Mode),
        new Binding($vars->getAs('mod') . "+g", "default", CommandType::Mode),
    ]
);

$wmRun = new Mode(
    "wm-run",
    [
        new Binding("t", $vars->getAs('term'), CommandType::Exec, "default", $vars->get('term')),
        new Binding("Return", $vars->getAs('term'), CommandType::Exec, "default", $vars->get('term')),
        new Binding("r", $vars->getAs('menu'), CommandType::Exec, "default", 'dmenu'),
        new Binding("w", $vars->getAs('windowswitch'), CommandType::Exec, "default", 'window switch'),
        new Binding("y", $vars->getAs('passmenu'), CommandType::Exec, "default", 'passmenu'),
        new Binding("Ctrl+y", $vars->getAs('passmenu_type'), CommandType::Exec, "default", 'passmenu type'),
        new Binding("e", '~/scripts/runem', CommandType::Exec, "default", "emacs"),
        new Binding("n", 'swaync-client -t -sw', CommandType::Exec, "default", "swaync"),
        new Binding("Escape", "default", CommandType::Mode),
        new Binding($vars->getAs('mod') . "+g", "default", CommandType::Mode),
    ]
);

$resize = new Mode(
    "resize",
    [
        new Binding($vars->getAs('left'), "resize shrink width 10px", CommandType::Sway, null, "-w"),
        new Binding($vars->getAs('down'), "resize grow height 10px", CommandType::Sway, null, "+h"),
        new Binding($vars->getAs('up'), "resize shrink height 10px", CommandType::Sway, null, "-h",),
        new Binding($vars->getAs('right'), "resize grow width 10px", CommandType::Sway, null, "+w"),
        new Binding("Left", "resize shrink width 10px", CommandType::Sway, null, "-w"),
        new Binding("Down", "resize grow height 10px", CommandType::Sway, null, "+h"),
        new Binding("Up", "resize shrink height 10px", CommandType::Sway, null, "-h"),
        new Binding("Right", "resize grow width 10px", CommandType::Sway, null, "+w"),
        new Binding("Escape", "default", CommandType::Mode),
        new Binding($vars->getAs('mod') . "+g", "default", CommandType::Mode),
    ]
);

$wm = new Mode(
    "default",
    [
        new Binding($vars->getAs('left'), "focus left", CommandType::Sway),
        new Binding($vars->getAs('down'), "focus down", CommandType::Sway),
        new Binding($vars->getAs('up'), "focus up", CommandType::Sway),
        new Binding($vars->getAs('right'), "focus right", CommandType::Sway),
        new Binding("Left", "focus left", CommandType::Sway),
        new Binding("Down", "focus down", CommandType::Sway),
        new Binding("Up", "focus up", CommandType::Sway),
        new Binding("Right", "focus right", CommandType::Sway),
        new Binding("Ctrl+" . $vars->getAs('left'), "move left", CommandType::Sway),
        new Binding("Ctrl+" . $vars->getAs('down'), "move down", CommandType::Sway),
        new Binding("Ctrl+" . $vars->getAs('up'), "move up", CommandType::Sway),
        new Binding("Ctrl+" . $vars->getAs('right'), "move right", CommandType::Sway),
        new Binding("Ctrl+Left", "move left", CommandType::Sway),
        new Binding("Ctrl+Down", "move down", CommandType::Sway),
        new Binding("Ctrl+Up", "move up", CommandType::Sway),
        new Binding("Ctrl+Right", "move right", CommandType::Sway),
        new Binding("o", "focus next", CommandType::Sway),
        new Binding("Shift+o", "focus prev", CommandType::Sway),
        new Binding("k", "kill", CommandType::Sway),
        new Binding("z", "focus parent", CommandType::Sway),
        new Binding("l", $wmLayout->getName(), CommandType::Mode),
        new Binding("space", "focus next", CommandType::Sway),
        new Binding("Tab", "workspace back_and_forth", CommandType::Sway),
        new Binding("Ctrl+r", "reload", CommandType::Sway),
        new Binding("Ctrl+c", "swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -B 'Yes, exit sway' 'swaymsg exit'", CommandType::Exec, null, "exit"),
        new Binding("Ctrl+l", "swaylock -f -c 000000", CommandType::Exec, null, "lock"),
        new Binding("minus", "scratchpad show", CommandType::Sway),
        new Binding("Ctrl+minus", "move scratchpad", CommandType::Sway),
        new Binding("plus", "sticky toggle", CommandType::Sway),
        new Binding("apostrophe", "~/scripts/mark_window", CommandType::Exec, null, "mark"),
        new Binding("Shift+r", $resize->getName(), CommandType::Mode),
        new Binding("x", $wmRun->getName(), CommandType::Mode),
        new Binding("r", $vars->getAs('menu'), CommandType::Exec, null, "dmenu"),
        new Binding("y", $vars->getAs('passmenu'), CommandType::Exec, "default", 'passmenu'),
        new Binding("Ctrl+y", $vars->getAs('passmenu_type'), CommandType::Exec, "default", 'passmenu type'),
        new Binding("w", $vars->getAs('windowswitch'), CommandType::Exec, null, "window switch"),
        new Binding("t", $vars->getAs('term'), CommandType::Exec),
        new Binding("p", $vars->getAs('clipman'), CommandType::Exec, null, "clipman"),
        new Binding("c", $vars->getAs('closeewwwindow'), CommandType::Exec, null, "close eww window"),
        new Binding("Return", $vars->getAs('term'), CommandType::Exec),
    ]
);
foreach (range(1, 10) as $i) {
    $ws = $i === 10 ? 0 : $i;
    $wm->addKey(new Binding("$ws", "workspace $i " . $vars->getAs("ws$ws"), CommandType::Sway));
    $wm->addKey(new Binding("Ctrl+$ws", "move container to workspace $i " . $vars->getAs("ws$ws"), CommandType::Sway));
}

$wm->mapKeys(fn ($x) => $x->setKey($vars->getAs('mod') . '+' . $x->getKey()));

$wm->addKey(new Binding("Print", "grimshot copy area", CommandType::Exec));
$wm->addKey(new Binding("Ctrl+Print", "~/scripts/screen_save", CommandType::Exec));
$wm->addKey(new Binding("XF86AudioRaiseVolume", "~/scripts/volumenotify + 5", CommandType::Exec));
$wm->addKey(new Binding("XF86AudioLowerVolume", "~/scripts/volumenotify - 5", CommandType::Exec));
$wm->addKey(new Binding("Ctrl+XF86AudioRaiseVolume", "~/scripts/volumenotify + 1", CommandType::Exec));
$wm->addKey(new Binding("Ctrl+XF86AudioLowerVolume", "~/scripts/volumenotify - 1", CommandType::Exec));
$wm->addKey(new Binding("Shift+XF86AudioRaiseVolume", "~/scripts/volumenotify + 10", CommandType::Exec));
$wm->addKey(new Binding("Shift+XF86AudioLowerVolume", "~/scripts/volumenotify - 10", CommandType::Exec));
$wm->addKey(new Binding("XF86AudioMute", "~/scripts/volumenotify !", CommandType::Exec));
$wm->addKey(new Binding("XF86AudioPlay", "playerctl play-pause", CommandType::Exec));
$wm->addKey(new Binding("XF86AudioPrev", "playerctl previous", CommandType::Exec));
$wm->addKey(new Binding("XF86AudioNext", "playerctl next", CommandType::Exec));

// // So we add "insert mode" keybinding
// $wm->addKey(new Binding("s", $default->getName(), CommandType::Mode));

// And keybidings to smash menu key to get to "normal mode"
// $wm->addKey(new Binding("Menu", $wm->getName(), CommandType::Mode));
// $resize->addKey(new Binding("Menu", $wm->getName(), CommandType::Mode));
// $wmLayout->addKey(new Binding("Menu", $wm->getName(), CommandType::Mode));
// $wmRun->addKey(new Binding("Menu", $wm->getName(), CommandType::Mode));
// $default->addKey(new Binding("Menu", $wm->getName(), CommandType::Mode));

$which_key_toggle = "~/scripts/close_eww_window.sh --window which_key";
$wm->addKey(new Binding($vars->getAs('mod') . "+question", $which_key_toggle, CommandType::Exec, null, "which-key"));
$wmLayout->addKey(new Binding("question", $which_key_toggle, CommandType::Exec, null, "which-key"));
$wmRun->addKey(new Binding("question", $which_key_toggle, CommandType::Exec, null, "which-key"));
$resize->addKey(new Binding("question", $which_key_toggle, CommandType::Exec, null, "which-key"));

$keys = new Keymap();
$keys->addMode($resize);
$keys->addMode($wmLayout);
$keys->addMode($wmRun);
$keys->addMode($wm);
// $keys->addMode($default);

FormatterRegistry::register(JsonFormatter::class);
FormatterRegistry::register(EwwFormatter::class);
FormatterRegistry::register(SwayFormatter::class);

$formatter = FormatterFactory::create($argc, $argv);
echo $formatter->format($vars, $keys);
echo "\n";
fflush(STDOUT);

// Local Variables:
// compile-command: (format "php %s sway > ~/.config/sway/00-bindings && swaymsg reload" (buffer-file-name))
// End:
