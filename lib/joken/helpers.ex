defmodule Joken.Helpers do
  
  @doc """
  Helper function for validating time claims (exp, nbf, iat)
  """
  def validate_time_claim(payload, key, error_msg, validate_time_fun) do
    key_found? = Dict.has_key?(payload, key)
    value = Dict.get(payload, key)
    current_time = get_current_time()

    cond do
      key_found? and validate_time_fun.(value, current_time) ->
        :ok
      key_found? and !validate_time_fun.(value, current_time) ->
        {:error, error_msg}
      true ->
        :ok
    end
  end


  @doc """
  Helper function for validating non-time claims
  """
  def validate_claim(payload, key_to_check, value, full_name) do
    key_found? = Dict.has_key?(payload, key_to_check)
    the_value = Dict.get(payload, key_to_check)

    cond do
      value == nil ->
        :ok
      key_found? and the_value == value ->
        :ok
      key_found? and the_value != value ->
        {:error, "Invalid #{full_name}"}
      !key_found? ->
        {:error, "Missing #{full_name}"}
      true ->
        :ok
    end
  end
  

  @doc """
  Helper function to get the current time
  """
  def get_current_time() do
    {mega, secs, _} = :os.timestamp()
    mega * 1000000 + secs
  end
  
    
end
