defmodule ESpec.Example do
  @moduledoc """
  Defines macros 'example' and 'it'.
  These macros defines function with random name which will be called when example runs.
  Example structs %ESpec.Example are accumulated in @examples attribute
  """

  @type t :: %__MODULE__{}

  @doc """
  Example struct.
  description - the description of example,
  module - spec module,
  function - random function name,
  opts - options,
  file - spec file path,
  line - the line where example is defined,
  context - example context. Accumulator for 'contexts' and 'lets',
  shared - marks example as shared,
  status - example status (:new, :success, :failure, :pending),
  result - the value returned by example block or the pending message,
  error - store an error,
  duration - test duration.
  """
  defstruct description: "",
            module: nil,
            function: nil,
            opts: [],
            file: nil,
            line: nil,
            context: [],
            shared: false,
            status: :new,
            result: nil,
            error: nil,
            duration: 0

  @doc "Context descriptions."
  def context_descriptions(example) do
    example
    |> extract_contexts
    |> Enum.map(& &1.description)
  end

  @doc "Filters success examples."
  def success(results), do: Enum.filter(results, &(&1.status == :success))

  @doc "Filters failed examples."
  def failure(results), do: Enum.filter(results, &(&1.status === :failure))

  @doc "Filters pending examples."
  def pendings(results), do: Enum.filter(results, &(&1.status === :pending))

  @doc "Extracts specific structs from example context."
  def extract_befores(example), do: extract(example.context, ESpec.Before)
  def extract_lets(example), do: extract(example.context, ESpec.Let)
  def extract_finallies(example), do: extract(example.context, ESpec.Finally)
  def extract_contexts(example), do: extract(example.context, ESpec.Context)

  @doc "Extracts example option."
  @spec extract_option(t(), option :: atom()) :: nil | any()
  def extract_option(example, option) do
    example
    |> extract_options()
    |> Map.get(option)
  end

  @doc "Extracts example options as they are currently valid for this example as map."
  @spec extract_options(t()) :: %{required(atom()) => any()}
  def extract_options(example) do
    example
    |> extract_all_options()
    |> Enum.uniq_by(fn {key, _} -> key end)
    |> Map.new()
  end

  @doc "Extracts example options from most specific to least specific as Keyword list. Can include duplicates."
  @spec extract_all_options(t()) :: Keyword.t()
  def extract_all_options(example) do
    contexts = ESpec.Example.extract_contexts(example)
    List.flatten(example.opts ++ Enum.reverse(Enum.map(contexts, & &1.opts)))
  end

  def extract(context, module) do
    Enum.filter(context, &(&1.__struct__ == module))
  end

  @doc "Message for skipped examples."
  def skip_message(example) do
    skipper = extract_option(example, :skip)

    if skipper === true do
      "Temporarily skipped without a reason."
    else
      "Temporarily skipped with: #{skipper}."
    end
  end

  @doc "Message for pending examples."
  def pending_message(example) do
    if example.opts[:pending] === true do
      "Pending example."
    else
      "Pending with message: #{example.opts[:pending]}."
    end
  end
end
