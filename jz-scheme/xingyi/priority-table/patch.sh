#!/bin/sh

patcher="python ../../../mb-tool/priority_patch.py"

cd $(dirname "$0")

$patcher abyz-ft.csv abyz-jp-patch.csv > abyz-jp.csv
$patcher abyz-ft.csv abyz-vi-patch.csv > abyz-vi.csv
