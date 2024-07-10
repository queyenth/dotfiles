<?php declare(strict_types=1);

if (!file_exists("/tmp/labwc.fifo")) {
    fprintf(STDERR, "FIFO at /tmp/labwc.fifo does not exists!");
    exit(1);
}


// Mask for all possible workspace statuses
// 0 = free, unfocused
// 1 = occupied, unfocused
// 2 = free, focused
// 3 = occupied, focused
const OCCUPIED = 1;
const FOCUSED = 2;

while (($buffer = file_get_contents("/tmp/labwc.fifo")) !== false) {
    $data = json_decode(trim($buffer), true);
    if (is_array($data) && isset($data['workspaces'])) {
        $return = [];
        foreach ($data['workspaces'] as $workspace) {
            $status = $workspace['status'];
            if ($status & FOCUSED) {
                $return[] = "";
            } else if ($status & OCCUPIED) {
                $return[] = "";
            } else {
                $return[] = "";
            }
        }
        fprintf(STDOUT, "%s\n", implode(" ", $return));
        fflush(STDOUT);
    }
}
