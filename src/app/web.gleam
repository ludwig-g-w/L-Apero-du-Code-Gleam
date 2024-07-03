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

/// this middleware is used if the underlying handle_request function has
/// returned an empty body, meaning that the request could not be served. This
/// will search for typical error status and produce a page result accordingly.
fn default_responses(handle_request: fn() -> wisp.Response) -> wisp.Response {
  let response = handle_request()

  // The `bool.guard` function is used to return the original request if the
  // body is not `wisp.Empty`.
  use <- bool.guard(when: response.body != wisp.Empty, return: response)

  let error_desc = case response.status {
    400 | 422 -> "Bad request"
    404 | 405 -> "There's nothing here"
    413 -> "Request entity too large"
    418 -> "I'm a teapot"
    500 -> "Internal server error"
    _ -> "Unknown error"
  }

  ["<h1>", to_string(response.status), "</h1>", "<h2>", error_desc, "</h2>"]
  |> string_builder.from_strings
  |> wisp.html_body(response, _)
}
