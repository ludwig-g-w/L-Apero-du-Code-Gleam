import app/web
import gleam/http.{Get}
import gleam/string_builder
import wisp.{type Request, type Response}

/// The HTTP request handler- your application!
/// 
pub fn handle_request(req: Request) -> Response {
  // Apply the middleware stack for this request/response.
  use _req <- web.middleware(req)

  case wisp.path_segments(req) {
    // this matched "/"
    [] -> home_page(req)

    ["favicon.ico"] -> static_file(req)

    _ -> wisp.not_found()
  }
}

fn home_page(req: Request) -> Response {
  use <- wisp.require_method(req, Get)

  // Later we'll use templates, but for now a string will do.
  let body = string_builder.from_string("<h1>Hello, Joe!</h1>")

  // Return a 200 OK response with the body and a HTML content type.
  wisp.html_response(body, 200)
}

fn static_file(req: Request) -> Response {
  use <- wisp.serve_static(req, under: "/", from: "./priv/static/")
  wisp.ok()
}
