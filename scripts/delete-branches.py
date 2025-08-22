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


def main():
    local_branches = get_local_branches()
    remote_branches = get_remote_branches()

    print(f"\n{BOLD}All local branches:{RESET}\n")
    marked_for_deletion = []

    for i, branch in enumerate(local_branches, start=1):
        has_remote = branch in remote_branches
        status_color = GREEN if has_remote else YELLOW
        status = f"{status_color}[remote exists]{RESET}" if has_remote else f"{status_color}[no remote]{RESET}"
        print(f"{BOLD}{i}{RESET}. {branch} {status}")

    print("\n🌳🗑️")
    print(f"{BOLD}Enter branch number to mark for deletion{RESET}.")
    print("Comma-separated. Example: 1,3,5")
    print("Leave empty to skip.\n")

    choice = input(f"{BOLD}Which branch do you want to delete? {RESET}\n👉 ").strip()
    if not choice:
        print("No branch selected. Exiting.")
        return

    try:
        indices = [int(x.strip()) for x in choice.split(",")]
    except ValueError:
        print(f"{RED}Invalid input. Please enter numbers separated by commas.{RESET}")
        return

    for idx in indices:
        if 1 <= idx <= len(local_branches):
            marked_for_deletion.append(local_branches[idx - 1])
        else:
            print(f"{RED}Invalid branch number: {idx}{RESET}")

    if not marked_for_deletion:
        print("No valid branch selected. Exiting.")
        return

    print(f"\n{BOLD}Marked for deletion:{RESET}")
    for b in marked_for_deletion:
        print(f"{RED}-{RESET} {b}")
    
    confirm = input(f"\n{BOLD}Do you want to delete above branch(es)?{RESET} (y/N)\n👉 ").strip().lower()
    if confirm != "y":
        print("\nNo branch deleted. Exiting.")
        return

    if marked_for_deletion:
        print(f"\n{BOLD}Deleting…{RESET}")
        for b in marked_for_deletion:
            result = subprocess.run(["git", "branch", "-D", b], capture_output=True, text=True)
            if result.returncode == 0:
                print(f"✅ Deleted `{b}` successfully.")
            else:
                print(f"{RED}Error{RESET} deleting {b}:\n{result.stderr}")

    print("\nDone!\n🌳🗑️")


if __name__ == "__main__":
    main()
