#!/bin/bash

# Set CPU and memory usage limits (in percentage)
CPU_LIMIT=50.0
MEM_LIMIT=50.0

echo "Checking processes exceeding CPU usage > $CPU_LIMIT% or memory usage > $MEM_LIMIT%..."

# Use ps to get process info: PID, CPU%, MEM%, and command name
# Skip header line, then check each process
ps -eo pid,pcpu,pmem,comm --sort=-pcpu | tail -n +2 | while read -r pid cpu mem comm; do
  # Convert CPU and MEM to floats for comparison
  cpu_usage=$(printf "%.1f" "$cpu")
  mem_usage=$(printf "%.1f" "$mem")

  # Check if CPU or MEM usage exceeds limits
  cpu_exceeds=$(echo "$cpu_usage > $CPU_LIMIT" | bc)
  mem_exceeds=$(echo "$mem_usage > $MEM_LIMIT" | bc)

  if [[ "$cpu_exceeds" -eq 1 || "$mem_exceeds" -eq 1 ]]; then
    echo "Stopping process: PID=$pid, CPU=$cpu_usage%, MEM=$mem_usage%, COMMAND=$comm"
    kill -9 "$pid"
  fi
done

echo "Done."

#Make it executable-> chmod +x stop_heavy_processes.sh
#Run it as a superuser -> sudo ./stop_heavy_processes.sh
