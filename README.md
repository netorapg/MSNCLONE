# MSN Clone

A web chat inspired by the classic MSN Messenger, built with Django. Add friends, see who is online and exchange messages that update without reloading the page.

<!-- Add a screenshot of the chat screen and one of the contact list here.
<p align="center"><img src="docs/chat.png" width="720"/></p>
-->

## Features

- **Accounts:** registration, login and logout with Django's authentication.
- **Friendships:** send a friend request, accept or decline it, remove a contact, block and unblock.
- **Chat:** one conversation per pair of friends. Messages are sent with AJAX and the conversation polls for new ones every 2 seconds.
- **Edit and delete:** you can edit or delete your own messages, also without a page reload.
- **Presence:** a custom middleware records each user's last activity; anyone active in the last 5 minutes is shown as online.
- **Search and pagination:** filter the user list and your conversations (`django-filter`), with paginated results.
- **Built-in documentation:** a page inside the app shows the UML diagrams of the system.

## Tech stack

| | |
|---|---|
| Backend | Python 3.13, Django 5.2 |
| Database | SQLite in development, PostgreSQL through `DATABASE_URL` |
| Frontend | Django templates, Bootstrap 5, Font Awesome, JavaScript (AJAX) |
| Forms and filters | django-crispy-forms, django-filter |
| Configuration | python-decouple, dj-database-url |
| Production server | gunicorn |

## Project layout

```
manage.py
msnclone/          # project settings, root URLs, WSGI/ASGI
core/              # chat: models, views, filters, presence middleware
usuarios/          # registration and login
templates/         # HTML templates
static/            # static assets, including the rendered diagrams
docs/diagramas/    # PlantUML sources
requirements.txt
```

### Models

| Model | Purpose |
|---|---|
| `Perfil` | Extends Django's `User` with last-activity tracking |
| `Contato` | Friendship between two users: pending, accepted, blocked |
| `Conversa` | A conversation between two users |
| `Mensagem` | A message inside a conversation |
| `Status` | User status options |
| `Emoticon` | Emoticon catalog |

## Running locally

Requires Python 3.13.

```bash
git clone <repository-url>
cd <repository-folder>

python -m venv .venv
source .venv/bin/activate        # Windows: .venv\Scripts\activate
pip install -r requirements.txt
```

Create a `.env` file in the project root. `DATABASE_URL` is required:

```env
DATABASE_URL=sqlite:///db.sqlite3
```

Then set up the database and start the server:

```bash
python manage.py migrate
python manage.py createsuperuser   # optional, for /admin/
python manage.py runserver
```

Open http://localhost:8000, register two accounts (one in a private window) and add each other to try the chat.

## Main routes

| Route | What it is |
|---|---|
| `/` | Home |
| `/contas/registrar/`, `/contas/login/` | Registration and login |
| `/usuarios/` | User list, with search |
| `/meus-contatos/` | Your contacts and pending requests |
| `/conversas/` | Your conversations |
| `/chat/<id>/` | Chat screen |
| `/buscar-mensagens/<id>/` | AJAX endpoint polled for new messages |
| `/documentacao/` | UML diagrams |
| `/admin/` | Django admin |

## UML diagrams

The use-case and class diagrams are written in PlantUML and live in `docs/diagramas/`. To regenerate the images:

```bash
./docs/diagramas/gerar.sh
```

This needs the `plantuml` command, or Java with `plantuml.jar` in that folder.

## Design notes

- **Polling instead of WebSockets.** New messages are fetched every 2 seconds. It is simple and works on any host; the trade-off is latency and extra requests. Moving to Django Channels is the first item on the roadmap.
- **Presence without extra infrastructure.** Online status is derived from a timestamp updated by middleware on each authenticated request, so there is no background worker or cache to operate.

## Roadmap

- [ ] Automated tests for models and views
- [ ] WebSockets (Django Channels) in place of polling
- [ ] Read `SECRET_KEY` and `DEBUG` from the environment
- [ ] Group chat
- [ ] Custom emoticons in messages
- [ ] File upload

## Background

Built as coursework for the Software Engineering degree at IFPR (Instituto Federal do Paraná). The interface is in Portuguese.

## License

<!-- The original README mentions MIT, but the repository has no LICENSE file. Add one. -->
