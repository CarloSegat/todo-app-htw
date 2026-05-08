# Setup
`pip install -r requirements.txt`
OR `pip3 install -r requirements.txt`

# Run the server
`uvicorn main:app --reload`

# Test TODO creation 
`curl -X POST http://localhost:8000/todos -H "Content-Type: application/json" -d '{"title": "My Task", "description": "Task description"}'`

# Test TODO retireval 
either `curl GET http://localhost:8000/todos`
or visit `http://localhost:8000/todos` on your browser 