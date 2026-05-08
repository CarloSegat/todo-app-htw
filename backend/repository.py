from datetime import datetime
from typing import Protocol
from uuid import uuid4
from models import TodoCreate, TodoOut, TodoUpdate


# Protocol and ... syntax new in python 3.8 --> how you define interfaces
class ITodoRepo(Protocol):
    """Interface for todo persistence. Easy to swap in a DB later."""

    def get_all(self) -> list[TodoOut]: ...

    def get(self, id: str) -> TodoOut | None: ...

    def create(self, data: TodoCreate) -> TodoOut: ...

    def delete(self, id: str) -> bool: ...

    def update(self, id: str, data: TodoUpdate) -> TodoOut | None: ...


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

    def delete(self, id: str) -> bool:
        if id in self._store:
            del self._store[id]
            return True
        return False

    def update(self, id: str, data: TodoUpdate) -> TodoOut | None:
        if id not in self._store:
            return None
        
        # replace the data with what was provided
        if data.title is not None:
            self._store[id]["title"] = data.title
        if data.description is not None:
            self._store[id]["description"] = data.description
        if data.done is not None:
            self._store[id]["done"] = data.done
        
            
        return TodoOut(**self._store[id])
