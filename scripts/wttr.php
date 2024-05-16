<?php

const WWO_CODE = [
    "113" => "Sunny",
    "116" => "PartlyCloudy",
    "119" => "Cloudy",
    "122" => "VeryCloudy",
    "143" => "Fog",
    "176" => "LightShowers",
    "179" => "LightSleetShowers",
    "182" => "LightSleet",
    "185" => "LightSleet",
    "200" => "ThunderyShowers",
    "227" => "LightSnow",
    "230" => "HeavySnow",
    "248" => "Fog",
    "260" => "Fog",
    "263" => "LightShowers",
    "266" => "LightRain",
    "281" => "LightSleet",
    "284" => "LightSleet",
    "293" => "LightRain",
    "296" => "LightRain",
    "299" => "HeavyShowers",
    "302" => "HeavyRain",
    "305" => "HeavyShowers",
    "308" => "HeavyRain",
    "311" => "LightSleet",
    "314" => "LightSleet",
    "317" => "LightSleet",
    "320" => "LightSnow",
    "323" => "LightSnowShowers",
    "326" => "LightSnowShowers",
    "329" => "HeavySnow",
    "332" => "HeavySnow",
    "335" => "HeavySnowShowers",
    "338" => "HeavySnow",
    "350" => "LightSleet",
    "353" => "LightShowers",
    "356" => "HeavyShowers",
    "359" => "HeavyRain",
    "362" => "LightSleetShowers",
    "365" => "LightSleetShowers",
    "368" => "LightSnowShowers",
    "371" => "HeavySnowShowers",
    "374" => "LightSleetShowers",
    "377" => "LightSleet",
    "386" => "ThunderyShowers",
    "389" => "ThunderyHeavyRain",
    "392" => "ThunderySnowShowers",
    "395" => "HeavySnowShowers"
];

const WEATHER_SYMBOL = [
    "Unknown"             => "✨",
    "Cloudy"              => "󰖐",
    "Fog"                 => "󰖑",
    "HeavyRain"           => "󰖗",
    "HeavyShowers"        => "󰖗",
    "HeavySnow"           => "󰼶",
    "HeavySnowShowers"    => "󰼶",
    "LightRain"           => "󰖗",
    "LightShowers"        => "󰼴",
    "LightSleet"          => "󰖗",
    "LightSleetShowers"   => "󰖗",
    "LightSnow"           => "󰖘",
    "LightSnowShowers"    => "󰖘",
    "PartlyCloudy"        => "󰖕",
    "Sunny"               => "󰖙",
    "ThunderyHeavyRain"   => "󰙾",
    "ThunderyShowers"     => "󰙿",
    "ThunderySnowShowers" => "󰙿",
    "VeryCloudy"          => "󰖐",
];

$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, 'https://wttr.in/Omsk?format=j1');
curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($ch, CURLOPT_TIMEOUT, 120);
curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 120);

$data = curl_exec($ch);
curl_close($ch);
if ($data) {
    $json = json_decode($data, true);

    $feelsLike = $json['current_condition'][0]['FeelsLikeC'];
    $temperature = $json['current_condition'][0]['temp_C'];
    $humidity = $json['current_condition'][0]['humidity'];
    $windspeed = $json['current_condition'][0]['windspeedKmph'];
    $weatherCode = $json['current_condition'][0]['weatherCode'];

    $now = new \DateTime('now', new \DateTimeZone('Asia/Omsk'));
    $now->setTime($now->format('H'), 0);

    $hoursWeather = [];
    $i = 0;
    foreach ($json['weather'] as $days) {
        if ($i >= 5) {
            break;
        }
    
        $date = $days['date'];
        $hours = $days['hourly'];
        foreach ($hours as $hour) {
            if ($i >= 5) {
                break;
            }
            $dateObj = \DateTime::createFromFormat('Y-m-d H', $date . " " . ($hour['time']/100), new \DateTimeZone('Asia/Omsk'));
            if ($now < $dateObj) {
                $hoursWeather[] = [
                    'temp' => $hour['tempC'],
                    'icon' => WEATHER_SYMBOL[WWO_CODE[$hour['weatherCode']]],
                    'time' => str_pad($hour['time']/100, 2, "0", STR_PAD_LEFT)
                ];
                $i++;
            }
        }
    }

    $eww = [
        'temp' => $temperature,
        'feelsLike' => $feelsLike,
        'humidity' => $humidity,
        'windspeed' => $windspeed,
        'icon' => WEATHER_SYMBOL[WWO_CODE[$weatherCode]],
        'hourly' => $hoursWeather
    ];

    echo json_encode($eww);
} else {
    echo "{}";
}

