from datetime import datetime
from pydantic import BaseModel, ConfigDict, Field


class TodoCreate(BaseModel):
    id: str
    title: str
    description: str = ""


class TodoOut(BaseModel):
    id: str
    title: str
    done: bool
    description: str
    created_at: datetime = Field(serialization_alias="createdAt")

    model_config = ConfigDict(
        from_attributes=True, # lets model parse from any object with .attr instead of only dictionaries
        populate_by_name=True # allows using aliases for deserialization (i.e. when building an instance of this class)
    )


class TodoUpdate(BaseModel):
    title: str | None = None
    description: str | None = None
    done: bool | None = None
