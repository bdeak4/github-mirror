import requests
import os
import time

user = os.getenv("GITHUB_USER")
pat = os.getenv("GITHUB_TOKEN")

logger = f">>./logs/sync_repositories_{int(time.time())}.log 2>&1"


def run(cmd):
    status = os.system(f"{cmd} {logger}")
    if status != 0:
        raise Exception(f'"{cmd}" returned status code {status}')


def sync_repository(name, clone_url, is_private):
    path = f"./repositories/{'private' if is_private else 'public'}/{name}"

    run(f"echo {name}")
    if not os.path.exists(path):
        run(f"git clone --mirror {clone_url} {path}")

    else:
        run(f"git -C {path} fetch --all")


r = requests.get(f"https://api.github.com/user/repos", auth=(user, pat))

for repo in r.json():
    if repo["owner"]["login"] != user:
        continue

    sync_repository(repo["name"], repo["ssh_url"], repo["private"])
