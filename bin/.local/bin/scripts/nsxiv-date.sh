#!/bin/bash

find "$1" -type f -exec ls -t {} + | nsxiv -i -t
