# ParklotRsvp

A simple service to help our employees share the company's car parking space.

## How to make a reservation

* Request a new reservation for my slack user

`/cochera reservar el 18-08-2018`

* Request a new reservation with a work reason for my slack user

`/cochera reservar el 18-08-2018 por visita a ClienteXYZ a las 9:00am`

* Show reservations on a given date

`/cochera mostrar el 18-08-2018`

* Cancel a reservation on a given date for my slack user

`/cochera cancelar el 18-08-2018`

## Work reasons

Employees who give a work reason to their reservaton have priority over others.

### Valid work reasons

* You have to arrive the office early in the morning or leave late in the afternoon for a work related reason (e.g. Give a training or meet a client in the morning. Run a meetup or meet a client late in the afternoon)
* You have to carry some work stuff in or out the office.
* You have to visit a client who is not withing walking distance before or after going to the office.

### Invalid work reasons

The machine learning IA will pick up invalid reasons and apply a penalty to those employees who get priority access to the parking space with an invalid reason.

* You have to do personal stuff before, during or after going to the office
* You have to carry in our out personal stuff to the office
* You have to meet with a client or do some work related activity during the day (nor early neither late in the afternoon)
* You have to visit a client within walking distance from the office
* Any other regular activity that any employee does within their usual work duties.

## Contribute

### Getting started

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

### Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
