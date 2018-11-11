defmodule Fakes.Post do
  use Resty.Resource

  @moduledoc false

  set_site("site.tld")
  set_resource_path("posts")
  add_header(:Custom, "hello")

  field(:id)
  field(:name)

  def existing, do: build(id: 1)
  def valid, do: build(name: "test")
  def invalid, do: build(name: "invalid")
  def non_existent, do: build(id: "non_existent")
end
