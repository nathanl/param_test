# ParamTest

Demonstrate a potential issue with `Phoenix.ConnTest`.

## Expected Behavior

`Phoenix.ConnTest.get/3` should convert all params to strings, as a real `GET` request would.

## Actual Behavior

`Phoenix.ConnTest.get/3` can pass params as integers to the controller being tested

## Steps to Reproduce

- Start the app with `iex -S mix phx.server`
- Run `curl localhost:4000/api/things?count=5` and observe that `ParamTestWeb.ThingController.index/2` raises because it receives the param as a string and mistakenly expects it to be an integer. There is no way to make a successful request with `curl`, given the controller's incorrect expectation that a `GET` request can have an integer parameter.
- Run `mix test` and observe that the test in `ParamTestWeb.ThingControllerTest` passes; it does the impossible by making a `GET` request with an integer param.

## Elaboration Upon The Point, Wherein We Explain It In More Detail For Clearer Comprehension By The Reader, Using Perhaps Too Many Words

`ParamTestWeb.ThingController` has been written to expect a `GET` request with an integer parameter. As far as I can tell, this should be considered faulty application code; it's only possible to send string parameters via an HTTP `GET`.

- `curl localhost:4000/api/things?count=5` raises an error because `index/2` receives the `count` parameter as a string
- `curl -X GET -H "Content-type: application/json" -H "Accept: application/json" -d '{"count":5}' "http://localhost:4000/api/things"` raises an error because `index/2` receives empty params. (I think this is correct behavior; there is no standard requirement to handle a request body on an HTTP `GET` request.)
- To my knowledge there is no way to generate a real `GET` request whose params will be parsed by Phoenix as anything but strings

In short, there's nothing wrong with the controller; if I want `count` to be an integer, I need to explicitly parse it as an integer in my application code.

However, **ConnTest does not behave like `curl`**. The test in `ParamTestWeb.ThingControllerTest` is able to pass an integer param with a `GET` request and it is received by the controller as an integer. Since it does not reflect the way real requests will work, it makes the controller code appear valid when it can't actually work for real `GET` requests.
