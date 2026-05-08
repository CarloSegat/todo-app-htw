from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from models import TodoCreate, TodoOut, TodoUpdate
from repository import InMemoryTodoRepo, ITodoRepo

app = FastAPI(title="Todo API")

# Global instance for now. Could be thread-safe or use a database later.
_repo = InMemoryTodoRepo()


def get_repo() -> ITodoRepo:
    """Dependency injection: provides the repo to endpoints."""
    # print("uncomment to see when get_repo is called")
    return _repo


@app.get("/todos", response_model=list[TodoOut])
def list_todos(repo: ITodoRepo = Depends(get_repo)):
    return repo.get_all()


@app.post("/todos", response_model=TodoOut, status_code=201)
def create_todo(data: TodoCreate, repo: ITodoRepo = Depends(get_repo)):
    return repo.create(data)


@app.get("/todos/{id}", response_model=TodoOut)
def get_todo(id: str, repo: ITodoRepo = Depends(get_repo)):
    todo = repo.get(id)
    if not todo:
        raise HTTPException(status_code=404, detail="Todo not found")
    return todo


@app.put("/todos/{id}", response_model=TodoOut)
def update_todo(id: str, data: TodoUpdate, repo: ITodoRepo = Depends(get_repo)):
    todo = repo.update(id, data)
    if not todo:
        raise HTTPException(status_code=404, detail="Todo not found")
    return todo


@app.delete("/todos/{id}", status_code=204)
def delete_todo(id: str, repo: ITodoRepo = Depends(get_repo)):
    if not repo.delete(id):
        raise HTTPException(status_code=404, detail="Todo not found")
