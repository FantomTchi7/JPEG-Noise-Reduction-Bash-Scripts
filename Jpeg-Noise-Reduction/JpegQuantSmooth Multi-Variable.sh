#!/bin/bash

# Check if input file was provided
if [ $# -eq 0 ]; then
    echo "Error: No input file specified."
    echo "Usage: $0 <input_file>"
    exit 1
fi

# Get the input file path and name
inputfile="$1"
filename=$(basename "$inputfile")
filename_noext="${filename%.*}"
filedir=$(dirname "$inputfile")

# Set the output directory
outputdir="${filedir}/${filename_noext}_JQS_results"

# Create the output directory if it doesn't exist
mkdir -p "$outputdir"

# Check if jpegqs tool exists
if ! command -v jpegqs &> /dev/null; then
    echo "Error: jpegqs not found in PATH."
    echo "Please ensure jpegqs is installed and available in /usr/bin."
    exit 1
fi

# Define array for niter values
niter_values=(3 5 10 20)

# Loop through quality values 1-6
for ((quality=1; quality<=6; quality++)); do
    # Loop through niter values
    for niter in "${niter_values[@]}"; do
        echo "Processing with quality $quality and niter $niter..."
        outputfile="${outputdir}/${filename_noext}_q${quality}_n${niter}.jpg"
        jpegqs -q "$quality" -n "$niter" "$inputfile" "$outputfile"
    done
done

echo "Processing complete. Results are in \"$outputdir\"."