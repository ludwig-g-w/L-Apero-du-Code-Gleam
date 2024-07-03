import app/pages/home
import app/pages/layout
import app/web
import lustre/element
import lustre/element/html
import wisp.{type Request, type Response}

/// The HTTP request handler- your application!
/// 
pub fn handle_request(req: Request) -> Response {
  // Apply the middleware stack for this request/response.
  use _req <- web.middleware(req)

  case wisp.path_segments(req) {
    ["foo", "bar"] -> {
      [html.h2([], [element.text("Foo, Bar!")])]
      |> layout.layout
      |> element.to_document_string_builder
      |> wisp.html_response(200)
    }
    ["favicon.ico"] -> static_file(req)
    [] -> {
      // Give the home page by default.
      home.home_page()
      |> layout.layout
      |> element.to_document_string_builder
      |> wisp.html_response(200)
    }
    _ -> wisp.not_found()
  }
}

fn static_file(req: Request) -> Response {
  use <- wisp.serve_static(req, under: "/", from: "./priv/static/")
  wisp.ok()
}
