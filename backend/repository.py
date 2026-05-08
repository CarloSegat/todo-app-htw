from datetime import datetime
from typing import Protocol
from uuid import uuid4
from models import TodoCreate, TodoOut


# Protocol and ... syntax new in python 3.8 --> how you define interfaces
class ITodoRepo(Protocol):
    """Interface for todo persistence. Easy to swap in a DB later."""

    def get_all(self) -> list[TodoOut]: ...

    def get(self, id: str) -> TodoOut | None: ...

    def create(self, data: TodoCreate) -> TodoOut: ...


class InMemoryTodoRepo:
    """In-memory implementation. Starts fresh on every restart."""

    def __init__(self):
        self._store: dict[str, dict] = {}

    def get_all(self) -> list[TodoOut]:
        return [TodoOut(**item) for item in self._store.values()]

    def get(self, id: str) -> TodoOut | None:
        if id in self._store:
            return TodoOut(**self._store[id])
        return None

    def create(self, data: TodoCreate) -> TodoOut:
        id = str(uuid4())
        item = {
            "id": id,
            "title": data.title,
            "description": data.description,
            "done": False,
            "created_at": datetime.now(),
        }
        self._store[id] = item
        return TodoOut(**item)
