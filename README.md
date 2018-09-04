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

## Email notifications

Email notification with the reservation selected will be sent only to the users who have scheduled a reservation on that day. The Slack user name should match with the email address or email alias (E.g. Slack user 'egutter' should match with email 'egutter@10pines.com')

## Work reasons

Employees who give a work reason to their reservaton have priority over others.

### Valid work reasons

* You have to arrive the office early in the morning or leave late in the afternoon for a work related reason (e.g. Give a training or meet a client in the morning. Run a meetup or meet a client late in the afternoon)
* You have to carry some work stuff in or out the office.
* You have to visit a client who is not withing walking distance before or after going to the office.

### Invalid work reasons

The AI machine learning algorithm will pick up invalid reasons and apply a penalty to those employees who get priority access to the parking space with an invalid reason.

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

### Google Calendar Integration

We are using google calendar integration for creating an event when the reservation is confirmed.

Before starting up the server, you need to setup some environment variables:

#### Authentication
`GOOGLE_PRIVATE_KEY_ID`: unique identifier for the user private key,
`GOOGLE_PRIVATE_KEY`: the actual private key. 
`GOOGLE_CLIENT_EMAIL`: service account email.
`GOOGLE_CLIENT_ID`: the service account id.

For develop, we reccomend to generate an auth file for the service acccount (see [Google Documentation](https://developers.google.com/identity/protocols/OAuth2ServiceAccount#creatinganaccount) for more info) and simply set the file path in the `GOOGLE_APPLICATION_CREDENTIALS` environment variable:

```
export GOOGLE_APPLICATION_CREDENTIALS=/path/to/the/file.json
```

#### Calendar specific
`GOOGLE_CALENDAR_ID`: the calendar ID. The service account needs to have write permissions over the calendar. **This variable is mandatory** regardless the authentication method you choose. If this variable isn't set, the application **will not generate a calendar event**


### Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
