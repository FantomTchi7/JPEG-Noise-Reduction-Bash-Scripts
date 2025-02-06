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
outputdir="${filedir}/${filename_noext}_J2P_results"

# Create the output directory if it doesn't exist
mkdir -p "$outputdir"

# Check if jpeg2png tool exists
if ! command -v jpeg2png &> /dev/null; then
    echo "Error: jpeg2png not found in PATH."
    echo "Please ensure jpeg2png is installed and available in /usr/bin."
    exit 1
fi

# Define arrays for weights and iterations
weights=(0 0.25 0.3 0.5 0.75 1)
iterations=(50 75 100 125 150)

# Loop through all combinations
for weight in "${weights[@]}"; do
    # Replace dot with 'p' in weight for filename
    w_clean="${weight//./p}"
    
    for iter in "${iterations[@]}"; do
        echo "Processing with weight $weight and iterations $iter..."
        outputfile="${outputdir}/${filename_noext}_w${w_clean}_i${iter}.png"
        jpeg2png "$inputfile" -w "$weight" -i "$iter" -o "$outputfile"
    done
done

echo "Processing complete. Results are in \"$outputdir\"."