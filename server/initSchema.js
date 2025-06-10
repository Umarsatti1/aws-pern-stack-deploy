const poolPromise = require("./db");

async function createTableIfNotExists() {
  const pool = await poolPromise;
  await pool.query(`
    CREATE TABLE IF NOT EXISTS todo (
      todo_id SERIAL PRIMARY KEY,
      description VARCHAR(255)
    );
  `);
  console.log("Ensured todo table exists.");
}

module.exports = createTableIfNotExists;