# How-tos:
  1. [Run the local development](#Local)
  2. [Run the test cases](#Testing)
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
    rails server
### 4. Check:

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
## Testing:
    rspec -f doc
