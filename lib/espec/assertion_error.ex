defmodule ESpec.AssertionError do
  @moduledoc """
  Defines ESpec.AssertionError exception.
  The exception is raised by `ESpec.Assertions.Interface.raise_error/4` when example fails.
  """
  defexception subject: nil,
               data: nil,
               result: nil,
               assertion: nil,
               message: nil,
               extra: nil,
               stacktrace: nil
end
