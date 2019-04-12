defmodule ExampleHasOptionTest do
  use ExUnit.Case, async: true

  defmodule SomeSpec do
    use ESpec, a: true, b: true

    context "some context", c: true, d: true do
      it "test", e: true, f: true do
        "example"
      end
    end

    context "override some options", a: false do
      it "test", b: false do
        "example"
      end

      context "override again", a: true, b: true do
        it "test", b: false do
          "example"
        end
      end
    end
  end

  setup_all do
    {:ok,
     ex1: Enum.at(SomeSpec.examples(), 0),
     ex2: Enum.at(SomeSpec.examples(), 1),
     ex3: Enum.at(SomeSpec.examples(), 2)}
  end

  test ".extract_option ex1, <option> returns the expected values", context do
    ex = context[:ex1]

    assert ESpec.Example.extract_option(ex, :a) == true
    assert ESpec.Example.extract_option(ex, :b) == true
    assert ESpec.Example.extract_option(ex, :c) == true
    assert ESpec.Example.extract_option(ex, :d) == true
    assert ESpec.Example.extract_option(ex, :e) == true
    assert ESpec.Example.extract_option(ex, :f) == true
    assert ESpec.Example.extract_option(ex, :g) == nil
  end

  test ".extract_option ex2, <option> returns the expected values", context do
    ex = context[:ex2]

    assert ESpec.Example.extract_option(ex, :a) == false
    assert ESpec.Example.extract_option(ex, :b) == false
    assert ESpec.Example.extract_option(ex, :c) == nil
  end

  test ".extract_option ex3, <option> returns the expected values", context do
    ex = context[:ex3]

    assert ESpec.Example.extract_option(ex, :a) == true
    assert ESpec.Example.extract_option(ex, :b) == false
    assert ESpec.Example.extract_option(ex, :c) == nil
  end
end
