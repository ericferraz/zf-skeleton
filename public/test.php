<?php

$rec = ['MOT2-01-20150904-112357-1A19E151', null, 'MOT2-01-20150904-113344-473EB584', 'MOT2-01-20150904-113446-6605C6D3'];

$arr = ['data' => array_filter($rec)];

var_dump(count($rec));
var_dump(json_encode($arr)) . PHP_EOL;