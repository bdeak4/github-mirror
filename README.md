# github-mirror

## Setup

Development:

```bash
$ git clone https://github.com/bdeak4/github-mirror
$ cd chatter
$ cp .env.example .env
$ ./cgit/generate-password.sh
$ docker-compose up --build
```

Production:

```bash
$ docker-compose up --build -d
```
