#!/bin/bash

# Device and max brightness
DEVICE="amdgpu_bl2"
MAX_BRIGHTNESS=62451

# Check if argument was provided
if [ -z "$1" ]; then
  echo "Usage: $0 <brightness> (e.g. 10% or 31225)"
  exit 1
fi

# If input ends with %, treat it as a percentage
if [[ "$1" =~ ^([0-9]+)%$ ]]; then
  PERCENT=${BASH_REMATCH[1]}

  # Validate range
  if (( PERCENT < 0 || PERCENT > 100 )); then
    echo "Error: Percentage must be between 0% and 100%."
    exit 1
  fi

  # Convert percent to actual brightness
  BRIGHTNESS=$(( MAX_BRIGHTNESS * PERCENT / 100 ))

  echo "Setting brightness to $PERCENT% ($BRIGHTNESS)"
  sudo brightnessctl -d "$DEVICE" set "$BRIGHTNESS"

# Otherwise, assume integer value
elif [[ "$1" =~ ^[0-9]+$ ]]; then
  if (( $1 < 0 || $1 > MAX_BRIGHTNESS )); then
    echo "Error: Value must be between 0 and $MAX_BRIGHTNESS."
    exit 1
  fi

  echo "Setting brightness to $1"
  sudo brightnessctl -d "$DEVICE" set "$1"

else
  echo "Invalid input. Use a number (e.g. 31225) or percentage (e.g. 10%)."
  exit 1
fi

