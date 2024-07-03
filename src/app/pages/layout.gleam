import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html

pub fn layout(elements: List(Element(t))) -> Element(t) {
  html.html([], [
    html.head([], [
      html.title([], "Apero du Code"),
      html.meta([
        attribute.name("viewport"),
        attribute.attribute("content", "width=device-width, initial-scale=1"),
      ]),
      // html.link([attribute.rel("stylesheet"), attribute.href("/static/app.css")]),
    ]),
    html.body([], [
      html.header([], [html.h1([], [element.text("Apero du Code!")])]),
      html.main([], elements),
    ]),
  ])
}
