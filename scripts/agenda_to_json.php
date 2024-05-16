<?php

const EWW_CMD = "~/src/eww/target/release/eww";

$date = (new \DateTimeImmutable('now', new \DateTimeZone('Asia/Omsk')))->format('Y-m-d');
if ($argc == 2) {
    $date = $argv[1];
}

$command = "emacs -batch -l ~/.config/emacs/init-org.el -eval '(progn (org-agenda nil \"A\") (org-batch-agenda-csv \"A\" org-agenda-start-day \"{$date}\"))' 2>/dev/null";
exec($command, $output);

$keys = ['category', 'head', 'type', 'todo', 'tags', 'date', 'time', 'extra', 'priority-l', 'priority-n', 'agenda-day'];

$orgLinkRegex = '/\[\[(.*)\]\[(.*)\]\]/';

$output = array_map(fn ($x) => array_combine($keys, str_getcsv(preg_replace($orgLinkRegex, "$2", $x))), $output);

$result = [];
// What I wand to do is to separate arrays by category.
foreach ($output as $item) {
    // Build agenda-day first
    if ($item['agenda-day'] !== '') {
        if (!isset($result['agenda-day'])) {
            $result['agenda-day'] = [];
        }
        if ($item['time'] != '' && $item['category'] === '') {
            $item['time'] = str_pad($item['time'], 11, 0, STR_PAD_LEFT);
        }
        $result['agenda-day'][] = $item;
    } else if (!isset($result[$item['category']])) {
        $result[$item['category']] = [];
    }

    $result[$item['category']][] = $item;
}

echo json_encode($result);
