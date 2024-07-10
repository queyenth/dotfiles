<?php

function getRemindDate($time_task, $from = 'now') {
    // Possible values.
    // HH:mm something -> means add the reminder to that specific time today, or tomorrow if it's already past that
    // HH something -> just a shortcut for HH:00
    // :mm something -> just a shortcut for current hour:mm
    // +HH:mm -> add reminder to the future on +hours (maybe even days!)
    // +HH -> just a shortcut for +HH:00
    // +:mm -> just a shortcut for +00:mm
    $regexp = "/^(\+?)(\d{1,2})?:?(\d{1,2})?\s+(.*)$/";

    $current_date = new \DateTime('now', new \DateTimeZone("Asia/Omsk"));
    if (preg_match($regexp, $time_task, $matches) !== false) {
        $remind_date = new \DateTime('now', new \DateTimeZone("Asia/Omsk"));
        if ($from !== 'now') {
            $from = explode(':', $from);
            $remind_date->setTime($from[0], $from[1]);
        }
        // now in order to determine what we have we need to check whether
        // the first group is empty
        if ($matches[1] === "") {
            // This means we are in the fixed date mode
            if ($matches[2] === "") {
                $matches[2] = $current_date->format('H');
            }
            if ($matches[3] === "") {
                // If there's no minutes
                $matches[3] = "00";
            }

            $remind_date->setTime(intval($matches[2]), intval($matches[3]));

            // If it's in a past, add 1 hour until it's not.
            while ($remind_date <= $current_date) {
                $remind_date->modify("+1 hour");
            }
        } else {
            // This means add to the current date.
            if ($matches[2] === "") {
                $matches[2] = 0;
            }
            if ($matches[3] === "") {
                $matches[3] = 0;
            }

            $matches[2] = intval($matches[2]);
            $matches[3] = intval($matches[3]);

            $change_date = "+{$matches[2]} hours +{$matches[3]} minutes";

            $remind_date->modify($change_date);
        }

        return [$remind_date, $matches[4]];
    }

    return NULL;
}

if ($argc != 2) {
    fprintf(STDERR, "You should pass the time and task...\n");
    exit(1);
}

const SQLITE_DB = "/tmp/reminders.db";

$dbExists = file_exists(SQLITE_DB);
$pdo = new \PDO("sqlite:" . SQLITE_DB);
if (!$dbExists) {
    $pdo->exec("CREATE TABLE reminders (task_id INTEGER PRIMARY KEY, task_description TEXT, remind_date INTEGER)");
}

$time_task = $argv[1];
$current_date = new \DateTime('now', new \DateTimeZone('Asia/Omsk'));
if ($time_task === "show") {
    $stmt = $pdo->prepare("SELECT * FROM reminders WHERE remind_date > :current_date ORDER BY remind_date ASC");
    $stmt->execute([':current_date' => $current_date->getTimestamp()]);

    while ($task = $stmt->fetch(\PDO::FETCH_ASSOC)) {
        $date = new \DateTime('now', new \DateTimeZone('Asia/Omsk'));
        $date->setTimestamp($task['remind_date']);

        echo $date->format("j M, D, H:i") . ": {$task['task_description']}" . "\n";
    }
} else if ($time_task === "all") {
    $stmt = $pdo->prepare("SELECT * FROM reminders");
    $stmt->execute();
    while ($task = $stmt->fetch(\PDO::FETCH_ASSOC)) {
        var_dump($task);
    }
} else if ($time_task === "count") {
    $stmt = $pdo->prepare("SELECT count(*) FROM reminders WHERE remind_date > :current_date");
    $stmt->execute([':current_date' => $current_date->getTimestamp()]);

    echo $stmt->fetchColumn();
} else if ($time_task === "clear") {
    $stmt = $pdo->prepare("DELETE FROM reminders");
    $stmt->execute();
    echo "Deleted all reminders...";
} else if ($time_task === 'cron') {
    while (true) {
        $stmt = $pdo->prepare("SELECT * FROM reminders WHERE remind_date <= :current_date ORDER BY remind_date ASC");
        $stmt->execute([':current_date' => $current_date->getTimestamp()]);

        while ($task = $stmt->fetch(\PDO::FETCH_ASSOC)) {
            exec(sprintf("notify-send -t 3000 \"%s\" \"%s\"", "Reminder!", $task['task_description']));
            $value = exec("dunstctl is-paused");
            if ($value === "false") {
                exec("canberra-gtk-play -i message -d \"sendNotifier\"");
            }

            // $taskForLily = str_split($task['task_description'], 19);
            // for ($i = 0; $i < 4; $i++) {
            //     $str = $taskForLily[$i] ?? " ";
            //     exec("toLily $i \"$str\"");
            // }

            $sql = "DELETE FROM reminders WHERE task_id = :task_id";
            $stmt = $pdo->prepare($sql);
            $stmt->bindValue(':task_id', $task['task_id']);
            $stmt->execute();
        }

        sleep(30);
    }
} else {
    if ($data = getRemindDate($time_task)) {
        $sql = "INSERT INTO reminders (task_description, remind_date) VALUES (:task, :date)";
        $stmt = $pdo->prepare($sql);
        $stmt->bindValue(':date', $data[0]->getTimestamp());
        $stmt->bindValue(':task', $data[1]);
        $stmt->execute();

        exec("notify-send \"Reminder on " . $data[0]->format("j M, D, H:i") . "\" \"{$data[1]}\"");
        exit(0); // just in case we say all good.
    }
}
