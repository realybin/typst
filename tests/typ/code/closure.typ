// Test closures.
// Ref: false

---
// Don't parse closure directly in template.
// Ref: true

#let x = "\"hi\""

// Should output `"hi" => "bye"`.
#x => "bye"

---
// Basic closure without captures.
{
  let adder = (x, y) => x + y
  test(adder(2, 3), 5)
}

---
// Pass closure as argument and return closure.
// Also uses shorthand syntax for a single argument.
{
  let chain = (f, g) => (x) => f(g(x))
  let f = x => x + 1
  let g = x => 2 * x
  let h = chain(f, g)
  test(h(2), 5)
}

---
// Capture environment.
{
  let mark = "?"
  let greet = {
    let hi = "Hi"
    name => {
        hi + ", " + name + mark
    }
  }

  test(greet("Typst"), "Hi, Typst?")

  mark = "!"
  test(greet("Typst"), "Hi, Typst!")
}

---
// Redefined variable.
{
  let x = 1
  let f() = {
    let x = x + 2
    x
  }
  test(f(), 3)
}

---
// Don't leak environment.
{
  // Error: 16-17 unknown variable
  let func() = x
  let x = "hi"
  func()
}

---
// Too few arguments.
{
  let types(x, y) = "[" + type(x) + ", " + type(y) + "]"
  test(types(14%, 12pt), "[relative, length]")

  // Error: 14-20 missing argument: y
  test(types("nope"), "[string, none]")
}

---
// Too many arguments.
{
  let f(x) = x + 1

  // Error: 8-13 unexpected argument
  f(1, "two", () => x)
}
