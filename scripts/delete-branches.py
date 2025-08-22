#!/usr/bin/env python3
import subprocess
import sys

# ANSI color codes
RED = "\033[31m"
GREEN = "\033[32m"
YELLOW = "\033[33m"
BOLD = "\033[1m"
RESET = "\033[0m"


def run_git_command(args):
    """Run a git command and return its output as a list of lines."""
    result = subprocess.run(
        ["git"] + args,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
    )
    if result.returncode != 0:
        print(f"{RED}Error running git {' '.join(args)}:{RESET}\n{result.stderr}")
        sys.exit(1)
    return result.stdout.strip().split("\n")


def get_local_branches():
    """Return a list of local branches (excluding the current one marker *)."""
    branches = run_git_command(["branch"])
    return [b.strip().lstrip("* ").strip() for b in branches]


def get_remote_branches():
    """Return a set of remote branch names (without remote prefix)."""
    branches = run_git_command(["branch", "-r"])
    cleaned = []
    for b in branches:
        b = b.strip()
        if "->" in b:  # skip remote HEAD pointers
            continue
        # remove remote name (e.g., origin/feature -> feature)
        parts = b.split("/", 1)
        if len(parts) == 2:
            cleaned.append(parts[1])
    return set(cleaned)


def parse_indices(choice, max_index):
    """Parse a string of indices and ranges into a list of integers."""
    indices = set()
    parts = choice.split(",")
    for part in parts:
        part = part.strip()
        if not part:
            continue
        if "-" in part:
            try:
                start, end = map(int, part.split("-", 1))
                if start > end:
                    start, end = end, start  # allow reversed ranges
                for i in range(start, end + 1):
                    if 1 <= i <= max_index:
                        indices.add(i)
            except ValueError:
                print(f"{RED}Invalid range: {part}{RESET}")
        else:
            try:
                i = int(part)
                if 1 <= i <= max_index:
                    indices.add(i)
                else:
                    print(f"{RED}Invalid branch number: {i}{RESET}")
            except ValueError:
                print(f"{RED}Invalid input: {part}{RESET}")
    return sorted(indices)


def main():
    local_branches = get_local_branches()
    remote_branches = get_remote_branches()

    print(f"\n{BOLD}All local branches:{RESET}\n")
    for i, branch in enumerate(local_branches, start=1):
        has_remote = branch in remote_branches
        status_color = GREEN if has_remote else YELLOW
        status = (
            f"{status_color}[remote exists]{RESET}"
            if has_remote
            else f"{status_color}[no remote]{RESET}"
        )
        print(f"{BOLD}{i}{RESET}. {branch} {status}")

    print("\n🌳🗑️")
    print(f"{BOLD}Enter branch number to mark for deletion{RESET}.")
    print("Supports comma-separated and ranges. Example: 1,3,5,10-12")
    print("Leave empty to skip.")

    choice = input(f"👉 ").strip()
    if not choice:
        print("\n⚠️ No branch selected.")
        return

    indices = parse_indices(choice, len(local_branches))
    marked_for_deletion = [local_branches[i - 1] for i in indices]

    if not marked_for_deletion:
        print("\n⚠️ No valid branch selected..")
        return

    print(f"\n{BOLD}Marked for deletion:{RESET}")
    for b in marked_for_deletion:
        print(f"{RED}-{RESET} {b}")

    confirm = input(
        f"\n{BOLD}Do you want to delete the above {len(marked_for_deletion)} branch"
        f"{'es' if len(marked_for_deletion) > 1 else ''}?{RESET} (y/N)\n👉 "
    ).strip().lower()
    if confirm not in ("y", "yes"):
        print("\n⚠️ No branch deleted.")
        return

    if marked_for_deletion:
        print(f"\n{BOLD}Cleaning up…{RESET}")
        for b in marked_for_deletion:
            result = subprocess.run(
                ["git", "branch", "-D", b], capture_output=True, text=True
            )
            if result.returncode == 0:
                print(f"✅ Deleted `{b}` successfully.")
            else:
                print(f"{RED}Error{RESET} deleting {b}:\n{result.stderr}")

if __name__ == "__main__":
    main()
