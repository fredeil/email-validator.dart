#!/bin/bash

set -e

DIR=$( cd $( dirname "${BASH_SOURCE[0]}" )/.. && pwd )

echo "Analyzing library for warnings or type errors"
dart --checked $DIR/test/test.dart

echo -e "\n[32m✓ OK[0m"