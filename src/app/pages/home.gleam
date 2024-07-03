import lustre/element.{type Element}
import lustre/element/html

pub fn home_page() -> List(Element(t)) {
  [html.h2([], [element.text("Hello!")])]
}
