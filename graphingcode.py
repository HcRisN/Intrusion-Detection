import matplotlib.pyplot as plt
import re

def parse_log_file(file_path):
    with open(file_path, "r") as file:
        lines = file.readlines()

    timestamps = []
    cpu_usages = []
    ram_usages = []
    storage_percentages = []

    for line in lines:
        if "Timestamp:" in line:
            timestamp = line.split(": ")[1].strip()
            timestamps.append(timestamp)
        elif "CPU Usage:" in line:
            cpu_usage = int(re.findall(r'\d+', line)[0])
            cpu_usages.append(cpu_usage)
        elif "RAM Usage:" in line:
            ram_usage = int(re.findall(r'\d+', line)[0])
            ram_usages.append(ram_usage)
        elif "Storage Percentage:" in line:
            storage_percentage = int(re.findall(r'\d+', line)[0])
            storage_percentages.append(storage_percentage)

    return timestamps, cpu_usages, ram_usages, storage_percentages

def plot_data(timestamps, cpu_usages, ram_usages, storage_percentages):
    plt.figure(figsize=(10, 6))

    plt.plot(timestamps, cpu_usages, label='CPU Usage (%)')
    plt.plot(timestamps, ram_usages, label='RAM Usage (%)')
    plt.plot(timestamps, storage_percentages, label='Storage Usage (%)')

    plt.xlabel('Time')
    plt.ylabel('Usage (%)')
    plt.title('System Resource Usage Over Time')
    plt.xticks(rotation=45)
    plt.legend()

    plt.tight_layout()
    plt.show()

def main():
    file_path = input("Enter the path to the intrusion detection log file: ")
    timestamps, cpu_usages, ram_usages, storage_percentages = parse_log_file(file_path)
    plot_data(timestamps, cpu_usages, ram_usages, storage_percentages)

if __name__ == "__main__":
    main()

