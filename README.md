# Rateconf OCR
Data Entry Project

## About
This repo contains API(rateconfocr) for extracting rate confirmation document information from pdfs and web client(frontend) for testing it.
Web API uses AWS Textract api to extract key value pair, table and text data from the pdf.

## Install

### Clone the repository

```shell
git clone git@github.com:GPTransco/rateconfocr.git
```

### Check your Ruby version

```shell
ruby -v
```

The ouput should start with something like `ruby 3.1.0`

If not, install the right ruby version using [rbenv](https://github.com/rbenv/rbenv) (it could take a while):

```shell
rbenv install 3.1.0
```

### Install dependencies

Using [Bundler](https://github.com/bundler/bundler) and [Yarn](https://github.com/yarnpkg/yarn):

```shell
bundle && yarn
```

### Initialize the database

```shell
rails db:create db:migrate db:seed
```

### Create HMAC key for encrypting API tokens in the database
```shell
export API_KEY_HMAC_SECRET_KEY=testHmacSecret
```

## Serve

```shell
foreman start -f Procfile.dev
```
