defmodule ParklotRsvpWeb.InputError do
  defexception message: "Param missing or invalid", plug_status: 400
end
