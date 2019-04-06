# Plus Code Demo in Swift

> Note: This is not an official Google product.

This sample container is a very simple web server that can convert a
latitude and longitude coordinate into a [Plus Code](https://plus.codes), a concise way to represent location coordinates, usable in Google Maps and other map tools.

It uses the [Open Location Code for Swift](https://github.com/google/open-location-code-swift) open source library for the conversion, and the [Swifter HTTP engine](https://github.com/httpswift/swifter) to handle the requests.

This sample container was demonstrated in the Google Next '19 session [Deploy Your Next Application to Google Kubernetes Engine](https://www.youtube.com/watch?v=JDBq2JvzQOY&list=PLIivdWyY5sqKqrrodcI34M_0Di4B5GFIP
).

## Build

`docker build . -t pluscodedemo`

## Run

`docker run -it -p 8080:80 pluscodedemo`

## Usage

Browse to localhost:8080/*[Latitude]*,*[Longitude]*

e.g. http://localhost:8080/37.784173,-122.401557