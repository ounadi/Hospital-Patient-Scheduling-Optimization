import os
import subprocess
import time

TIMEOUT = 300  # 5 minutes

def run_asp_benchmark(hospital_constraints, instance_file):
    start_time = time.time()
    result = subprocess.run(
        ["clingo", hospital_constraints, instance_file, "--time-limit", str(TIMEOUT)],
        capture_output=True,
        text=True,
    )
    end_time = time.time()
    execution_time = end_time - start_time
    return execution_time, result.stdout

if __name__ == "__main__":
    hospital_constraints = "hospital_constraints.lp"
    instances_directory = "instances"
    output_file = "benchmark_results.txt"

    complexities = ["easy", "average", "hard"]
    results = []

    with open(output_file, "w") as f:
        for complexity in complexities:
            instance_count = 4 if complexity != "hard" else 2
            for i in range(instance_count):
                instance_file = os.path.join(instances_directory, f"instance_{complexity}_{i}.lp")
                
                if not os.path.isfile(instance_file):
                    print(f"Instance file {instance_file} not found.")
                    continue
                
                print(f"Running {instance_file}...")
                asp_time, asp_output = run_asp_benchmark(hospital_constraints, instance_file)

                f.write(f"ASP - {complexity} instance {i}: {asp_time:.2f} seconds\n")
                f.write(asp_output + "\n\n")

                results.append([complexity, i, asp_time])

    print(f"Benchmark results written to {output_file}.")
