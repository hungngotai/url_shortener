# How-tos:
  1. [Run with local machine (Linux/MacOS)](#local-develoment-steps)
  1. [Run with docker](#docker-develoment-steps)
  2. [Run the test cases](#testing)
## Local Develoment Steps:
### Prerequisites:
 1. Ruby v3.0.0
 2. Rails v6.1.7
 3. Postgresql v14 is running on local machine
### 1. Build :
    git clone git@github.com:hungngotai/url_shortener.git
    cd url_shortener
    bundle install
### 2. Set up database :

    bundle exec rails db:setup
### 3. Run development :
    rails server -b 0.0.0.0
## Docker Develoment Steps:
### Prerequisites:
 1. Docker
 2. Docker Compose
### 1. Build:
    git clone git@github.com:hungngotai/url_shortener.git
    cd url_shortener
    docker compose up
### 2. Set up database:

    docker compose exec web rails db:setup
### 3. To debug:
    docker compose stop web
    docker compose run web rails server -b 0.0.0.0
## Testing:
### 1. Request to server:

    curl --location --request POST 'localhost:3000/encode' \
    --header 'Content-Type: application/json' \
    --data-raw '{
        "url": "http://google.com"
    }'
    # and
    curl --location --request POST 'localhost:3000/decode' \
    --header 'Content-Type: application/json' \
    --data-raw '{
        "url": "[replace with above url]"
    }'
### 2. Check the test suite:
    rspec -f doc
