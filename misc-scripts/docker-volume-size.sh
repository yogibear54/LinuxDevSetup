#!/bin/bash
docker system df -v | awk '
function to_gb(value, unit) {
    if (unit == "B")   return value / (1024 * 1024 * 1024)
    if (unit == "kB")  return value / (1024 * 1024)
    if (unit == "MB")  return value / 1024
    if (unit == "GB")  return value
    if (unit == "TB")  return value * 1024
    return 0
}

{
    size = $3
    unit = ""
    value = 0

    # Separate value and unit manually
    for (i = 1; i <= length(size); i++) {
        ch = substr(size, i, 1)
        if ((ch < "0" || ch > "9") && ch != ".") {
            value = substr(size, 1, i - 1) + 0
            unit = substr(size, i)
            break
        }
    }

    total += to_gb(value, unit)
}
END {
    printf "Total Docker volume size: %.4f GB\n", total
}'

