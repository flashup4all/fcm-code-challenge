defmodule FcmCodeChallenge do
  @moduledoc """
  Documentation for `FcmCodeChallenge`.
  """

  def get_input_file(src) do
    File.read(src)
  end

  def process_input(src) do
    case File.read(src) do
      {:ok, text} ->
        text
        |> String.split("\n", trim: true) |> match_train
      error -> error
    end
  end

  def match_train(list) do
    list = Enum.map(list, &(do_match/1)) |> Enum.filter(& !is_nil(&1))
    reservations = Enum.filter(list, &(Map.has_key?(&1, :reservation_type)))
    transportation_bookings = Enum.filter(list, &(Map.has_key?(&1, :transport_type)))
    %{ reservations: reservations, trips: transportation_bookings}
    new_list =
    Enum.map(reservations, fn reservation ->
      Map.put(reservation, :to_ticket,  Enum.find(transportation_bookings, &(&1.to_location == reservation.location)))
      |> Map.put(:return_ticket,  Enum.find(transportation_bookings, &(&1.from_location == reservation.location)))
    end)
    Enum.each(new_list, &(
      IO.puts "TRIP to #{&1.location} \n#{&1.to_ticket.transport_type} from #{&1.to_ticket.from_location} to #{&1.to_ticket.to_location} at #{&1.to_ticket.from_date} #{&1.to_ticket.from_time} to #{&1.to_ticket.to_time}\n#{&1.reservation_type} at #{&1.location} on #{&1.from_date} to #{&1.to_date} \n#{&1.return_ticket.transport_type} from #{&1.return_ticket.from_location} to #{&1.return_ticket.to_location} at #{&1.return_ticket.from_date} #{&1.return_ticket.from_time} to #{&1.return_ticket.to_time} \n"
      ))
  end

  @spec do_match(any) ::
          nil
          | %{
              :from_date => binary,
              optional(:from_location) => binary,
              optional(:from_time) => binary,
              optional(:location) => binary,
              optional(:reservation_type) => <<_::40>>,
              optional(:to_date) => binary,
              optional(:to_location) => binary,
              optional(:to_time) => binary,
              optional(:transport_type) => any
            }
  def do_match("SEGMENT: Flight " <> rest), do: format_transport_data("Flight", rest)

  def do_match("SEGMENT: Train " <> rest), do: format_transport_data("Train", rest)

  def do_match("SEGMENT: Hotel " <> rest) do
    [ location, from_date, "->", to_date] = rest |> String.split(" ", trim: true)
    %{ reservation_type: "Hotel", location: location, from_date: from_date, to_date: to_date }
  end

  def do_match(_string), do: nil

  def format_transport_data(type, string) do
    [from_location, from_date, from_time, "->", to_location, to_time] = string |> String.split(" ", trim: true)
    %{ transport_type: type, from_location: from_location, from_date: from_date, from_time: from_time, to_location: to_location, to_time: to_time }
  end
end
