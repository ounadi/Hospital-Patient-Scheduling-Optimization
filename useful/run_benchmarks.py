import os
import subprocess
import time

TIMEOUT = 300  # 5 minutes

def run_mzn_benchmark(model_file, instance_file):
    start_time = time.time()
    result = subprocess.run(
        ["minizinc", "--solver", "gecode", model_file, instance_file, "--time-limit", str(TIMEOUT * 1000)],
        capture_output=True,
        text=True,
    )
    end_time = time.time()
    execution_time = end_time - start_time
    return execution_time, result.stdout

if __name__ == "__main__":
    model_file = "hospital_scheduler.mzn"
    instances_directory = "instances"
    output_file = "benchmark_results_minizinc.txt"

    complexities = ["easy", "average", "hard"]
    results = []

    with open(output_file, "w") as f:
        for complexity in complexities:
            instance_count = 4 if complexity != "hard" else 2
            for i in range(instance_count):
                instance_file = os.path.join(instances_directory, f"instance_{complexity}_{i}.dzn")
                
                if not os.path.isfile(instance_file):
                    print(f"Instance file {instance_file} not found.")
                    continue
                
                print(f"Running {instance_file}...")
                mzn_time, mzn_output = run_mzn_benchmark(model_file, instance_file)

                if mzn_time >= TIMEOUT:
                    status = "Timeout"
                else:
                    status = "Completed"

                f.write(f"MiniZinc - {complexity} instance {i}: {mzn_time:.2f} seconds ({status})\n")
                f.write(mzn_output + "\n\n")

                results.append([complexity, i, mzn_time, status])

    print(f"Benchmark results written to {output_file}.")
