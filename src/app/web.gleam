import gleam/bool
import gleam/http.{Get}
import gleam/int.{to_string}
import gleam/string_builder
import wisp

/// The middleware stack that the request handler uses. The stack is itself a
/// middleware function!
///
/// Middleware wrap each other, so the request travels through the stack from
/// top to bottom until it reaches the request handler, at which point the
/// response travels back up through the stack.
/// 
/// The middleware used here are the ones that are suitable for use in your
/// typical web application.
/// 
pub fn middleware(
  req: wisp.Request,
  handle_request: fn(wisp.Request) -> wisp.Response,
) -> wisp.Response {
  // Permit browsers to simulate methods other than GET and POST using the
  // `_method` query parameter.
  let req = wisp.method_override(req)

  // Log information about the request and response.
  use <- wisp.log_request(req)

  // Return a default 500 response if the request handler crashes.
  use <- wisp.rescue_crashes

  // Rewrite HEAD requests to GET requests and return an empty body.
  use req <- wisp.handle_head(req)

  use <- wisp.require_method(req, Get)

  use <- default_responses

  // Handle the request!
  handle_request(req)
}

fn default_responses(handle_request: fn() -> wisp.Response) -> wisp.Response {
  let response = handle_request()

  // The `bool.guard` function is used to return the original request if the
  // body is not `wisp.Empty`.
  use <- bool.guard(when: response.body != wisp.Empty, return: response)

  // You can use any logic to return appropriate responses depending on what is
  // best for your application.
  // I'm going to match on the status code and depending on what it is add
  // different HTML as the body. This is a good option for most applications.
  case response.status {
    404 | 405 ->
      [
        "<h1>",
        to_string(response.status),
        "</h1>",
        "<h2>There's nothing here</h2>",
      ]
      |> string_builder.from_strings
      |> wisp.html_body(response, _)

    400 | 422 ->
      ["<h1>", to_string(response.status), "</h1>", "<h2>Bad request</h2>"]
      |> string_builder.from_strings
      |> wisp.html_body(response, _)

    413 ->
      [
        "<h1>",
        to_string(response.status),
        "</h1>",
        "<h2>Request entity too large</h2>",
      ]
      |> string_builder.from_strings
      |> wisp.html_body(response, _)

    418 ->
      ["<h1>", to_string(response.status), "</h1>", "<h2> I'm a teapot"]
      |> string_builder.from_strings
      |> wisp.html_body(response, _)

    500 ->
      [
        "<h1>",
        to_string(response.status),
        "</h1>",
        "<h2>Internal server error</h2>",
      ]
      |> string_builder.from_strings
      |> wisp.html_body(response, _)

    // For other status codes redirect to the home page
    _ ->
      ["<h1>", to_string(response.status), "</h1>", "<h2>Unknown error</h2>"]
      |> string_builder.from_strings
      |> wisp.html_body(response, _)
  }
}
