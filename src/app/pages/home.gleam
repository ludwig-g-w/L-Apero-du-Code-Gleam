import lustre/element.{type Element}
import lustre/element/html

pub fn home_page() -> List(Element(t)) {
  [html.h1([], [element.text("Hello, Apero du Code!")])]
}
