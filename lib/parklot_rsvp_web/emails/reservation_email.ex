defmodule ParklotRsvpWeb.ReservationEmail do
  use Bamboo.Phoenix, view: ParklotRsvpWeb.ReservationEmailView

  def reservation_confirmed_email(users_emails, confirmed_reservation) do
    new_email()
    |> to(users_emails)
    |> from("cochera@10Pines.com")
    |> subject("[#{confirmed_reservation.scheduled_at}] Cochera confirmada")
    |> text_body(text_body(confirmed_reservation))
    |> html_body(html_body(confirmed_reservation))
  end

  defp html_body(confirmed_reservation) do
    """
      <p>En la fecha <b>#{confirmed_reservation.scheduled_at}</b> se ha confirmado la siguiente reserva</p>

      <table>
        <tr><td>Usuario:</td><td>#{confirmed_reservation.user}</td></tr>
        <tr><td>Motivo:</td><td>#{confirmed_reservation.notes}</td></tr>
        <tr><td>Relacionado al trabajo?</td><td>#{confirmed_reservation.work_related}</td></tr>
      </table>
    """
  end

  defp text_body(confirmed_reservation) do
    """
      En la fecha #{confirmed_reservation.scheduled_at} se ha confirmado la siguiente reserva\n

      Usuario: #{confirmed_reservation.user}\n
      Motivo: #{confirmed_reservation.notes}\n
      Relacionado al trabajo? #{confirmed_reservation.work_related}
    """
  end
end
