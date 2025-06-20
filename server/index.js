const express = require("express");
const app = express();
const cors = require("cors");
const poolPromise = require("./db");
const createTableIfNotExists = require("./initSchema");

app.use(cors());
app.use(express.json());

(async () => {
  await createTableIfNotExists();
})();

app.post("/todos", async (req, res) => {
  try {
    const pool = await poolPromise;
    const { description } = req.body;
    const newTodo = await pool.query(
      "INSERT INTO todo (description) VALUES($1) RETURNING *",
      [description]
    );
    res.json(newTodo.rows[0]);
  } catch (err) {
    console.error(err.message);
    res.status(500).send("Server error");
  }
});

app.get("/todos", async (req, res) => {
  try {
    const pool = await poolPromise;
    const allTodos = await pool.query("SELECT * FROM todo");
    res.json(allTodos.rows);
  } catch (err) {
    console.error(err.message);
    res.status(500).send("Server error");
  }
});

app.get("/todos/:id", async (req, res) => {
  try {
    const pool = await poolPromise;
    const { id } = req.params;
    const todo = await pool.query("SELECT * FROM todo WHERE todo_id = $1", [id]);
    res.json(todo.rows[0]);
  } catch (err) {
    console.error(err.message);
    res.status(500).send("Server error");
  }
});

app.put("/todos/:id", async (req, res) => {
  try {
    const pool = await poolPromise;
    const { id } = req.params;
    const { description } = req.body;
    await pool.query("UPDATE todo SET description = $1 WHERE todo_id = $2", [description, id]);
    res.json("To-do was updated!");
  } catch (err) {
    console.error(err.message);
    res.status(500).send("Server error");
  }
});

app.delete("/todos/:id", async (req, res) => {
  try {
    const pool = await poolPromise;
    const { id } = req.params;
    await pool.query("DELETE FROM todo WHERE todo_id = $1", [id]);
    res.json("To-do was deleted!");
  } catch (err) {
    console.error(err.message);
    res.status(500).send("Server error");
  }
});

app.listen(5000, () => {
  console.log("Server running on port 5000");
});