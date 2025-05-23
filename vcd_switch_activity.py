import sys
from vcdvcd import VCDVCD

def compute_toggle_counts(vcd_path):
    vcd = VCDVCD(vcd_path, signals=None, store_tvs=True)
    toggles = {}
    for symbol, signal in vcd.data.items():
        try:
            name = '.'.join(signal.references)  # hierarchical signal name
            tvs = signal.tv  # list of (time, value) pairs
            count = 0
            last_val = None
            for time, val in tvs:
                if last_val is not None and val != last_val:
                    count += 1
                last_val = val
            toggles[name] = count
        except Exception as e:
            print(f"Skipping signal due to error: {e}")
            continue
    return toggles

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python3 vcd_switch_activity.py <file.vcd>")
        sys.exit(1)

    file_path = sys.argv[1]
    toggle_counts = compute_toggle_counts(file_path)
    for signal, count in toggle_counts.items():
        print(f"{signal}: {count} toggles")

