#!/bin/sh

patcher="python ../../../mb-tool/combine_dict.py"

cd $(dirname "$0")

$patcher abyz-zt.tsv abyz-jp-patch.tsv > abyz-jp.tsv
$patcher abyz-zt.tsv abyz-vi-patch.tsv > abyz-vi.tsv
