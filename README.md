# Repo-Search

This project is a single-page application that allows to search public Github repositories.

## Local configuration

To make more than 10 search requests per minute, you can configure the application to use API tokens for several Github accounts. It will also work without tokens, but you will only get lousy 10 rpm.

Here's a guide on creating tokens:

https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token-for-the-command-line

Tokens must be then added to `build/docker/app/dev.env` (comma separated, since it's an ENV variable):

```bash
GITHUB_ACCESS_TOKENS=TOKEN_A,TOKEN_B
```

## Running the app

Dependencies:

  - Docker

To build and start the application, simply run (assuming port 4444 is not taken):

```bash
docker-compose up
```

After the Rails app is loaded, open [http://localhost:4444](http://localhost:4444)

## Running tests

To run tests in Docker environment:

```bash
docker-compose run --rm dev rspec
```
